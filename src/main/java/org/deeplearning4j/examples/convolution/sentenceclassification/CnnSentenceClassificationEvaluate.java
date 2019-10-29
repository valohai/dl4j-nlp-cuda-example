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
import org.deeplearning4j.nn.graph.ComputationGraph;
import org.deeplearning4j.optimize.api.InvocationType;
import org.deeplearning4j.optimize.listeners.EvaluativeListener;
import org.nd4j.evaluation.classification.Evaluation;
import org.nd4j.linalg.api.ndarray.INDArray;
import org.nd4j.linalg.dataset.api.iterator.DataSetIterator;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.File;
import java.io.IOException;
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

    private static final boolean TESTING = false;

    private static final String[] NEGATIVE_REVIEWS_ACL_IMDB = new String[] {
            "0_2.txt", "1_3.txt", "2_3.txt", "3_4.txt", "4_4.txt",
            "100_4.txt", "101_3.txt", "102_4.txt", "103_3.txt", "104_1.txt"
    };

    private String modelFilePath;

    public CnnSentenceClassificationEvaluate(String modelFilePath) {
        this.modelFilePath = modelFilePath;
    }

    public void run(
            int batchSize,
            int truncateReviewsToLength,   //Truncate reviews with length (# words) greater than this
            int randomSeedForRepeatability //For shuffling repeatability
    ) throws Exception {
        log.info("Loading pre-trained model and evaluating it...");

        log.info(String.format("batchSize = %d", batchSize));
        log.info(String.format("truncateReviewsToLength = %d", truncateReviewsToLength));
        log.info(String.format("randomSeedForRepeatability = %d", randomSeedForRepeatability));

        ComputationGraph model = ComputationGraph.load(new File(modelFilePath), true);

        displayModelInfo(model);
        DataSetIterator testIter = getDataSetIterator(TESTING, batchSize, truncateReviewsToLength, randomSeedForRepeatability);

        performModelEvaluation(model, testIter);
        validateReviewsUsingTheModel(model, testIter);

        log.info("\n\nFinished evaluating model.");
    }

    private void validateReviewsUsingTheModel(ComputationGraph model, DataSetIterator testSet) throws IOException {
        //After training: load a multiple sentences (n number of sentences) and generate predictions
        log.info(String.format("\n\nEvaluating %d sentences (negative) by passing each of them to the model: ", NEGATIVE_REVIEWS_ACL_IMDB.length));
        for (int sentenceIndex = 0; sentenceIndex < NEGATIVE_REVIEWS_ACL_IMDB.length; sentenceIndex++) {
            String pathNegativeReviewFile = FilenameUtils.concat(DATA_PATH,
                    String.format("aclImdb/test/neg/%s", NEGATIVE_REVIEWS_ACL_IMDB[sentenceIndex])
            );
            String contentsNegativeReview = FileUtils.readFileToString(new File(pathNegativeReviewFile));
            INDArray featuresNegativeReview = ((CnnSentenceDataSetIterator)testSet).loadSingleSentence(contentsNegativeReview);

            INDArray predictionsNegative = model.outputSingle(featuresNegativeReview);
            List<String> labels = testSet.getLabels();

            log.info(String.format("\n\nPredictions for a negative review (sentence %d):", sentenceIndex + 1));
            System.out.println(contentsNegativeReview);
            System.out.println();
            for( int index=0; index<labels.size(); index++ ){
                log.info(String.format("Probability that the above review is %s = %f (%f percent confidence)",
                            labels.get(index),
                            predictionsNegative.getDouble(index),
                            predictionsNegative.getDouble(index) * 100
                        )
                );
            }
        }
    }

    private void performModelEvaluation(ComputationGraph model, DataSetIterator testIter) {
        log.info(String.format("\n\nEvaluating the model (please be patient this may take a moment): %s", modelFilePath));
        model.setListeners(
                new ValohaiMetadataCreator(10),
                new EvaluativeListener(testIter, 1, InvocationType.EPOCH_END)
        );
        Evaluation modelEvaluation = model.evaluate(testIter);

        log.info("\n\nPrinting model evaluation stats:");
        log.info(modelEvaluation.stats());
    }
}
