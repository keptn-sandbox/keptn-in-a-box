@Library('keptn-library')_

//import sh.keptn.*
//keptn = Keptn.instance
def keptn = new sh.keptn.Keptn()

node {
    try {
        properties([
            parameters([
            choice(choices: ['Zero', 'CPULoadJourneyService', 'DBSpammingAuthWithAppDeployment', 'LoginProblems', 'JourneyUpdateSlow', 'CreditCardCheckError500'], description: 'Name of the Deployment (Bug) in Easytravel to enable', name: 'EasyTravelDeployment', trim: false), 
            string(defaultValue: 'easytravel', description: 'Name of your Keptn Project for Performance as a Self-Service', name: 'Project', trim: false), 
            string(defaultValue: 'staging', description: 'Stage in your Keptn project used for Performance Feedback', name: 'Stage', trim: false), 
            string(defaultValue: 'classic-eval', description: 'Servicename (tag) used to keep SLIs, SLOs, test files ...(in Classic ET is the easyTravel Customer Frontend', name: 'Service', trim: false),
            choice(choices: ['fullbooking', 'fullbooking_5_100', 'fullbooking_10_100', 'fullbooking_10_150', 'fullbooking_50_1000'], description: 'Test Strategy aka Loadtest & Workload, e.g: fullbooking, fullbooking_5_100 , fullbooking_10_100, fullbooking_10_150, fullbooking_50_1000', name: 'TestStrategy', trim: false),
            string(defaultValue: 'easytravel-public-ip.nip.io', description: 'Magic Domain of the EasyTravel Application you want to run a test against, example 10.12.34.123.nip.io. The REST endpoint and EasyTravel Classic application will be accessed via subdomains e.g. http://rest.10.12.34.123.nip.io ', name: 'DeploymentURI', trim: false),
            string(defaultValue: '60', description: 'How many minutes to wait until Keptn is done? 0 to not wait', name: 'WaitForResult'),
            ])
        ])

        // Define Keptn Variables
        def keptnMap = [project:"${params.Project}", service:"${params.Service}", stage:"${params.Stage}", keptn_endpoint: env.KEPTN_ENDPOINT, keptn_api_token: env.KEPTN_API_TOKEN, keptn_bridge: env.KEPTN_BRIDGE]

        stage('Deploy EasyTravel Change') {

            def response = httpRequest url: "http://rest.${params.DeploymentURI}/services/ConfigurationService/setPluginEnabled?name=${params.EasyTravelDeployment}&enabled=true",
                httpMode: 'GET',
                timeout: 5,
                validResponseCodes: "202"

            println("Status: "+response.status)
            println("Content: "+response.content)
            /*
            More about EasyTravel problems
            https://community.dynatrace.com/community/pages/viewpage.action?title=Available+easyTravel+Problem+Patterns&spaceKey=DL        
            */
            String dt_tenant = env.DT_TENANT
            String dt_api_token = env.DT_API_TOKEN

            def requestBody = """{
                |   "eventType": "CUSTOM_DEPLOYMENT",
                |   "attachRules": {
                |       "tagRule" : {
                |           "meTypes" : [ "PROCESS_GROUP_INSTANCE", "APPLICATION" ],
                |           "tags": [
                |                    {
                |                        "context": "CONTEXTLESS",
                |                        "key": "Stage",
                |                        "value": "Staging"
                |                    },
                |                    {
                |                        "context": "CONTEXTLESS",
                |                        "key": "Application",
                |                        "value": "EasyTravel"
                |                    }
                |                    ]
                |       }
                |   },
                |   "deploymentName":"Deployment of feature [${params.EasyTravelDeployment}] with test-strategy ${params.TestStrategy} ",
                |   "deploymentVersion":"${params.EasyTravelDeployment}.${BUILD_ID}",
                |   "deploymentProject":"Easytravel FeatureFlags",
                |   "remediationAction":"https://dynatrace-perfclinics.github.io/codelabs/deploy-easytravel-at-localhost/index.html#6",
                |   "ciBackLink":"${BUILD_URL}",
                |   "source":"Jenkins",
                |   "customProperties":{
                |       "pipelineName":"${JOB_NAME}",
                |       "Project":"Why Devs Love Dynatrace",
                |       "Jenkins Build Number": "${BUILD_ID}",
                |       "Git Commit": "yae703c3",
                |       "Git Approver": "sergio.hinojosa@dynatrace.com",
                |       "ConfigurationService": "http://rest.${params.DeploymentURI}/services/ConfigurationService/",
                |       "ProblemPattern": "${params.EasyTravelDeployment}",
                |       "DeploymentURL": "http://classic.${params.DeploymentURI}",
                |       "Documentation": "https://dynatrace-perfclinics.github.io/codelabs/why-devs-love-dynatrace-2/"
                | }
                }
            """.stripMargin()

            echo requestBody
            def response_dt = httpRequest contentType: 'APPLICATION_JSON', 
                customHeaders: [[maskValue: true, name: 'Authorization', value: "Api-Token ${dt_api_token}"]], 
                httpMode: 'POST', 
                requestBody: requestBody, 
                responseHandle: 'STRING', 
                url: "https://${dt_tenant}/api/v1/events/", 
                validResponseCodes: "100:404", 
                ignoreSslErrors: false
            
            echo response_dt.content

        }

        stage('Initialize Keptn') {


            // Only Upload files if Project, Stage and Service exists, otherwise we give the customer the chance to modify them directly in GitOps.
            echo "Evaluating if Project.Stage.Service is available on Keptn, if not it will be created and the ressources will be uploaded."
           
            // Initiate the variables the json file
            def exists = keptn.keptnProjectServiceExists(keptnMap)

            if (exists) {
                echo "Project.Stage.Service [${params.Project}.${params.Stage}.${params.Service}] already available in Keptn. No further action required!"
                keptnMap.put('monitoring','dynatrace' )
                keptnMap.put('shipyard','keptn/shipyard.yaml' )
                keptn.downloadFile("https://raw.githubusercontent.com/keptn-sandbox/keptn-in-a-box/release-0.9.2/resources/jenkins/pipelines/keptn_devlove/shipyard.yaml", 'keptn/shipyard.yaml')
                // Initialize object so we can call the functions later with the values.
                keptn.keptnInit keptnMap

            } else {
                echo "Project.Stage.Service not available in Keptn. Further action required! Setting up the Project.Stage.Service"
                echo "Initialize Keptn and upload SLI,SLO and JMeter files from Github https://github.com/keptn-sandbox/keptn-in-a-box/release-0.9.2/resources/jenkins/pipelines/keptn_devlove/"
                keptn.downloadFile("https://raw.githubusercontent.com/keptn-sandbox/keptn-in-a-box/release-0.9.2/resources/jenkins/pipelines/keptn_devlove/shipyard.yaml", 'keptn/shipyard.yaml')
                keptn.downloadFile("https://raw.githubusercontent.com/keptn-sandbox/keptn-in-a-box/release-0.9.2/resources/jenkins/pipelines/keptn_devlove/dynatrace.conf.yaml", 'keptn/dynatrace.conf.yaml')
                keptn.downloadFile("https://raw.githubusercontent.com/keptn-sandbox/keptn-in-a-box/release-0.9.2/resources/jenkins/pipelines/keptn_devlove/slo.yaml", 'keptn/slo.yaml')
                keptn.downloadFile("https://raw.githubusercontent.com/keptn-sandbox/keptn-in-a-box/release-0.9.2/resources/jenkins/pipelines/keptn_devlove/sli.yaml", 'keptn/sli.yaml')
                keptn.downloadFile('https://raw.githubusercontent.com/keptn-sandbox/keptn-in-a-box/release-0.9.2/resources/jenkins/pipelines/keptn_devlove/jmeter/easytravel-classic-random-book.jmx', 'keptn/jmeter/easytravel-classic-random-book.jmx')
                keptn.downloadFile('https://raw.githubusercontent.com/keptn-sandbox/keptn-in-a-box/release-0.9.2/resources/jenkins/pipelines/keptn_devlove/jmeter/jmeter.conf.yaml', 'keptn/jmeter/jmeter.conf.yaml')

                //keptn.downloadFile('https://raw.githubusercontent.com/keptn-sandbox/keptn-in-a-box/release-0.9.2/resources/jenkins/pipelines/keptn_devlove/jmeter/easytravel-users.txt', 'keptn/jmeter/easytravel-users.txt')
                archiveArtifacts artifacts:'keptn/**/*.*'

                // Initialize the Keptn Project
                keptnMap.put('monitoring','dynatrace' )
                keptnMap.put('shipyard','keptn/shipyard.yaml' )
                keptn.keptnInit keptnMap

                // Upload all the files
                keptn.keptnAddResources('keptn/shipyard.yaml','shipyard.yaml')
                keptn.keptnAddResources('keptn/dynatrace.conf.yaml','dynatrace/dynatrace.conf.yaml')
                keptn.keptnAddResources('keptn/sli.yaml','dynatrace/sli.yaml')
                keptn.keptnAddResources('keptn/slo.yaml','slo.yaml')
                keptn.keptnAddResources('keptn/jmeter/easytravel-classic-random-book.jmx','jmeter/easytravel-classic-random-book.jmx')
                keptn.keptnAddResources('keptn/jmeter/jmeter.conf.yaml','jmeter/jmeter.conf.yaml')
                //keptn.keptnAddResources('keptn/jmeter/easytravel-users.txt','jmeter/easytravel-users.txt')
                //TODO How to add ressources to loadtest?
                //https://github.com/keptn/enhancement-proposals/issues/21
            }
        }

        stage('Trigger Performance Test') {
            echo "Performance as a Self-Service: Triggering Keptn to execute Tests against http://classic.${params.DeploymentURI}"

            // send deployment finished to trigger tests
            //TODO Remove port from URI due bug in 0.8
            //https://github.com/keptn/keptn/issues/3916
            keptnMap.put('testStrategy', params.TestStrategy )
            keptnMap.put('deploymentURI',"http://classic.${params.DeploymentURI}:80")
            keptnMap.put('problemPattern', params.EasyTravelDeployment)

            def keptnContext = sendConfigurationTriggeredEventEasyTravel keptnMap
            keptnMap.put('keptnContext', keptnContext)
            
            // sendConfigurationTriggeredEvent
            String keptn_bridge = env.KEPTN_BRIDGE
            echo "Open Keptns Bridge: ${keptn_bridge}/trace/${keptnContext}"
        }

        stage('Wait for evaluation result') {
            waitTime = 0
            if(params.WaitForResult?.isInteger()) {
                waitTime = params.WaitForResult.toInteger()
            }

            if(waitTime > 0) {
                echo "Waiting until Keptn is done and returns the results"

                keptnMap.put('setBuildResult',true)
                keptnMap.put('waitTime',waitTime)
                def result = keptn.waitForEvaluationDoneEvent keptnMap
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
        stage('Rollback EasyTravel Deployment Change') {

            def response = httpRequest url: "http://rest.${params.DeploymentURI}/services/ConfigurationService/setPluginEnabled?name=${params.EasyTravelDeployment}&enabled=false",
                httpMode: 'GET',
                validResponseCodes: "202",
                timeout: 5
            println("Status: "+response.status)
            println("Content: "+response.content)
        }

    } catch (e) {
        echo 'The new deployment failed, we do the needed action here'
        // Since we're catching the exception in order to report on it,
        throw e
        // we need to re-throw it, to ensure that the build is marked as failed
   } finally {

    def currentResult = currentBuild.result ?: 'SUCCESS'
    if (currentResult == 'UNSTABLE') {
        echo 'This will run only if the run was marked as unstable'
    }

    echo 'Rolling back the Problempattern regardless of the result'
    def response = httpRequest url: "http://rest.${params.DeploymentURI}/services/ConfigurationService/setPluginEnabled?name=${params.EasyTravelDeployment}&enabled=false",
    httpMode: 'GET',
    validResponseCodes: "202",
    timeout: 5
    println("Status: "+response.status)
    println("Content: "+response.content)

 }
}

/**
 * sendConfigurationTriggeredEvent(project, stage, service, image, [labels, keptn_endpoint, keptn_api_token])
 * Example: sendConfigurationTriggeredEvent
 * Will trigger a full delivery workflow in keptn!
 * changed to delivery.triggered for keptn 0.8.0
 */
def sendConfigurationTriggeredEventEasyTravel(Map args) {
    //def keptnInit = keptnLoadFromInit(args)
    def keptn = new sh.keptn.Keptn()
    def keptnInit = keptn.keptnLoadFromInit(args)
    echo "*** Printing Args ${args}"
    echo "*** Printing keptnInit ${keptnInit}"

    /* String project, String stage, String service, String deploymentURI, String testStrategy */
    String keptn_endpoint = args.containsKey('keptn_endpoint') ? args.keptn_endpoint : env.KEPTN_ENDPOINT
    String keptn_api_token = args.containsKey('keptn_api_token') ? args.keptn_api_token : env.KEPTN_API_TOKEN

    def labels = args.containsKey('labels') ? args.labels : [:]

    String project = keptnInit['project']
    String stage = keptnInit['stage']
    String service = keptnInit['service']
    String deploymentURI = args.containsKey("deploymentURI") ? args.deploymentURI : ""
    String testStrategy = args.containsKey("testStrategy") ? args.testStrategy : ""
    String problemPattern = args.containsKey('problemPattern') ? args.problemPattern : ''    
    String image = "easytravel.${problemPattern}"
    String tag = args.containsKey("tag") ? args.tag : "${BUILD_NUMBER}"

    echo "Sending a Configuration triggered event to Keptn for ${project}.${stage}.${service}"
    
    def requestBody = """{
        |  "data": {
        |    "project": "${project}",
        |    "service": "${service}",
        |    "stage": "${stage}",
        |    "image" : "${image}",
        |    "testStrategy": "${testStrategy}",
        |    "configurationChange": {
        |      "values": {
        |      "deploymentURIsPublic": "${deploymentURI}",
        |      "testStrategy": "${testStrategy}"
        |      }
        |    },
        |    "deployment": {
        |      "deploymentstrategy": "direct",
        |      "deploymentURIsPublic": [
        |                "${deploymentURI}"
        |             ]        
        |    },
        |    "labels": {
        |      "buildId" : "${problemPattern}.${tag}",
        |      "jobname" : "${JOB_NAME}",
        |      "buildNumber": "${BUILD_NUMBER}",
        |      "joburl" : "${BUILD_URL}",
        |      "problemPattern" : "${problemPattern}"
        |    }
        |  },
        |  "datacontenttype": "application/json",
        |  "source": "jenkins-library",
        |  "specversion": "1.0",
        |  "type": "sh.keptn.event.${stage}.delivery.triggered"
        |}
    """.stripMargin()

    echo requestBody

    // lets add our custom labels
    requestBody = keptn.addCustomLabels(requestBody, labels)
   
    echo requestBody

    def response = httpRequest contentType: 'APPLICATION_JSON', 
      customHeaders: [[maskValue: true, name: 'x-token', value: "${keptn_api_token}"]], 
      httpMode: 'POST', 
      requestBody: requestBody, 
      responseHandle: 'STRING', 
      url: "${keptn_endpoint}/v1/event", 
      validResponseCodes: "100:404", 
      ignoreSslErrors: true

    // write response to keptn.context.json & add to artifacts
    def keptnContext = keptn.writeKeptnContextFiles(response)
    
    return keptnContext
}