# DL4J NLP examples

[![NLP using DL4J](https://img.shields.io/docker/pulls/neomatrix369/dl4j-nlp-cuda.svg)](https://hub.docker.com/r/neomatrix369/dl4j-nlp-cuda) [![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

---

Open built-in Terminal from the IntelliJ IDEA. 
If you prefer, use the terminal app on your computer.
In the terminal window, `cd` to the project root directory `dl4j-nlp-cuda-example` if not already in.
(_you can use IDE's run-configuration green run button, if you like._)

### Install and setup

To be able to run the apps and tasks we will cover in this project we would need to have the below installed and configured on our local machine (how to do each one of these are outside the scope of the project, although links to resources are provided):

- Docker CE 19.03.2 or higher
- Python 3.7 or higher
- GraalVM CE 19.2.1 or higher (download from [https://github.com/oracle/graal/releases]())
- Maven 3.6.0 or higher
- Nvidia and CUDA drivers version (Linux and Windows machines only, support for MacOS is unavailable) (see [Resources](#resoures) at the bottom of this post for download and installation details)
- [Valohai CLI](https://docs.valohai.com/tutorials/quick-start-cli.html?highlight=cli) - it’s easy to install and get started with the CLI tool, see [Command-line Usage](https://docs.valohai.com/valohai-cli/index.html?highlight=cli).
- Ensure you have opened an account on [https://valohai.com](), see [https://app.valohai.com/accounts/signup/]() 

#### Valohai configuration and setup

After install the [Valohai CLI](https://docs.valohai.com/valohai-cli/index.html?highlight=cli), we will have to do the below:

- clone this repo

```bash  
  $ git clone https://github.com:valohai/dl4j-nlp-cuda-example.git
  $ cd dl4j-nlp-cuda-example
```

- create a new Valohai project (requires an account on https://valohai.com)
```bash
$ vh create
```  
```bash
  (Resolved create to project create.)
  Project name: dl4j-nlp-cuda-example
  😄  Success! Project dl4j-nlp-cuda-example created.
```
You can go back to your account on [https://valohai.com]() to find this project present

- viewing Valohai cloud environments (optional)
```
$ vh env 
```

- shortlisting GPU based environments (optional)

```bash 
$ vh env -price --queue --gpu
```
List all environments that support GPUs with their price tag and their queue status. 
- getting familiar with the CLI tool
```bash
$ vh lint
$ vh exec list
$ vh exec run --help
```

### Build app

#### CPU version

```
$ ./buildUberJar.sh
```
#### GPU version

Please ensure your environment has access to an Nvidia GPU and the necessary drivers i.e. CUDA, etc...

```
$ BACKEND=gpu ./buildUberJar.sh
```

### Build app for the docker image


#### Build docker image

```
./buildUberJar.sh
./buildDockerImage.sh
```

#### Push to docker hub

```
./push-docker-image-to-hub.sh
```

### Run app local

#### CPU version

```
$ BACKEND=cpu ./runUberJar.sh
```

#### GPU version

Please ensure your environment has access to an Nvidia GPU and the necessary drivers i.e. CUDA, etc...

```
$ BACKEND=gpu ./runUberJar.sh
```

Model file created and seeked for in the respective cases, is called `dl4j-nlp-cuda.pb`.

### Run app in docker container

```
./runDockerContainer.sh
```

At the prompt in the container, do the same as mentioned in section [Run app local](#run-app-local).

## Credits

This example has been inspired by the DL4J NLP examples: [nlp](https://github.com/eclipse/deeplearning4j-examples/tree/master/dl4j-examples/src/main/java/org/deeplearning4j/examples/nlp) | [convolution: sentence classifier](https://github.com/eclipse/deeplearning4j-examples/tree/master/dl4j-examples/src/main/java/org/deeplearning4j/examples/convolution/sentenceclassification) | [recurrent: character](https://github.com/eclipse/deeplearning4j-examples/tree/master/dl4j-examples/src/main/java/org/deeplearning4j/examples/recurrent/character) | [recurrent: process news](https://github.com/eclipse/deeplearning4j-examples/tree/master/dl4j-examples/src/main/java/org/deeplearning4j/examples/recurrent/processnews) | [recurrent: word2vec and sentiment analysis](https://github.com/eclipse/deeplearning4j-examples/tree/master/dl4j-examples/src/main/java/org/deeplearning4j/examples/recurrent/word2vecsentiment )examples from DL4J. Credits to the original authors of this example on https://github.com/deeplearning4j/dl4j-examples, 

## License

Original authors of this DL4J example project remain the license holders of the work, although the original work has been modified to a good extent, and the Apache 2.0 License is cited for all those file/files in the matter (see [License.txt](License.txt) in the root of the project). Exception to the above: four bash scripts have been authored by Mani Sarkar and have been cited under the Apache 2.0 license.

### Resources

- [Awesome AI/ML/DL resources](https://github.com/neomatrix369/awesome-ai-ml-dl/)
- [Java AI/ML/DL resources](https://github.com/neomatrix369/awesome-ai-ml-dl/blob/master/README-details.md#java)
- [Deep Learning and DL4J Resources](https://github.com/neomatrix369/awesome-ai-ml-dl/blob/master/README-details.md#deep-learning)
- Valohai resources
  - [valohai](https://valohai.com/) | [docs](https://docs.valohai.com/) | [blogs](https://blog.valohai.com/) | [GitHub](https://github.com/valohai) | [Videos](https://www.youtube.com/channel/UCiR8Fpv6jRNphaZ99PnIuFg) | [Showcase](https://valohai.com/showcase/) | [About Valohai](https://github.com/neomatrix369/awesome-ai-ml-dl/blob/master/data/about-Valohai.md#valohai) | [Slack](https://community-slack.valohai.com/)
  - Blog posts on how to use the CLI tool: [1](https://blog.valohai.com/from-zero-to-hero-with-valohai-cli) | [2](https://blog.valohai.com/from-zero-to-hero-with-valohai-part-2)
- Other resources
  - [Awesome Graal](https://github.com/neomatrix369/awesome-graal) | [graalvm.org](https://www.graalvm.org/)

---

Return to [Awesome AI/ML/DL](https://github.com/neomatrix369/awesome-ai-ml-dl#awesome-ai-ml-dl-)