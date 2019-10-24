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

import org.apache.commons.io.FileUtils;
import org.apache.commons.io.FilenameUtils;
import org.deeplearning4j.iterator.CnnSentenceDataSetIterator;
import org.deeplearning4j.models.embeddings.loader.WordVectorSerializer;
import org.deeplearning4j.models.embeddings.wordvectors.WordVectors;
import org.deeplearning4j.nn.api.Layer;
import org.deeplearning4j.nn.graph.ComputationGraph;
import org.nd4j.linalg.api.ndarray.INDArray;
import org.nd4j.linalg.dataset.api.iterator.DataSetIterator;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.File;
import java.util.*;

/**
 * Convolutional Neural Networks for Sentence Classification - https://arxiv.org/abs/1408.5882
 *
 * Specifically, this is the 'static' model from there
 *
 * @author Alex Black
 */
public class CnnSentenceClassificationEvaluate extends CnnSentenceClassificationRunner {

    private static Logger log = LoggerFactory.getLogger(CnnSentenceClassificationEvaluate.class);

    private String modelFilePath;

    public CnnSentenceClassificationEvaluate(String modelFilePath) {
        this.modelFilePath = modelFilePath;
    }

    public void run(
            int batchSize,
            int truncateReviewsToLength,  //Truncate reviews with length (# words) greater than this
            Random rng                    //For shuffling repeatability
    ) throws Exception {
        log.info("Loading pretrained model");
        ComputationGraph net = ComputationGraph.load(new File(modelFilePath), true);

        log.info("Number of parameters by layer:");
        for(Layer l : net.getLayers() ){
            log.info(String.format("\t%s\t%d", l.conf().getLayer().getLayerName(), l.numParams()));
        }

        //Load word vectors and get the DataSetIterators for testing
        log.info("Loading word vectors and creating DataSetIterators");
        WordVectors wordVectors = WordVectorSerializer.loadStaticModel(new File(WORD_VECTORS_PATH));
        DataSetIterator testIter = getDataSetIterator(false, wordVectors, batchSize, truncateReviewsToLength, rng);

        //After training: load a single sentence and generate a prediction
        String pathFirstNegativeFile = FilenameUtils.concat(DATA_PATH, "aclImdb/test/neg/0_2.txt");
        String contentsFirstNegative = FileUtils.readFileToString(new File(pathFirstNegativeFile));
        INDArray featuresFirstNegative = ((CnnSentenceDataSetIterator)testIter).loadSingleSentence(contentsFirstNegative);

        INDArray predictionsFirstNegative = net.outputSingle(featuresFirstNegative);
        List<String> labels = testIter.getLabels();

        log.info("\n\nPredictions for first negative review:");
        for( int i=0; i<labels.size(); i++ ){
            log.info(String.format("P(%s) = %s", labels.get(i), predictionsFirstNegative.getDouble(i)));
        }

        log.info("\n\nEvaluating model:");
        net.setListeners(new ValohaiMetadataCreator(10));
        net.evaluate(testIter);
        log.info("\n\nFinished evaluating model.");
    }
}
