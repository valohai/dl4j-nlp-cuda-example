FROM nvidia/cuda:10.1-cudnn7-runtime-ubuntu18.04

COPY --from=findepi/graalvm:19.2.1-native /graalvm/ /graalvm/
ENV JAVA_HOME=/graalvm/
ENV PATH=${JAVA_HOME}/bin:${PATH}

RUN java -version

RUN apt-get update && \
    apt-get install -qy curl pciutils lshw

ARG WORKDIR
ENV WORKDIR=${WORKDIR}

WORKDIR ${WORKDIR}

COPY installMaven.sh installMaven.sh

ARG MAVEN_TARGET_DIR
ENV MAVEN_TARGET_DIR=${MAVEN_TARGET_DIR}

ARG MAVEN_VERSION
ENV M2_HOME="${MAVEN_TARGET_DIR}/apache-maven-${MAVEN_VERSION}"

RUN ./installMaven.sh 

ENV PATH=${M2_HOME}:${PATH}

RUN mvn --version

COPY know-your-gpus.sh know-your-gpus.sh

RUN ./know-your-gpus.sh || true