# Build the app using the Valohai platform

We mean using the [Valohai CLI](https://docs.valohai.com/tutorials/quick-start-cli.html?highlight=cli) to run executions on the [Valohai](https://valohai.org) platform.

## CPU & GPU version

```bash
$ vh exec run build-cpu-gpu-uberjar [--adhoc]

### Run `vh exec run --help` to find out more about this command
```

Note: use `--adhoc` only if you have not setup your Valohai project with a git repo or have unsaved commits and want to experiment before being sure of the configuration.

Creates and uploads the artifacts into the Valohai storage which can be referred to later on.

## Run the app using the Valohai platform

### CPU version

#### Training

```bash
$ vh exec run train-cpu-linux 
    --cpu-linux-uberjar=datum://016dffe8-0faa-ca1d-4ce4-994274576fe1 [--adhoc]

### Run `vh exec run --help` to find out more about this command
```

#### Evaluation

```bash
$ vh exec run evaluate-model-linux \
                --uber-jar=datum://016dff00-43b7-b599-0e85-23a16749146e \
                --model=datum://016dff2a-a0d4-3e63-d8da-6a61a96a7ba6 [--adhoc]
```

### GPU version

#### Training

```bash
$ vh exec run train-gpu-linux \
    --gpu-linux-uberjar=datum://016dffe8-0faa-ca1d-4ce4-994274576fe1 [--adhoc]

### Run `vh exec run --help` to find out more about this command
```

#### Evaluation

```bash
$ vh exec run evaluate-model-linux \
                --uber-jar=datum://016dff00-2095-4df7-5d9e-02cb7cd009bb \
                --model=datum://016dff2a-a0d4-3e63-d8da-6a61a96a7ba6 [--adhoc]
```

**Note:** the `datum://[sha]` links used in all the above examples will have to be replaced with the ones relevant iny our case, you can get them by quering the exections, outputs and other running tasks - using the [Valohai CLI](https://docs.valohai.com/tutorials/quick-start-cli.html?highlight=cli) tool.
