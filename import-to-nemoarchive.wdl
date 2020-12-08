version 1.0

import "https://raw.githubusercontent.com/broadinstitute/horsefish/master/pipelines/monitor_submission/monitor_submission.wdl" as Monitor
# import "https://raw.githubusercontent.com/nemoarchive/terra-nemo-callback/master/post-to-nemo-webhook.wdl?token=ABLHI6RBSDK5GQ3TOBF64NK6YPK22" as Webhook

workflow MonitorOptimus {

    input {
        String optimus_submission_id
        String terra_project
        String terra_workspace
    }

    call Monitor.monitor_submission {
        input:
            submission_id = optimus_submission_id,
            terra_project = terra_project,
            terra_workspace = terra_workspace,
    }

    # call Webhook.postToNemoWebhook {
    call post {
        input: input_json = monitor_submission.metadata_json
    }
}

task post {

    input {
        File input_json
    }


    command { /opt/docker-entrypoint.sh "${input_json}" }

    runtime {
        docker: "<my_org/built_docker_image:latest>"
        #failonstderr: true
    }

    output {
        String response_stdout = read_string(stdout())
        String response_stderr = read_string(stderr())
    }
}