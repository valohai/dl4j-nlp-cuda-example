/*******************************************************************************
 * Copyright (c) 2015-2019 Skymind, Inc.
 *
 * This program and the accompanying materials are made available under the
 * terms of the Apache License, Version 2.0 which is available at
 * https://www.apache.org/licenses/LICENSE-2.0.
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
 * License for the specific language governing permissions and limitations
 * under the License.
 *
 * SPDX-License-Identifier: Apache-2.0
 ******************************************************************************/

package org.deeplearning4j.examples.convolution.sentenceclassification;

import org.deeplearning4j.nn.conf.ComputationGraphConfiguration;
import org.deeplearning4j.nn.conf.ConvolutionMode;
import org.deeplearning4j.nn.conf.NeuralNetConfiguration;
import org.deeplearning4j.nn.conf.graph.MergeVertex;
import org.deeplearning4j.nn.conf.inputs.InputType;
import org.deeplearning4j.nn.conf.layers.ConvolutionLayer;
import org.deeplearning4j.nn.conf.layers.GlobalPoolingLayer;
import org.deeplearning4j.nn.conf.layers.OutputLayer;
import org.deeplearning4j.nn.conf.layers.PoolingType;
import org.deeplearning4j.nn.graph.ComputationGraph;
import org.deeplearning4j.nn.weights.WeightInit;
import org.deeplearning4j.optimize.listeners.CheckpointListener;
import org.jetbrains.annotations.NotNull;
import org.nd4j.linalg.activations.Activation;
import org.nd4j.linalg.dataset.api.iterator.DataSetIterator;
import org.nd4j.linalg.learning.config.Adam;
import org.nd4j.linalg.lossfunctions.LossFunctions;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;

/**
 * Convolutional Neural Networks for Sentence Classification - https://arxiv.org/abs/1408.5882
 *
 * Specifically, this is the 'static' model from there
 *
 * @author Alex Black
 */
public class CnnSentenceClassificationTrain extends CnnSentenceClassificationRunner {

    private static Logger log = LoggerFactory.getLogger(CnnSentenceClassificationTrain.class);
    private static final String MODEL_NAME = "CnnSentenceClassificationModel.pb";
    private static final boolean TRAINING = true;

    private String outputModelFolder;

    public CnnSentenceClassificationTrain(String outputModelFolder) {
        this.outputModelFolder = outputModelFolder;
    }

    public void run(
            int batchSize,
            int vectorSize,              //Size of the word vectors. 300 in the Google News model
            int nEpochs,                 //Number of epochs (full passes of training data) to train on
            int truncateReviewsToLength, //Truncate reviews with length (# words) greater than this
            int cnnLayerFeatureMaps,     //Number of feature maps / channels / depth for each CNN layer
            PoolingType globalPoolingType,
            int randomSeedForRepeatability,                   //For shuffling repeatability
            double learningRate
    ) throws Exception {
        ComputationGraphConfiguration modelConfiguration = configureModelLayers(
                batchSize,
                vectorSize,
                truncateReviewsToLength,
                cnnLayerFeatureMaps,
                globalPoolingType,
                randomSeedForRepeatability,
                learningRate
        );

        ComputationGraph model = initialiseModel(modelConfiguration);

        displayModelInfo(model);

        DataSetIterator trainingSet = getDataSetIterator(TRAINING, batchSize, truncateReviewsToLength, randomSeedForRepeatability);

        performModelTraining(nEpochs, model, trainingSet);

        saveTrainedModel(model);
    }

    private ComputationGraphConfiguration configureModelLayers(
            int batchSize,
            int vectorSize,
            int truncateReviewsToLength,
            int cnnLayerFeatureMaps,
            PoolingType globalPoolingType,
            int randomSeedForRepeatability,
            double learningRate) {
        //Set up the network configuration. Note that we have multiple convolution layers, each wih filter
        //widths of 3, 4 and 5 as per Kim (2014) paper.
        log.info(String.format("batchSize = %d", batchSize));
        log.info(String.format("vectorSize = %d", vectorSize));
        log.info(String.format("truncateReviewsToLength = %d", truncateReviewsToLength));
        log.info(String.format("cnnLayerFeatureMaps = %d", cnnLayerFeatureMaps));
        log.info(String.format("randomSeedForRepeatability = %d", randomSeedForRepeatability));
        log.info(String.format("globalPoolingType = %s", PoolingType.valueOf(globalPoolingType.name())));
        log.info(String.format("learningRate = %f", learningRate));

        log.info("Build model....");
        return new NeuralNetConfiguration.Builder()
            .weightInit(WeightInit.RELU)
            .activation(Activation.LEAKYRELU)
            .updater(new Adam(0.01))
            .convolutionMode(ConvolutionMode.Same)      //This is important so we can 'stack' the results later
            .l2(learningRate)
            .graphBuilder()
            .addInputs("input")
            .addLayer("cnn3", new ConvolutionLayer.Builder()
                .kernelSize(3, vectorSize)
                .stride(1, vectorSize)
                .nOut(cnnLayerFeatureMaps)
                .build(), "input")
            .addLayer("cnn4", new ConvolutionLayer.Builder()
                .kernelSize(4, vectorSize)
                .stride(1, vectorSize)
                .nOut(cnnLayerFeatureMaps)
                .build(), "input")
            .addLayer("cnn5", new ConvolutionLayer.Builder()
                .kernelSize(5, vectorSize)
                .stride(1, vectorSize)
                .nOut(cnnLayerFeatureMaps)
                .build(), "input")
            //MergeVertex performs depth concatenation on activations: 3x[minibatch,100,length,300] to 1x[minibatch,300,length,300]
            .addVertex("merge", new MergeVertex(), "cnn3", "cnn4", "cnn5")
            //Global pooling: pool over x/y locations (dimensions 2 and 3): Activations [minibatch,300,length,300] to [minibatch, 300]
            .addLayer("globalPool", new GlobalPoolingLayer.Builder()
                .poolingType(globalPoolingType)
                .dropOut(0.5)
                .build(), "merge")
            .addLayer("out", new OutputLayer.Builder()
                .lossFunction(LossFunctions.LossFunction.MCXENT)
                .activation(Activation.SOFTMAX)
                .nOut(2)    //2 classes: positive or negative
                .build(), "globalPool")
            .setOutputs("out")
            //Input has shape [minibatch, channels=1, length=1 to 256, 300]
            .setInputTypes(InputType.convolutional(truncateReviewsToLength, vectorSize, 1))
            .build();
    }

    @NotNull
    private ComputationGraph initialiseModel(ComputationGraphConfiguration config) {
        ComputationGraph model = new ComputationGraph(config);
        model.init();
        return model;
    }

    private void saveTrainedModel(ComputationGraph model) throws IOException {
        log.info("Saving model");
        File modelFilePath = Paths.get(outputModelFolder, MODEL_NAME).toFile();
        model.save(modelFilePath);
        log.info(String.format("Saved model: %s%n", modelFilePath.toPath().toString()));
    }

    private void performModelTraining(int nEpochs, ComputationGraph model, DataSetIterator trainIter) {
        log.info("Starting training");
        model.setListeners(
                new ValohaiMetadataCreator(10),
                new CheckpointListener.Builder(outputModelFolder)
                        .deleteExisting(true)
                        .saveEveryEpoch()
                        .build()
        );
        model.fit(trainIter, nEpochs);
        log.info("Finished training");
    }
}
