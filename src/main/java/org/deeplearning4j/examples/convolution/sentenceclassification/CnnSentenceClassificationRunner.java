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

import com.beust.jcommander.JCommander;
import com.beust.jcommander.Parameter;
import org.apache.commons.io.FilenameUtils;
import org.deeplearning4j.examples.recurrent.word2vecsentiment.Word2VecSentimentRNN;
import org.deeplearning4j.iterator.CnnSentenceDataSetIterator;
import org.deeplearning4j.iterator.LabeledSentenceProvider;
import org.deeplearning4j.iterator.provider.FileLabeledSentenceProvider;
import org.deeplearning4j.models.embeddings.wordvectors.WordVectors;
import org.deeplearning4j.nn.conf.layers.PoolingType;
import org.nd4j.linalg.dataset.api.iterator.DataSetIterator;
import org.nd4j.linalg.factory.Nd4j;

import java.io.File;
import java.util.*;

/**
 * Convolutional Neural Networks for Sentence Classification - https://arxiv.org/abs/1408.5882
 *
 * Specifically, this is the 'static' model from there
 *
 * @author Alex Black
 */
public class CnnSentenceClassificationRunner {

    /** Location to save and extract the training/testing data */
    static final String DATA_PATH = String.format("%s/data/dl4j_w2vSentiment/", System.getProperty("user.dir"));
    /** Location (local file system) for the Google News vectors. Set this manually. */
    static final String WORD_VECTORS_PATH = String.format("%s/data/GoogleNews-vectors-negative300.bin.gz", System.getProperty("user.dir"));


    @Parameter(names={"--action", "-a"})
    String action;

    @Parameter(names={"--output-model-dir", "-o"})
    String outputModelDir;

    @Parameter(names={"--input-model-file", "-i"})
    String inputModelFilePath;

    public static void main(String[] args) throws Exception {
        CnnSentenceClassificationRunner cnnSentenceClassificationRunner = new CnnSentenceClassificationRunner();

        JCommander.newBuilder()
                .addObject(cnnSentenceClassificationRunner)
                .build()
                .parse(args);

        cnnSentenceClassificationRunner.execute();
    }

    private void execute() throws Exception {
        //Download and extract data
        Word2VecSentimentRNN.downloadData();

        Nd4j.getMemoryManager().setAutoGcWindow(5000);

        Random randomSeedForRepeatability = new Random(12345);
        if (action.equalsIgnoreCase("train")) {
            CnnSentenceClassificationTrain training = new CnnSentenceClassificationTrain(outputModelDir);
            training.run(32,
                    300,
                    1,
                    256,
                    100,
                    PoolingType.MAX,
                    randomSeedForRepeatability,
                    0.0001);
        } else if (action.equalsIgnoreCase("evaluate")) {
            CnnSentenceClassificationEvaluate evaluate = new CnnSentenceClassificationEvaluate(inputModelFilePath);
            evaluate.run(
                    32,
                    256,    //Truncate reviews with length (# words) greater than this
                    randomSeedForRepeatability   //For shuffling repeatability
            );
        }
    }

    DataSetIterator getDataSetIterator(boolean isTraining, WordVectors wordVectors, int minibatchSize,
                                                      int maxSentenceLength, Random rng ){
        String path = FilenameUtils.concat(DATA_PATH, (isTraining ? "aclImdb/train/" : "aclImdb/test/"));
        String positiveBaseDir = FilenameUtils.concat(path, "pos");
        String negativeBaseDir = FilenameUtils.concat(path, "neg");

        File filePositive = new File(positiveBaseDir);
        File fileNegative = new File(negativeBaseDir);

        Map<String,List<File>> reviewFilesMap = new HashMap<>();
        reviewFilesMap.put("Positive", Arrays.asList(filePositive.listFiles()));
        reviewFilesMap.put("Negative", Arrays.asList(fileNegative.listFiles()));

        LabeledSentenceProvider sentenceProvider = new FileLabeledSentenceProvider(reviewFilesMap, rng);

        return new CnnSentenceDataSetIterator.Builder()
                .sentenceProvider(sentenceProvider)
                .wordVectors(wordVectors)
                .minibatchSize(minibatchSize)
                .maxSentenceLength(maxSentenceLength)
                .useNormalizedWordVectors(false)
                .build();
    }
}
