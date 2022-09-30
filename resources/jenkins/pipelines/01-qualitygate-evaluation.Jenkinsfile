//@Library('keptn-library@6.0.0-next.0')_
@Library('keptn-library@5.1')_
import sh.keptn.Keptn
def cloudautomation = new sh.keptn.Keptn()

node {
    properties([
        parameters([
         string(defaultValue: 'qualitygate', description: 'Name of your Project for Quality Gate Feedback ', name: 'Project', trim: false), 
         //TODO replace the stage in the Shipyard?
         string(defaultValue: 'qualitystage', description: 'Stage used for for Quality Gate Feedback', name: 'Stage', trim: false), 
         string(defaultValue: 'evalservice', description: 'Name of the Tag for identifyting the service to validate the SLIs and SLOs', name: 'Service', trim: false),
         choice(choices: ['dynatrace', 'prometheus',''], description: 'Select which monitoring tool should be configured as SLI provider', name: 'Monitoring', trim: false),
         choice(choices: ['basic', 'perftest'], description: 'Decide which set of SLIs you want to evaluate. The sample comes with: basic and perftest', name: 'SLI'),
         string(defaultValue: '660', description: 'Start timestamp or number of seconds from Now()', name: 'StartTime', trim: false),
         string(defaultValue: '60', description: 'End timestamp or number of seconds from Now(). If empty defaults to Now()', name: 'EndTime', trim: false),
         string(defaultValue: '3', description: 'How many minutes to wait until Keptn is done? 0 to not wait', name: 'WaitForResult'),
        ])
    ])

    stage('Initialize Keptn') {

        // TODO Optimize with if Project exists download otherwise not.
        cloudautomation.downloadFile("https://raw.githubusercontent.com/keptn-sandbox/keptn-in-a-box/release-0.10.0/resources/jenkins/pipelines/keptn/shipyard-performance.yaml", 'shipyard.yaml')
        cloudautomation.downloadFile("https://raw.githubusercontent.com/keptn-sandbox/keptn-in-a-box/release-0.10.0/resources/jenkins/pipelines/keptn/dynatrace/dynatrace.conf.yaml", 'dynatrace/dynatrace.conf.yaml')
        cloudautomation.downloadFile("https://raw.githubusercontent.com/keptn-sandbox/keptn-in-a-box/release-0.10.0/resources/jenkins/pipelines/keptn/slo_${params.SLI}.yaml", 'slo.yaml')
        cloudautomation.downloadFile("https://raw.githubusercontent.com/keptn-sandbox/keptn-in-a-box/release-0.10.0/resources/jenkins/pipelines/keptn/dynatrace/sli_${params.SLI}.yaml", 'sli.yaml')
        
        //The stages are defined in the shipyard file
        sh """#!/bin/bash
        echo 'Replacing stage in shipyard file'
        sed -i 's~staging~${params.Stage}~g' shipyard.yaml
        cat shipyard.yaml
        """

        // Initialize the Keptn Project - ensures the Keptn Project is created with the passed shipyard
        cloudautomation.keptnInit project:"${params.Project}", service:"${params.Service}", stage:"${params.Stage}", monitoring:'dynatrace', shipyard:'shipyard.yaml'

        // Upload all the files
        cloudautomation.keptnAddResources('slo.yaml','slo.yaml')
        cloudautomation.keptnAddResources('dynatrace/dynatrace.conf.yaml','dynatrace/dynatrace.conf.yaml')
        cloudautomation.keptnAddResources('sli.yaml','dynatrace/sli.yaml')

        // Configure monitoring for your keptn project (using dynatrace or prometheus)
        // NOT Necesarry for CloudAutomation 
        //cloudautomation.keptnConfigureMonitoring monitoring:"dynatrace"
    }
    stage('Trigger Quality Gate') {
        echo "Quality Gates ONLY: Just triggering an SLI/SLO-based evaluation for the passed timeframe"
        // Custom Labels
        // all cloudautomation.send** functions have an optional parameter called labels. It is a way to pass custom labels to the sent event
        def labels=[:]
        labels.put('TriggeredBy', 'Jenkins')

        // Trigger an evaluation
        def keptnContext = cloudautomation.sendStartEvaluationEvent starttime:"${params.StartTime}", endtime:"${params.EndTime}", labels: labels
        String keptn_bridge = env.KEPTN_BRIDGE
        echo "Open Keptns Bridge: ${keptn_bridge}/trace/${keptnContext}"
    }
    stage('Wait for Result') {
        waitTime = 0
        if(params.WaitForResult?.isInteger()) {
            waitTime = params.WaitForResult.toInteger()
        }

        if(waitTime > 0) {
            echo "Waiting until Keptn is done and returns the results"
            def result = cloudautomation.waitForEvaluationDoneEvent setBuildResult:true, waitTime:waitTime
            echo "${result}"
        } else {
            echo "Not waiting for results. Please check the Keptns bridge for the details!"
        }
        // Generating the Report so you can access the results directly in Keptns Bridge
        publishHTML(
            target: [
                allowMissing         : false,
                alwaysLinkToLastBuild: false,
                keepAll              : true,
                reportDir            : ".",
                reportFiles          : 'cloudautomation.html',
                reportName           : "Keptn Result in Bridge"
            ]
        )
    }
}