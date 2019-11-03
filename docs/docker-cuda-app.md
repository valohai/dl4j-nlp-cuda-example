# Building the docker container to run CUDA-enabled Java apps

**For the sake of this project you won't need to do any of the below steps in this section, as we already have a [pre-baked CUDA-enabled docker image](https://hub.docker.com/r/neomatrix369/dl4j-nlp-cuda/tags) for your use.** The docker image contains everything mentioned in the pre-requites in the [Advanced installation and setup](#advanced-installation-and-setup) section.

But if you like to explore further please dive into it.

## Build docker image

Builds a CUDA-enabled docker image based on [Nvidia's CUDA docker image: nvidia/cuda:10.1-cudnn7-runtime-ubuntu18.04](https://hub.docker.com/r/nvidia/cuda/tags) and a [GraalVM 19.2.1](https://hub.docker.com/r/findepi/graalvm/tags) image from [findepi](https://hub.docker.com/r/findepi/) 

```bash
$ cd dl4j-nlp-cuda-example/docker
$ ./docker-runner --buildImage   ### DOCKER_USER_NAME is set to your Docker Hub username 

or

$ ./docker-runner --dockerUserName [your Docker Hub username] \
                  --buildImage
```

## Push the docker image to docker hub

Push the created image to the Docker hub, you need an account on [Docker Hub](https://hub.docker.com/).

```bash
$ cd dl4j-nlp-cuda-example/docker
$ ./docker-runner --pushImageToHub   ### DOCKER_USER_NAME is set to your Docker Hub username 

or

$ ./docker-runner --dockerUserName [your Docker Hub username] \
                  --pushImageToHub
```

You will be prompted for a password to your account when you try to push this to the hub, unless you are already logged in.

## Run the docker container

In this specific case, running the container would make more sense if you have a machine with a GPU and Nvidia drivers installed and working.
See [Resources](#resources) to find out how to go about with that.

```bash
$ cd dl4j-nlp-cuda-example/docker
$ ./docker-runner --runContainer   ### neomatrix369 or DOCKER_USER_NAME is set to your Docker Hub username 

or

$ ./docker-runner --dockerUserName [neomatrix369 or your Docker Hub username] \
                  --runContainer
```

Although if you look at the [valohai.yaml]() file, it's already done on the Valohai platform. 

---

Return to main [README.md](../README.md)
