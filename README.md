# terra-nemo-callback

Dockerfile and WDL for Terra to notify nemoarchive when a submission is complete.

To run WDL locally run:

```bash
java -jar cromwell-50.jar run <git_repo_root>/<monitor-pipeline-status>.wdl --inputs <git_repo_root>/import_inputs.json
```
