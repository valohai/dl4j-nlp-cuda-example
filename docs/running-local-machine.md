# Run the app on your local machine

## CPU version

### Training

```bash
$ BACKEND=cpu ./runUberJar.sh --action train --output-model-dir .
```

Model file created is called `CnnSentenceClassificationModel-cpu.pb`.

### Evaluating

```bash
$ BACKEND=cpu ./runUberJar.sh --action evaluate \
                    --input-model-file CnnSentenceClassificationModel-cpu.pb
```

## GPU version

**Note:** please ensure you have access to an Nvidia GPU and the necessary drivers i.e. CUDA, cuDNN etc... are installed.

### Training

```bash
$ BACKEND=gpu ./runUberJar.sh --action train --output-model-dir .
```

Model file created is called `CnnSentenceClassificationModel-gpu.pb`.

### Evaluating

```bash
$ BACKEND=gpu ./runUberJar.sh --action evaluate \
                    --input-model-file CnnSentenceClassificationModel-gpu.pb
```

---

Return to main [README.md](../README.md)