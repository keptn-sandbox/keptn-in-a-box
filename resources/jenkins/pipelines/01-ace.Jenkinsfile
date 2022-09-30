@Library('ace@v1.1') ace
@Library('jenkinstest@v1.2.1') jenkinstest
@Library('keptn-library@5.1') keptnlib
import sh.keptn.Keptn

def cloudautomation = new sh.keptn.Keptn()
def event = new com.dynatrace.ace.Event()
def jmeter = new com.dynatrace.ace.Jmeter()
 
def tagMatchRules = [
    [
        "meTypes": [ "PROCESS_GROUP_INSTANCE"],
        tags: [
            ["context": "ENVIRONMENT", "key": "DT_APPLICATION_BUILD_VERSION", "value": "${env.ART_VERSION}"],
            ["context": "KUBERNETES", "key": "app.kubernetes.io/name", "value": "${env.APP_NAME}"],
            ["context": "KUBERNETES", "key": "app.kubernetes.io/part-of", "value": "simplenode-app"],
            ["context": "KUBERNETES", "key": "app.kubernetes.io/component", "value": "api"],
            ["context": "CONTEXTLESS", "key": "environment", "value": "staging"]
        ]
    ]
]

pipeline {
    parameters {
        string(name: 'APP_NAME', defaultValue: 'simplenodeservice', description: 'The name of the service to deploy.', trim: true)
        string(name: 'BUILD', defaultValue: '', description: 'The build version to deploy.', trim: true)
        string(name: 'ART_VERSION', defaultValue: '', description: 'Artefact version that is being deployed.', trim: true)
    }
    environment {
        ENVIRONMENT = 'staging'
        PROJECT = 'simplenodeproject'
        MONITORING = 'dynatrace'
        VU = 1
        LOOPCOUNT = 100
        COMPONENT = 'api'
        PARTOF = 'simplenode-app'
    }
    agent {
        label 'kubegit'
    }
    stages {
   
        stage ('Quality Gate Init') {
            steps {
                checkout scm
                script {
                    cloudautomation.keptnInit project:"${env.PROJECT}", service:"${env.APP_NAME}", stage:"${env.ENVIRONMENT}", monitoring:'dynatrace', shipyard:'cloudautomation/shipyard.yaml'
                    cloudautomation.keptnAddResources('cloudautomation/sli_appsec_gen.yaml','dynatrace/sli.yaml')
                    cloudautomation.keptnAddResources('cloudautomation/slo_appsec.yaml','slo.yaml')
                    cloudautomation.keptnAddResources('cloudautomation/dynatrace.conf.yaml','dynatrace/dynatrace.conf.yaml')
                }
            }
        }
        stage('DT Test Start') {
            steps {
                    script {
                        def status = event.pushDynatraceInfoEvent (
                            tagRule: tagMatchRules,
                            title: "Jmeter Start ${env.APP_NAME} ${env.ART_VERSION}",
                            description: "Performance test started for ${env.APP_NAME} ${env.ART_VERSION}",
                            source : "jmeter",
                            customProperties : [
                                "Jenkins Build Number": env.BUILD_ID,
                                "Virtual Users" : env.VU,
                                "Loop Count" : env.LOOPCOUNT
                            ]
                        )
                    }
            }
        }
        stage('Run performance test') {
            steps {
                script {
                    cloudautomation.markEvaluationStartTime()
                }
                checkout scm
                container('jmeter') {
                    script {
                        def status = jmeter.executeJmeterTest ( 
                            scriptName: "jmeter/simplenodeservice_load.jmx",
                            resultsDir: "perfCheck_${env.APP_NAME}_staging_${BUILD_NUMBER}",
                            serverUrl: "simplenodeservice.staging", 
                            serverPort: 80,
                            checkPath: '/health',
                            vuCount: env.VU.toInteger(),
                            loopCount: env.LOOPCOUNT.toInteger(),
                            LTN: "perfCheck_${env.APP_NAME}_${BUILD_NUMBER}",
                            funcValidation: false,
                            avgRtValidation: 4000
                        )
                        if (status != 0) {
                            currentBuild.result = 'FAILED'
                            error "Performance test in staging failed."
                        }
                    }
                }
            }
        }
        stage('DT Test Stop') {
            steps {
                    script {
                        def status = event.pushDynatraceInfoEvent (
                             tagRule: tagMatchRules,
                             title: "Jmeter Stop ${env.APP_NAME} ${env.ART_VERSION}",
                             description: "Performance test stopped for ${env.APP_NAME} ${env.ART_VERSION}",
                             source : "jmeter",
                             customProperties : [
                                 "Jenkins Build Number": env.BUILD_ID,
                                 "Virtual Users" : env.VU,
                                 "Loop Count" : env.LOOPCOUNT
                             ]
                         )
                    }
            }
        }

        stage('Quality Gate') {
            steps {
                script {
                    sleep(time:600,unit:"SECONDS")
                    def labels=[:]
                    labels.put("DT_RELEASE_VERSION", "${env.BUILD}.0.0")
                    labels.put("DT_RELEASE_BUILD_VERSION", "${env.ART_VERSION}")
                    labels.put("DT_RELEASE_STAGE", "${env.ENVIRONMENT}")
                    labels.put("DT_RELEASE_PRODUCT", "${env.PARTOF}")
                    
                    def context = cloudautomation.sendStartEvaluationEvent starttime:"", endtime:"", labels:labels
                    echo context
                    result = cloudautomation.waitForEvaluationDoneEvent setBuildResult:true, waitTime:3

                    res_file = readJSON file: "keptn.evaluationresult.${context}.json"

                    echo res_file.toString();
                }
            }
        }

        stage('Release approval') {
            // no agent, so executors are not used up when waiting for approvals
            agent none
            steps {
                script {
                    switch(currentBuild.result) {
                        case "SUCCESS": 
                            env.DPROD = true;
                            break;
                        case "UNSTABLE": 
                            try {
                                timeout(time:3, unit:'MINUTES') {
                                    env.APPROVE_PROD = input message: 'Promote to Production', ok: 'Continue', parameters: [choice(name: 'APPROVE_PROD', choices: 'YES\nNO', description: 'Deploy from STAGING to PRODUCTION?')]
                                    if (env.APPROVE_PROD == 'YES'){
                                        env.DPROD = true
                                    } else {
                                        env.DPROD = false
                                    }
                                }
                            } catch (error) {
                                env.DPROD = false
                                echo 'Timeout has been reached! Deploy to PRODUCTION automatically stopped'
                            }
                            break;
                        case "FAILURE":
                            env.DPROD = false;
                            def status = event.pushDynatraceErrorEvent (
                                tagRule: tagMatchRules,
                                title: "Quality Gate failed for ${env.APP_NAME} ${env.ART_VERSION}",
                                description: "Quality Gate evaluation failed for ${env.APP_NAME} ${env.ART_VERSION}",
                                source : "jenkins",
                                customProperties : [
                                    "Jenkins Build Number": env.BUILD_ID
                                ]
                            )
                            break;
                    }
                }
            }
        }

        stage('Promote to production') {
            // no agent, so executors are not used up when waiting for other job to complete
            agent none
            when {
                expression {
                    return env.DPROD == 'true'
                }
            }
            steps {
                build job: "4. Deploy production",
                    wait: false,
                    parameters: [
                        string(name: 'APP_NAME', value: "${env.APP_NAME}"),
                        string(name: 'BUILD', value: "${env.BUILD}"),
                        string(name: 'ART_VERSION', value: "${env.ART_VERSION}")
                    ]
            }
        }  
    }
}