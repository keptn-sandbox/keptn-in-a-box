@Library('keptn-library@6.0.0-next.0')
import sh.keptn.Keptn
def keptn = new sh.keptn.Keptn()

// Initialize Keptn: "Link" it to your Jenkins Pipeline
// -------------------------------------------
// initialize keptn: will store project, service and stage in a local context file so you don't have to pass it to all other functions
keptn.keptnInit project:"yourproject", service:"yourservice", stage:"yourstage"

// initialize keptn with Shipyard: if a shipyard file is passed keptnInit will also make sure this project is created in Keptn
// This allows you to automatically create a Keptn project for your Jenkins pipeline w/o having to do anything with Keptn directly
keptn.keptnInit project:"yourproject", service:"yourservice", stage:"yourstage", shipyard:'shipyard.yaml'


// Upload your Monitoring Configuration, SLIs and SLOs to Keptn
// --------------------------------------------
// If you want to fully automate the Keptn configuration you should upload your sli.yaml, slo.yaml and optionally files such as your tests
// First parameter defines the file in your local Jenkins Workspace, the second one the location Keptn will use to store it in its own Git
keptn.keptnAddResources('keptn/sli.yaml','dynatrace/sli.yaml')
keptn.keptnAddResources('keptn/slo.yaml','slo.yaml')
keptn.keptnAddResources('keptn/dynatrace.conf.yaml','dynatrace/dynatrace.conf.yaml')
// OR in case you use prometheus:
// keptn.keptnAddResources('keptn/sli.yaml','prometheus/sli.yaml')

// Add downloadFile
// https://github.com/keptn-sandbox/keptn-jenkins-library/blob/1194793d522816e30df4296ff59d73c8221e97ff/src/sh/keptn/Keptn.groovy#L19-L32

// Upload Test Scripts
keptn.keptnAddResources('keptn/load.jmx','jmeter/load.jmx')

// Configure monitoring for your keptn project (using dynatrace or prometheus)
// SHOULD NOT BE Necesarry for CloudAutomation 
keptn.keptnConfigureMonitoring monitoring:"dynatrace"

// OR in case you use prometheus:
// keptn.keptnConfigureMonitoring monitoring:"prometheus"

// Custom Labels
// all keptn.send** functions have an optional parameter called labels. It is a way to pass custom labels to the sent event
def labels=[:]
labels.put('TriggeredBy', 'Andi')

// Quality Gate Evaluation Use Case
// ------------------------------------------
// Start a quality gate evaluation. There are multiple timeframe options, e.g: using timestamps or number minutes from Now()
// Example #1: Evaluate the last 10 minutes
def keptnContext = keptn.sendStartEvaluationEvent starttime:"600", endtime:"0" 

// Example #2: Evaluate the previous hour. End=Now()-3600, Start=Now()-7200
def keptnContext = keptn.sendStartEvaluationEvent starttime:"7200", endtime:"3600" 

// Example #3: Evaluate a specific timeframe
def keptnContext = keptn.sendStartEvaluationEvent starttime:"2019-06-07T07:00:00.0000Z", endtime:"2019-06-07T08:00:00.0000Z", labels: labels

// Example #4: Mark a starting timestamp before executing your tests
// Following example will fill starttime with the time when you called markEvaluationStartTime and as end is empty will default to Now()
keptn.markEvaluationStartTime()

// ... 
// ^^^ here is where you would execute any existing tests

// Send a test.finished event
def keptnContext = keptn.sendFinishedEvent eventType: "test", keptnContext: "${params.shkeptncontext}", triggeredId: "${params.triggeredid}", result:"pass", status:"succeeded"
echo "Open Keptns Bridge: ${keptn_bridge}/trace/${keptnContext}"


// Example #5: Progressive Delivery Use Case
// If you want Keptn to deploy, test and evaluate then we can simply inform Keptn that we want to 
// trigger a delivery with a container image.
// Typically you would use your Jenkins to build and push a container to your container registry. 
// After that you notify Keptn about it
def keptnContext = keptn.sendDeliveryTriggeredEvent image:"docker.io/myorg/my-image:1.2.3"
String keptn_bridge = env.KEPTN_BRIDGE
echo "Open Keptns Bridge: ${keptn_bridge}/trace/${keptnContext}"

// --------------------------------------------
// Waiting for Quality Gate Result (5 Minutes)
// --------------------------------------------
def result = keptn.waitForEvaluationDoneEvent setBuildResult:true, waitTime:5
echo "${result}"