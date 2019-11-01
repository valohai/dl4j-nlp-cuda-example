# DL4J NLP examples

[![NLP using DL4J](https://img.shields.io/docker/pulls/neomatrix369/dl4j-nlp-cuda.svg)](https://hub.docker.com/r/neomatrix369/dl4j-nlp-cuda) [![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

---

Open built-in Terminal from the IntelliJ IDEA. 
If you prefer, use the terminal app on your computer.
In the terminal window, `cd` to the project root directory `dl4j-nlp-cuda-example` if not already in.
(_you can use IDE's run-configuration green run button, if you like._)

### Quick startup

- open an account on [https://valohai.com](), see [https://app.valohai.com/accounts/signup/]()
- [install Valohai CLI](https://docs.valohai.com/tutorials/quick-start-cli.html?highlight=cli) on your local machine
- clone _this repo (https://github.com/.../dl4j-nlp-cuda-example/)_
```bash
    $ git clone [url to this repo]
    $ cd dl4j-nlp-cuda-example
```
- create a Valohai project using the [Valohai CLI](https://docs.valohai.com/tutorials/quick-start-cli.html?highlight=cli) tool, and give it a name
```bash
    $ vh project create
```
- link your Valohai project with the _url to this github repo_ on the Repository tab of the Settings page (https://app.valohai.com/p/[your-user-id]/dl4j-nlp-cuda-example/settings/repository/)
```bash
    $ vh project open
    
    ### Go to the Settings page > Repository tab and update the git repo address with this git repo: https://github.com/.../dl4j-nlp-cuda-example/
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
- Nvidia, CUDA 10.1 and cuDNN (7.0) drivers version (Linux and Windows machines only, support for MacOS is unavailable) (see [Resources](#resoures) at the bottom of this post for download and installation [details on GPUs, CUDA, cuDNN, etc...](./docs/gpu-related-resources.md))

#### Valohai CLI installation and Valohai project setup

See [Valohai CLI installation and Valohai project setup](./docs/valohai-setup.md)

#### Build the app using the Valohai platform

See [Build the app using the Valohai platform](./docs/valohai-build-app.md)

#### Gathering Nvidia GPU, Nvidia drivers, CUDA details

```bash
$ vh exec run know-your-gpus
```

Will run a bunch of commands to gather Nvidia GPU, Nvidia drivers, CUDA details on a machine, this step is also used by other steps. The captured result is stored in a log file and archive after each run. See [GPU related resources]](./docs/gpu-related-resources.md)

#### Build the app on the local machine

##### CPU version

```bash
$ BACKEND=cpu ./buildUberJar.sh
```

##### GPU version

**Note:** please ensure you have access to an Nvidia GPU and the necessary drivers i.e. CUDA, cuDNN etc... are installed, see [GPU related resources]](./docs/gpu-related-resources.md).

```bash
$ BACKEND=gpu ./buildUberJar.sh
```

#### Run the app on the local machine

See [Run the app on the local machine](./docs/running-local-machine.md)

#### Building the docker container to run CUDA-enabled Java apps

See [Building the docker container to run CUDA-enabled Java apps](./docs/docker-cuda-app.md)

#### Run app in docker container

```bash
./runDockerContainer.sh
```

At the prompt in the container, do the same as mentioned in section [Run app on your local machine](#run-app-on-the-local-machine).

### Running other examples on the local machine

See [Running other examples on the local machine](./docs/running-other-examples.md)

## Credits

This example has been inspired by the DL4J NLP examples: [nlp](https://github.com/eclipse/deeplearning4j-examples/tree/master/dl4j-examples/src/main/java/org/deeplearning4j/examples/nlp) | [convolution: sentence classifier](https://github.com/eclipse/deeplearning4j-examples/tree/master/dl4j-examples/src/main/java/org/deeplearning4j/examples/convolution/sentenceclassification) | [recurrent: character](https://github.com/eclipse/deeplearning4j-examples/tree/master/dl4j-examples/src/main/java/org/deeplearning4j/examples/recurrent/character) | [recurrent: process news](https://github.com/eclipse/deeplearning4j-examples/tree/master/dl4j-examples/src/main/java/org/deeplearning4j/examples/recurrent/processnews) | [recurrent: word2vec and sentiment analysis](https://github.com/eclipse/deeplearning4j-examples/tree/master/dl4j-examples/src/main/java/org/deeplearning4j/examples/recurrent/word2vecsentiment ) examples from DL4J. Credits to the original authors of this example on https://github.com/deeplearning4j/dl4j-examples.

## License

Original authors of this DL4J example project remain the license holders of the work, although the original work has been modified to a good extent, and the Apache 2.0 License is cited for all those file/files in the matter (see [License.txt](License.txt) in the root of the project). Exception to the above: four bash scripts have been authored by Mani Sarkar and have been cited under the Apache 2.0 license.

### Resources

- [dl4j-nlp-cuda-example](https://github.com/valohai/dl4j-nlp-cuda-example) project on GitHub
- [CUDA enabled docker container](https://hub.docker.com/r/neomatrix369/dl4j-nlp-cuda) on [Docker Hub](https://hub.docker.com) (use the latest tag: [v0.5](https://hub.docker.com/layers/neomatrix369/dl4j-nlp-cuda/v0.5/images/sha256-fcfcc2dcdf00839d918a0c475c39733d777181abb1a3c34d8dea68339369b137))
- [GPU, Nvidia, CUDA and cuDNN](./docs/gpu-related-resources.md)
- [Awesome AI/ML/DL resources](https://github.com/neomatrix369/awesome-ai-ml-dl/)
- [Java AI/ML/DL resources](https://github.com/neomatrix369/awesome-ai-ml-dl/blob/master/README-details.md#java)
- [Deep Learning and DL4J Resources](https://github.com/neomatrix369/awesome-ai-ml-dl/blob/master/README-details.md#deep-learning)
    - **Awesome AI/ML/DL:** [NLP resources](https://github.com/neomatrix369/awesome-ai-ml-dl/tree/master/natural-language-processing#natural-language-processing-nlp)
    - **DL4J NLP resources**
        - [Language processing](https://deeplearning4j.org/docs/latest/deeplearning4j-nlp-overview)
            - [ND4J backends for GPUs and CPUs](https://deeplearning4j.org/docs/latest/deeplearning4j-config-gpu-cpu)
            - [How the Vocab Cache Works](https://deeplearning4j.org/docs/latest/deeplearning4j-nlp-vocabulary-cache)
            - [Word2Vec, Doc2vec & GloVe: Neural Word Embeddings for Natural Language Processing](https://deeplearning4j.org/docs/latest/deeplearning4j-nlp-word2vec)
            - [Doc2Vec, or Paragraph Vectors, in Deeplearning4j](https://deeplearning4j.org/docs/latest/deeplearning4j-nlp-doc2vec)
            - [Sentence iterator](https://deeplearning4j.org/docs/latest/deeplearning4j-nlp-sentence-iterator)
            - [What is Tokenization?](https://deeplearning4j.org/docs/latest/deeplearning4j-nlp-tokenization)
        - Examples
            - https://github.com/eclipse/deeplearning4j-examples/tree/master/dl4j-examples
            - https://github.com/eclipse/deeplearning4j/deeplearning4j/deeplearning4j-nlp-parent
- **Valohai resources**
    - [valohai](https://www.valohai.com/) | [docs](https://docs.valohai.com/) | [blogs](https://blogs.valohai.com/) | [GitHub](https://github.com/valohai) | [Videos](https://www.youtube.com/channel/UCiR8Fpv6jRNphaZ99PnIuFg/videos) | [Showcase](https://valohai.com/showcase/) | [About valohai](https://github.com/neomatrix369/awesome-ai-ml-dl/blob/master/data/about-Valohai.md#valohai) | [Slack](http://community-slack.valohai.com/) | [@valohaiai](https://twitter.com/@valohaiai)
    - [Search for any topic in the Documentation](https://docs.valohai.com/search.html?q=%3Cany+topic%3E)
    - Blog posts on how to use the Valohai CLI tool: [[1]](https://blog.valohai.com/from-zero-to-hero-with-valohai-cli) | [[2]](https://blog.valohai.com/from-zero-to-hero-with-valohai-part-2)
    - [Custom Docker Images](https://docs.valohai.com/guides/build-docker-image.html)
- Other resources
  - [Awesome Graal](https://github.com/neomatrix369/awesome-graal) | [graalvm.org](https://www.graalvm.org/)
- Other related posts
    - [How to do Deep Learning for Java on the Valohai Platform?](https://blog.valohai.com/how-to-do-deep-learning-for-java-on-the-valohai-platform)
    - Blog posts on how to use the Valohai CLI tool: [[1]](https://blog.valohai.com/from-zero-to-hero-with-valohai-cli) | [[2]](https://blog.valohai.com/from-zero-to-hero-with-valohai-part-2)

---

Return to [Awesome AI/ML/DL](https://github.com/neomatrix369/awesome-ai-ml-dl#awesome-ai-ml-dl-)