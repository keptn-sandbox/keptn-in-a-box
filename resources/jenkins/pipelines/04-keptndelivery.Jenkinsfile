@Library('keptn-library')_
def keptn = new sh.keptn.Keptn()

node {
    properties([
        parameters([
         string(defaultValue: 'keptnorders', description: 'Name of your Keptn Project you have setup for progressive delivery', name: 'Project', trim: false), 
         string(defaultValue: 'staging', description: 'First stage you want to deploy into', name: 'Stage', trim: false), 
         string(defaultValue: 'order', description: 'Name of the service you provide a configuration change for', name: 'Service', trim: false),
         string(defaultValue: 'docker.io/dtdemos/dt-orders-order-service:2', description: 'Name of the service you provide a configuration change for', name: 'Image', trim: false),
         string(defaultValue: 'customer', description: 'Name of the service you provide a configuration change for', name: 'Service2', trim: false),
         string(defaultValue: 'docker.io/dtdemos/dt-orders-customer-service:3', description: 'Name of the service you provide a configuration change for', name: 'Image2', trim: false),
         string(defaultValue: '60', description: 'How many minutes to wait until Keptn is done? 0 to not wait', name: 'WaitForResult'),
        ])
    ])

    stage('Trigger Delivery') {
        echo "Progressive Delivery: Triggering Keptn to deliver ${params.Image}"

        // send deployment finished to trigger tests
        def keptnContext = keptn.sendConfigurationChangedEvent project:"${params.Project}", service:"${params.Service}", stage:"${params.Stage}", image:"${params.Image}" 
        String keptn_bridge = env.KEPTN_BRIDGE
        echo "Open Keptns Bridge: ${keptn_bridge}/trace/${keptnContext}"
    }
    stage('Trigger Delivery2') {
        echo "Progressive Delivery: Triggering Keptn to deliver ${params.Image2}"

        // send deployment finished to trigger tests
        def keptnContext = keptn.sendConfigurationChangedEvent project:"${params.Project}", service:"${params.Service2}", stage:"${params.Stage}", image:"${params.Image2}" 
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
    }
}
