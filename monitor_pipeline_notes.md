# Monitor Pipeline

(Meeting notes from Spring 2020)

* We created the monitor_submission.wdl (which calls a python script *monitor_submission.py from its task monitor) that requires as input the terra_project, terra_workspace, and submission_id relevant to the submission you want to monitor (in your case, it would be the Optimus workflow launched by your script). It will continue to run until the monitored submission is complete - either success or fail - and will return a Boolean value reflecting success and a monitor_submission_metadata.json file.
    * Note: monitor_submission.py contains example code for parsing monitor_submission_metadata.json file for successful workflow_ids and passing those to a different API call to retrieve paths of Optimus workflow outputs.
* The monitor_submission.wdl is currently hosted from Dockstore via our broadinstitute/horsefish repo (branch: master).

## Resources

* Test Workspace where we have called Optimus and the monitoring pipelines via the UI - NeMO team has READER access and will need to “Clone” to perform actions but otherwise you should be able to look through the submissions and Workflow configurations.
    * We first submitted an Optimus Workflow then submitted the             monitor_submission workflow. When Optimus succeeded or failed, we checked the Boolean value to make sure the true or false value matched the Optimus workflow outcome.
* Lucid Chart for visual outline of full pipeline.

## NeMO Team Action Items

### In WDL

1. Use output of monitor_submission.wdl to trigger Nemo webhook:
    1. Option 1: modify monitor_submission.wdl by adding NeMo webhook task
    2. Option 2: call monitor_submission.wdl as a subworkflow from a wrapper WDL that has NeMo webhook task.

### In their master python script:

1. Retrieve (via API) the submission_id of launched Optimus workflow.
2. Pass submission_id, terra_project, terra_workspace to launch monitor_submission.wdl (or the wrapper wdl that includes the NeMO webhook) via a monitoring_submission_inputs.json.#