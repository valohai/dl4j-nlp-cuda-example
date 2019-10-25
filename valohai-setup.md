# Valohai CLI installation and Valohai project setup

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

- watch an execution in process using it's counter number
```bash
$ vh watch 1
```

- show all the outputs (end-results) of an execution
```bash
$ vh outputs 1
```
- and download the one's of your choice
```bash
$ vh outputs --download . --filter *.logs 1
```
- run a step but override one of the step variables
```bash
$ vh exec run train-gpu-linux \
     --gpu-linux-uberjar=datum://016dff00-2095-4df7-5d9e-02cb7cd009bb [--adhoc]

### Overrides the gpu-linux-uberjar variable in the train-gpu-linux step
```
- stop a running or queue execution
```bash
$ vh stop 2
```