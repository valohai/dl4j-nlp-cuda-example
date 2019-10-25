# DL4J NLP examples

[![NLP using DL4J](https://img.shields.io/docker/pulls/neomatrix369/dl4j-nlp-cuda.svg)](https://hub.docker.com/r/neomatrix369/dl4j-nlp-cuda) [![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

---

Open built-in Terminal from the IntelliJ IDEA. 
If you prefer, use the terminal app on your computer.
In the terminal window, `cd` to the project root directory `dl4j-nlp-cuda-example` if not already in.
(_you can use IDE's run-configuration green run button, if you like._)

### Quick startup

- open an account on [https://valohai.com](), see [https://app.valohai.com/accounts/signup/]()
- [install Valohai CLI](https://docs.valohai.com/tutorials/quick-start-cli.html?highlight=cli) on your local machine or remote server
- clone the repo [https://github.com/neomatrix369/dl4j-nlp-cuda-example/]()
```bash
    $ git clone https://github.com/neomatrix369/dl4j-nlp-cuda-example/
    $ cd dl4j-nlp-cuda-example
```
- create a Valohai project using the [Valohai CLI](https://docs.valohai.com/tutorials/quick-start-cli.html?highlight=cli) tool, and give it a name
```bash
    $ vh project create
```
- link your Valohai project with the github repo [https://github.com/neomatrix369/dl4j-nlp-cuda-example/]() on the Repository tab of the Settings page (https://app.valohai.com/p/[your-user-id]/dl4j-nlp-cuda-example/settings/repository/)
```bash
    $ vh project open
    
    ### Go to the Settings page > Repository tab and update the git repo address with https://github.com/neomatrix369/dl4j-nlp-cuda-example/
```
- update Valohai project with the latest commits from the git repo
```bash
    $ vh project fetch
```

And you are ready to start using the power of performing Machine Learning tasks from the command-line.

### Advanced installation and setup

To be able to run the apps and tasks we will cover in this project on your local machine (in addition to using the Valohai platform) we would need to have the below installed and configured on your local machine (how to do each one of these are outside the scope of the project, although links to resources are provided):

**_Build and run app on local machine_**
- Git
- Python 2.7 or Python 3.4 or higher
- GraalVM CE 19.2.1 or higher (download from [https://github.com/oracle/graal/releases]())
- Maven 3.6.0 or higher

**_Build and run app inside a docker container_**
- Docker CE 19.03.2 or higher

**_Do the above and make use of GPUs - CUDA, cuDNN, etc._**
- Nvidia, CUDA 10.1 and cuDNN (7.0) drivers version (Linux and Windows machines only, support for MacOS is unavailable) (see [Resources](#resoures) at the bottom of this post for download and installation details)

#### Valohai CLI installation and Valohai project setup

- Ensure you have opened an account on [https://valohai.com](), see [https://app.valohai.com/accounts/signup/]() 

- [Install Valohai CLI](https://docs.valohai.com/tutorials/quick-start-cli.html?highlight=cli) - it’s easy to install and get started with the CLI tool, see [Command-line Usage](https://docs.valohai.com/valohai-cli/index.html?highlight=cli).

After install the [Valohai CLI](https://docs.valohai.com/valohai-cli/index.html?highlight=cli), we will have to do the below:

- clone this repo

```bash  
  $ git clone https://github.com:valohai/dl4j-nlp-cuda-example.git
  $ cd dl4j-nlp-cuda-example
```

- create a new Valohai project (requires an account on https://valohai.com)
```bash
$ vh project create
```  
```bash
  (Resolved create to project create.)
  Project name: dl4j-nlp-cuda-example
  😄  Success! Project dl4j-nlp-cuda-example created.
```

- Go back to your account on [https://valohai.com]() to find this project present:

```bash
$ vh project open
```

Once in your Valohai project, add this git repo (https://github.com/neomatrix369/dl4j-nlp-cuda-example) to the project, under the **Repository** tab in the Settings page (https://app.valohai.com/p/[your-user-id]/dl4j-nlp-cuda-example/settings/repository/).

- viewing Valohai cloud environments (optional)
```bash
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

#### Build the app using the Valohai platform

We mean using the [Valohai CLI](https://docs.valohai.com/tutorials/quick-start-cli.html?highlight=cli) to run executions on the [Valohai](https://valohai.org) platform.

##### CPU & GPU version

```bash
$ vh exec run build-cpu-gpu-uberjar [--adhoc]

### Run `vh exec run --help` to find out more about this command
```

Note: use `--adhoc` only if you have not setup your Valohai project with a git repo or have unsaved commits and want to experiment before being sure of the configuration.

Creates and uploads the artifacts into the Valohai storage which can be referred to later on.

#### Run the app using the Valohai platform

##### CPU version

**Training**

```bash
$ vh exec run train-cpu-linux --cpu-linux-uberjar=datum://016dffe8-0faa-ca1d-4ce4-994274576fe1 [--adhoc]

### Run `vh exec run --help` to find out more about this command
```

**Evaluation**

```bash
$ vh exec run evaluate-model-linux --uber-jar=datum://016dff00-43b7-b599-0e85-23a16749146e --model=datum://016dff2a-a0d4-3e63-d8da-6a61a96a7ba6 [--adhoc]
```

##### GPU version

**Training**

```bash
$ vh exec run train-gpu-linux --gpu-linux-uberjar=datum://016dffe8-0faa-ca1d-4ce4-994274576fe1 [--adhoc]

### Run `vh exec run --help` to find out more about this command
```

**Evaluation**

```bash
$ vh exec run evaluate-model-linux --uber-jar=datum://016dff00-2095-4df7-5d9e-02cb7cd009bb --model=datum://016dff2a-a0d4-3e63-d8da-6a61a96a7ba6 [--adhoc]
```

**Note:** the `datum://[sha]` links used in all the above examples will have to be replaced with the ones relevant iny our case, you can get them by quering the exections, outputs and other running tasks - using the [Valohai CLI](https://docs.valohai.com/tutorials/quick-start-cli.html?highlight=cli) tool.

#### Gathering Nvidia GPU, Nvidia drivers, CUDA details

```bash
$ vh exec run know-your-gpus
```

Will run a bunch of commands to gather Nvidia GPU, Nvidia drivers, CUDA details on a machine, this step is also used by other steps. The captured result is stored in a log file and archive after each run.

#### Build the app (local machine)

##### CPU version

```bash
$ BACKEND=cpu ./buildUberJar.sh
```

##### GPU version

**Note:** please ensure you have access to an Nvidia GPU and the necessary drivers i.e. CUDA, cuDNN etc... are installed.

```bash
$ BACKEND=gpu ./buildUberJar.sh
```

#### Building the docker container to run CUDA-enabled Java apps

**For the sake of this project you won't need to do any of the below steps in this section, as we already have a [pre-baked CUDA-enabled docker image](https://hub.docker.com/r/neomatrix369/dl4j-nlp-cuda/tags) for your use.** The docker image contains everything mentioned in the pre-requites in the [Advanced installation and setup](#advanced-installation-and-setup) section.

But if you like to explore further please dive into it.

##### Build docker image

Builds a CUDA-enabled docker image based on [Nvidia's CUDA docker image: nvidia/cuda:10.1-cudnn7-runtime-ubuntu18.04](https://hub.docker.com/r/nvidia/cuda/tags) and a [GraalVM 19.2.1](https://hub.docker.com/r/findepi/graalvm/tags) image from [findepi](https://hub.docker.com/r/findepi/) 

```bash
$ cd dl4j-nlp-cuda-example/docker
$ ./buildDockerImage.sh
```

##### Push the docker image to docker hub

Push the created image to the Docker hub, you need an account on [Docker Hub](https://hub.docker.com/).

```bash
$ cd dl4j-nlp-cuda-example/docker
$ ./push-docker-image-to-hub.sh
```

You will be prompted for a password to your account when you try to push this to the hub, unless you are already logged in.

##### Run the docker container

In this specific case, running the container would make more sense if you have a machine with a GPU and Nvidia drivers installed and working.
See [Resources](#resources) to find out how to go about with that.

```bash
$ cd dl4j-nlp-cuda-example/docker
$ ./runDockerContainer.sh
```

Although if you look at the [valohai.yaml]() file, it's already done on the Valohai platform. 

#### Run the app on your local machine

##### CPU version

*Training*

```bash
$ BACKEND=cpu ./runUberJar.sh --action train --output-model-dir .
```

Model file created is called `CnnSentenceClassificationModel-cpu.pb`.

*Evaluating*

```bash
$ BACKEND=cpu ./runUberJar.sh --action evaluate --input-model-file CnnSentenceClassificationModel-cpu.pb
```

##### GPU version

**Note:** please ensure you have access to an Nvidia GPU and the necessary drivers i.e. CUDA, cuDNN etc... are installed.

*Training*

```bash
$ BACKEND=gpu ./runUberJar.sh --action train --output-model-dir .
```

Model file created is called `CnnSentenceClassificationModel-gpu.pb`.

*Evaluating*

```bash
$ BACKEND=gpu ./runUberJar.sh --action evaluate --input-model-file CnnSentenceClassificationModel-gpu.pb
```


#### Run app in docker container

```bash
./runDockerContainer.sh
```

At the prompt in the container, do the same as mentioned in section [Run app on your local machine](#run-app-on-your-local-machine).

### Running other examples on the local machine

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

## Credits

This example has been inspired by the DL4J NLP examples: [nlp](https://github.com/eclipse/deeplearning4j-examples/tree/master/dl4j-examples/src/main/java/org/deeplearning4j/examples/nlp) | [convolution: sentence classifier](https://github.com/eclipse/deeplearning4j-examples/tree/master/dl4j-examples/src/main/java/org/deeplearning4j/examples/convolution/sentenceclassification) | [recurrent: character](https://github.com/eclipse/deeplearning4j-examples/tree/master/dl4j-examples/src/main/java/org/deeplearning4j/examples/recurrent/character) | [recurrent: process news](https://github.com/eclipse/deeplearning4j-examples/tree/master/dl4j-examples/src/main/java/org/deeplearning4j/examples/recurrent/processnews) | [recurrent: word2vec and sentiment analysis](https://github.com/eclipse/deeplearning4j-examples/tree/master/dl4j-examples/src/main/java/org/deeplearning4j/examples/recurrent/word2vecsentiment )examples from DL4J. Credits to the original authors of this example on https://github.com/deeplearning4j/dl4j-examples, 

## License

Original authors of this DL4J example project remain the license holders of the work, although the original work has been modified to a good extent, and the Apache 2.0 License is cited for all those file/files in the matter (see [License.txt](License.txt) in the root of the project). Exception to the above: four bash scripts have been authored by Mani Sarkar and have been cited under the Apache 2.0 license.

### Resources

- [Awesome AI/ML/DL resources](https://github.com/neomatrix369/awesome-ai-ml-dl/)
- [Java AI/ML/DL resources](https://github.com/neomatrix369/awesome-ai-ml-dl/blob/master/README-details.md#java)
- [Deep Learning and DL4J Resources](https://github.com/neomatrix369/awesome-ai-ml-dl/blob/master/README-details.md#deep-learning)
- Valohai resources
  - [valohai](https://valohai.com/) | [docs](https://docs.valohai.com/) | [blogs](https://blog.valohai.com/) | [GitHub](https://github.com/valohai) | [Videos](https://www.youtube.com/channel/UCiR8Fpv6jRNphaZ99PnIuFg) | [Showcase](https://valohai.com/showcase/) | [About Valohai](https://github.com/neomatrix369/awesome-ai-ml-dl/blob/master/data/about-Valohai.md#valohai) | [Slack](https://community-slack.valohai.com/) | [@valohaiai](https://twitter.com/@valohaiai)
  - Blog posts on how to use the CLI tool: [1](https://blog.valohai.com/from-zero-to-hero-with-valohai-cli) | [2](https://blog.valohai.com/from-zero-to-hero-with-valohai-part-2)
- Other resources
  - [Awesome Graal](https://github.com/neomatrix369/awesome-graal) | [graalvm.org](https://www.graalvm.org/)

---

Return to [Awesome AI/ML/DL](https://github.com/neomatrix369/awesome-ai-ml-dl#awesome-ai-ml-dl-)