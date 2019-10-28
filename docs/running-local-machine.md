# Run the app on your local machine

## CPU version

### Training

```bash
$ export BACKEND=cpu 
$ export ACTION=train
$ ./runUberJar.sh --action ${ACTION} --output-model-dir .
```

Model file created is called `CnnSentenceClassificationModel-cpu.pb`.

### Evaluating

```bash
$ export BACKEND=cpu 
$ export ACTION=evaluate
$ ./runUberJar.sh --action ${ACTION} \
                    --input-model-file CnnSentenceClassificationModel-${BACKEND}.pb
```

## GPU version

**Note:** please ensure you have access to an Nvidia GPU and the necessary drivers i.e. CUDA, cuDNN etc... are installed.

### Training

```bash
$ export BACKEND=cpu 
$ export ACTION=train
$ ./runUberJar.sh --action ${ACTION} --output-model-dir .
```

Model file created is called `CnnSentenceClassificationModel-gpu.pb`.

### Evaluating

```bash
$ export BACKEND=gpu
$ export ACTION=evaluate
$ ./runUberJar.sh --action ${ACTION} \
                    --input-model-file CnnSentenceClassificationModel-${BACKEND}.pb
```

---

Return to main [README.md](../README.md)