@Library('keptn-library')_
def keptn = new sh.keptn.Keptn()

node {
    properties([
        parameters([
         string(defaultValue: 'qualitygate-simpletest', description: 'Name of your Keptn Project for Quality Gate Feedback ', name: 'Project', trim: false), 
         string(defaultValue: 'qualitystage', description: 'Stage in your Keptn project used for for Quality Gate Feedback', name: 'Stage', trim: false), 
         string(defaultValue: 'evalservice', description: 'Servicename used to keep SLIs and SLOs', name: 'Service', trim: false),
         choice(choices: ['dynatrace', 'prometheus',''], description: 'Select which monitoring tool should be configured as SLI provider', name: 'Monitoring', trim: false),
         choice(choices: ['perftest','basic'], description: 'Decide which set of SLIs you want to evaluate. The sample comes with: basic and perftest', name: 'SLI'),
         string(defaultValue: 'http://frontend.keptnorders-staging.kiab.pcjeffint.com', description: 'URI of the application you want to run a test against', name: 'DeploymentURI', trim: false),
         string(defaultValue: '/:homepage;/order:order;/customer/list.html:customer;/catalog/list.html:catalog;/order/line:orderline', description: 'A semi-colon separated list of URIPaths:TestName tupples that the load test should generate load', name: 'URLPaths', trim: false),
         string(defaultValue: '3', description: 'How long shall we run load against the specified URL?', name: 'LoadTestTime'),
         string(defaultValue: '1000', description: 'Think time in ms (milliseconds) after each test cycle', name: 'ThinkTime'),
         string(defaultValue: '3', description: 'How many minutes to wait after load test is complete until Keptn is done? 0 to not wait', name: 'WaitForResult'),
        ])
    ])

    stage('Initialize Keptn') {
        // keptn.downloadFile("https://raw.githubusercontent.com/keptn-sandbox/performance-testing-as-selfservice-tutorial/release-0.7.3/shipyard.yaml", 'keptn/shipyard.yaml')
        keptn.downloadFile("https://raw.githubusercontent.com/dthotday-performance/keptn-in-a-box/release-0.7.3.2/resources/jenkins/pipelines/keptn/dynatrace/dynatrace.conf.yaml", 'keptn/dynatrace/dynatrace.conf.yaml')
        keptn.downloadFile("https://raw.githubusercontent.com/dthotday-performance/keptn-in-a-box/release-0.7.3.2/resources/jenkins/pipelines/keptn/slo_${params.SLI}.yaml", 'keptn/slo.yaml')
        keptn.downloadFile("https://raw.githubusercontent.com/dthotday-performance/keptn-in-a-box/release-0.7.3.2/resources/jenkins/pipelines/keptn/dynatrace/sli_${params.SLI}.yaml", 'keptn/sli.yaml')
        archiveArtifacts artifacts:'keptn/**/*.*'

        // Initialize the Keptn Project - ensures the Keptn Project is created with the passed shipyard
        keptn.keptnInit project:"${params.Project}", service:"${params.Service}", stage:"${params.Stage}", monitoring:"${monitoring}" // , shipyard:'shipyard.yaml'

        // Upload all the files
        keptn.keptnAddResources('keptn/dynatrace/dynatrace.conf.yaml','dynatrace/dynatrace.conf.yaml')
        keptn.keptnAddResources('keptn/sli.yaml','dynatrace/sli.yaml')
        keptn.keptnAddResources('keptn/slo.yaml','slo.yaml')
    }
    stage('Run simple load test') {
        echo "This is really just a very simple 'load simulated'. Dont try this at home :-)" 
        echo "For real testing - please use A REAL load testing tool in your pipeline such us JMeter, Neoload, Gatling ... - but - this is good for this demo"

        def loadTestTime = params.LoadTestTime?:"3"
        def thinkTime = params.ThinkTime?:200
        def url = "${params.DeploymentURI}"
        def urlPaths = params.URLPaths?:"/"
        def urlPathValues = urlPaths.tokenize(';')

        // Before we get started we mark the current timestamp which allows us to run the quality gate later on with exact timestamp info
        keptn.markEvaluationStartTime()

        // now we run the test
        script {
            runTestUntil = java.time.LocalDateTime.now().plusMinutes(loadTestTime.toInteger())
            echo "Lets run a test until: " + runTestUntil.toString()

            while (runTestUntil.compareTo(java.time.LocalDateTime.now()) >= 1) {
                // we loop through every URL that has been passed
                for (i=0;i<urlPathValues.size();i++) {
                    urlPath = urlPathValues[i].tokenize(':')[0]
                    testStepName = urlPathValues[i].tokenize(':')[1]

                    // Sends the request to the URL + Path and also send some x-dynatrace-test HTTP Headers: 
                    // TSN=Test Step Name, LSN=Load Script Name, LTN=Load Test Name
                    // More info: https://www.dynatrace.com/support/help/setup-and-configuration/integrations/third-party-integrations/test-automation-frameworks/dynatrace-and-load-testing-tools-integration/
                    def response = httpRequest customHeaders: [[maskValue: true, name: 'x-dynatrace-test', value: "TSN=${testStepName};LSN=SimpleTest;LTN=simpletest_${BUILD_NUMBER};"]], 
                        httpMode: 'GET', 
                        responseHandle: 'STRING', 
                        url: "${url}${urlPath}", 
                        validResponseCodes: "100:500", 
                        ignoreSslErrors: true
                }

                sleep(time:ThinkTime,unit:"MILLISECONDS")
            }
        }
    }
    stage('Trigger Quality Gate') {
        echo "Quality Gates ONLY: Just triggering an SLI/SLO-based evaluation for the passed timeframe"

        // Trigger an evaluation. It will take the starttime from our call to markEvaluationStartTime and will Now() as endtime
        def keptnContext = keptn.sendStartEvaluationEvent starttime:"", endtime:""
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
            def result = keptn.waitForEvaluationDoneEvent setBuildResult:true, waitTime:waitTime
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
                reportFiles          : 'keptn.html',
                reportName           : "Keptn Result in Bridge"
            ]
        )
    }
}
