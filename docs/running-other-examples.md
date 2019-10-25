# Running other examples on the local machine

We will only be covering the `CnnSentenceClassificationExample` with the above steps, but additional examples are available with this repo:
 
- [nlp](https://github.com/eclipse/deeplearning4j-examples/tree/master/dl4j-examples/src/main/java/org/deeplearning4j/examples/nlp) 
- [convolution: sentence classifier](https://github.com/eclipse/deeplearning4j-examples/tree/master/dl4j-examples/src/main/java/org/deeplearning4j/examples/convolution/sentenceclassification) 
- [recurrent: character](https://github.com/eclipse/deeplearning4j-examples/tree/master/dl4j-examples/src/main/java/org/deeplearning4j/examples/recurrent/character) 
- [recurrent: process news](https://github.com/eclipse/deeplearning4j-examples/tree/master/dl4j-examples/src/main/java/org/deeplearning4j/examples/recurrent/processnews) 
- [recurrent: word2vec and sentiment analysis](https://github.com/eclipse/deeplearning4j-examples/tree/master/dl4j-examples/src/main/java/org/deeplearning4j/examples/recurrent/word2vecsentiment)

You can get the other examples to work by:

- cloning this repo
- running the `./download-src-main-resources.sh` shell script in the root of the project folder
- running the `./download-model-and-review-database.sh` shell script in the root of the project folder
- opening the project in your favourite IDE
- make sure you *Marked the directory* `dl4j-nlp-cuda-example/src/main/java` as *Sources Root* 
- for e.g. in IntelliJ we can run an class by selecting it's name via mouse of keyboard

**You can find even more NLP examples at https://github.com/eclipse/deeplearning4j/deeplearning4j/deeplearning4j-nlp-parent.**

And you can find more DL4J examples (non-NLP related) at https://github.com/deeplearning4j/dl4j-examples.

---

Return to main [README.md](../README.md)