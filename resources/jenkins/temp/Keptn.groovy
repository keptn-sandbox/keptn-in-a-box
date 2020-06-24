package sh.keptn

/**
 * Downloads a file from the given url and stores it in the local workspace
 */
def downloadFile(url, file) {
    def downloadFileResponse = httpRequest httpMode: 'GET', 
            responseHandle: 'STRING', 
            url: url, 
            validResponseCodes: "100:404",
            ignoreSslErrors: true

    if (downloadFileResponse.status == 200) {
        echo "Successfully requested file from url: ${url}"
        writeFile file:file, text:downloadFileResponse.content
    } else {
        echo "Couldn't download file from url: ${url}. Response Code: " + createProjectResponse.status
    }
}

def getKeptnContextJsonFilename() {return "keptn.context.${BUILD_NUMBER}.json"}
def getKeptnInitJsonFilename() {return "keptn.init.${BUILD_NUMBER}.json"}

/** 
 * Loads the JSON from keptn.init and returns a json map - also merges the incoming parameters and fills in keptn_endpoint & keptn_api_token
 * Usage:
 * def keptnInit = keptnLoadFromInit(args)
 * echo keptnInit['project']
 */
def keptnLoadFromInit(Map args) {
    def keptnInitFileJson
    if (fileExists(file: getKeptnInitJsonFilename())) {
        def keptInitFileJsonContent = readFile getKeptnInitJsonFilename()
        echo keptInitFileJsonContent
        keptnInitFileJson = readJSON text: keptInitFileJsonContent
        /* for (keptnEntries in keptnInitFileJson) {
            println(keptnEntries.key + " = " +  keptnEntries.value)
        }*/
    } else {
        keptnInitFileJson = [:]
    }

    // now adding additoinal values from args to the map
    for ( argEntry in args ) {
        if (!keptnInitFileJson.containsKey(argEntry.key)) {
            keptnInitFileJson[argEntry.key] = argEntry.value
            // println("putting " + argEntry.key + "," + "${argEntry.value}")
        }
    }

    // add the keptn endpoint & token!
    String keptn_endpoint = args.containsKey("keptn_endpoint") ? args.keptn_endpoint : env.KEPTN_ENDPOINT
    String keptn_api_token = args.containsKey("keptn_api_token") ? args.keptn_api_token : env.KEPTN_API_TOKEN
    keptnInitFileJson['keptn_endpoint'] = keptn_endpoint
    keptnInitFileJson['keptn_api_token'] = keptn_api_token

    // iterate over all arguments and print them
    /*println("final map entries")
    for (keptnEntries in keptnInitFileJson) {
        println(keptnEntries.key + " = " +  keptnEntries.value)
    }*/

    return keptnInitFileJson
}

/** 
 * keptnInit(project, stage, service, [shipyard], [monitoring])
 * Stores these values in keptn.init.json and makes sure that the Keptn project, stage and service exists
 * If shipyard is specified will create the project with the passed shipyard. If the project already exists it will just return the indicator that the project exists
 * If monitoring is specified, e.g: dynatrace, prometheus a configure-monitoring event is sent for this project!
 */
def keptnInit(Map args) {
    String keptn_endpoint = args.containsKey("keptn_endpoint") ? args.keptn_endpoint : env.KEPTN_ENDPOINT
    String keptn_api_token = args.containsKey("keptn_api_token") ? args.keptn_api_token : env.KEPTN_API_TOKEN

    String project = args.containsKey("project") ? args.project : ""
    String stage = args.containsKey("stage") ? args.stage : ""
    String service = args.containsKey("service") ? args.service : ""
    String monitoring = args.containsKey("monitoring") ? args.monitoring : ""

    if ((project == "") || (stage == "") || (service == "")) {
        echo "keptnInit requires project, stage and service to be set. These values cant be empty!"
        return false;
    }

    // write our key keptn params to keptn.init.json
    def initJson = [project: "${project}",service:"${service}",stage: "${stage}"]
    writeJSON file: getKeptnInitJsonFilename(), json: initJson
    def keptnInit = keptnLoadFromInit(args)

    project = keptnInit['project']
    echo "Project: ${project}"

    // Step #0: Generate or use the shipyard file passed
    def shipyardFileContent = """stages:
    |  - name: "${stage}"
    |    test_strategy: "performance"    
    """.stripMargin()
    if (args.containsKey("shipyard")) {
        // lets see if a shipyard was passed - if so - we use that shipyard.yaml
        shipyardFileContent = readFile(args.shipyard)
    }

    // Step #1: Create Project
    // TODO: will change this once we have a GET /project/{project} endpoint to query whether Project alread exists

    //perform base64 encoding on shipyard file
    String shipyardBase64Encoded = shipyardFileContent.bytes.encodeBase64().toString()
    def createProjectBody = """{
        "name" : "${project}", 
        "shipyard" : "${shipyardBase64Encoded}"
    }"""
    def createProjectResponse = httpRequest contentType: 'APPLICATION_JSON', 
        customHeaders: [[maskValue: true, name: 'x-token', value: "${keptn_api_token}"]], 
        httpMode: 'POST', 
        requestBody: createProjectBody, 
        responseHandle: 'STRING', 
        url: "${keptn_endpoint}/v1/project", 
        validResponseCodes: "100:404",
        ignoreSslErrors: true

    if (createProjectResponse.status == 200) {
        echo "Created new Keptn Project: ${project}"
    } else {
        echo "Couldnt create Keptn Project bc it probably exists ${project}: " + createProjectResponse.content          
    }

    // Step #2: Create Service
    // TODO: will change this once we have a GET /project/{project}/service/{service} endpoint to query whether service alread exists
    def createServiceBody = """{
        "serviceName" : "${service}"
    }"""
    def createServiceResponse = httpRequest contentType: 'APPLICATION_JSON', 
        customHeaders: [[maskValue: true, name: 'x-token', value: "${keptn_api_token}"]], 
        httpMode: 'POST', 
        requestBody: createServiceBody, 
        responseHandle: 'STRING', 
        url: "${keptn_endpoint}/v1/project/${project}/service", 
        validResponseCodes: "100:404",
        ignoreSslErrors: true

    if (createServiceResponse.status == 200) {
        echo "Created new Keptn Service: ${service}"
    } else {
        echo "Couldnt create Keptn Service ${service}: " + createServiceResponse.content          
    }

    // Step #3: Configure Monitoring
    // This will ensure that the monitoring tool of choice is configured
    if(monitoring != "") {
        def configureMonitoringBody = """{
            |  "contenttype": "application/json",
            |  "data": {
            |    "project": "${project}",
            |    "service": "${service}",
            |    "type": "${monitoring}"
            |  },
            |  "source": "Jenkins",
            |  "specversion": "0.2",
            |  "type": "sh.keptn.event.monitoring.configure"
            |}
        """.stripMargin()
        def configureMonitoringResponse = httpRequest contentType: 'APPLICATION_JSON', 
            customHeaders: [[maskValue: true, name: 'x-token', value: "${keptn_api_token}"]], 
            httpMode: 'POST', 
            requestBody: configureMonitoringBody, 
            responseHandle: 'STRING', 
            url: "${keptn_endpoint}/v1/event", 
            validResponseCodes: "100:404",
            ignoreSslErrors: true

        if (configureMonitoringResponse.status == 200) {
            echo "Successfully configured monitoring for: ${monitoring}"
        } else {
            echo "Couldnt configure monitoring for ${monitoring}: " + configureMonitoringResponse.content          
        }    
    }
}

/**
 * Deletes a keptn project
 */
def keptnDeleteProject(Map args) {
    def keptnInit = keptnLoadFromInit(args)

    def deleteProjectResponse = httpRequest contentType: 'APPLICATION_JSON', 
        customHeaders: [[maskValue: true, name: 'x-token', value: "${keptnInit['keptn_api_token']}"]], 
        httpMode: 'DELETE', 
        responseHandle: 'STRING', 
        url: "${keptnInit['keptn_endpoint']}/v1/project/${keptnInit['project']}", 
        validResponseCodes: "100:404",
        ignoreSslErrors: true

    echo "Response from upload resource: " + deleteProjectResponse.content
}


/**
 * keptnAddResources(['localfile1': remotelocation1,'localfile2': remotelocation, ...])
 * Allows you to upload a local files to the remote resource on keptn's Git repo on service level
 */
def keptnAddResources(file, remoteUri) {
    def keptnInit = keptnLoadFromInit([:])

    if (fileExists(file: file)) {
        def localFile = readFile(file)
        print "loaded file ${file}"
        //perform base64 encoding
        String localFileBase64Encoded = localFile.bytes.encodeBase64().toString()

        //Update SLO in keptn
        def requestBody = """{
            "resources" : [{"resourceURI": "${remoteUri}","resourceContent": "${localFileBase64Encoded}"}]
        }"""

        def addResourceResponse = httpRequest contentType: 'APPLICATION_JSON', 
            customHeaders: [[maskValue: true, name: 'x-token', value: "${keptnInit['keptn_api_token']}"]], 
            httpMode: 'POST', 
            requestBody: requestBody, 
            responseHandle: 'STRING', 
            url: "${keptnInit['keptn_endpoint']}/v1/project/${keptnInit['project']}/stage/${keptnInit['stage']}/service/${keptnInit['service']}/resource", 
            validResponseCodes: "100:404",
            ignoreSslErrors: true

        echo "Response from upload resource ${file} to ${remoteUri}: " + addResourceResponse.content

    } else {
        echo "File ${fileName} does not exist"
    }
}

/**
 * keptnAddProjectResources(['localfile1': remotelocation1,'localfile2': remotelocation, ...])
 * Allows you to upload one local file to the Keptn's internal repo on Project level
 */
def keptnAddProjectResources(file, remoteUri) {
    def keptnInit = keptnLoadFromInit([:])

    if (fileExists(file: file)) {
        def localFile = readFile(file)
        print "loaded file ${file}"
        //perform base64 encoding
        String localFileBase64Encoded = localFile.bytes.encodeBase64().toString()

        //Update SLO in keptn
        def requestBody = """{
            "resources" : [{"resourceURI": "${remoteUri}","resourceContent": "${localFileBase64Encoded}"}]
        }"""

        def addResourceResponse = httpRequest contentType: 'APPLICATION_JSON', 
            customHeaders: [[maskValue: true, name: 'x-token', value: "${keptnInit['keptn_api_token']}"]], 
            httpMode: 'POST', 
            requestBody: requestBody, 
            responseHandle: 'STRING', 
            url: "${keptnInit['keptn_endpoint']}/v1/project/${keptnInit['project']}/resource", 
            validResponseCodes: "100:404",
            ignoreSslErrors: true

        echo "Response from upload resource ${file} to ${remoteUri}: " + addResourceResponse.content

    } else {
        echo "File ${fileName} does not exist"
    }
}

/**
 * keptnAddStageResources(['localfile1': remotelocation1,'localfile2': remotelocation, ...])
 * Allows you to upload one local file to the Keptn's internal repo on Stage level
 */
def keptnAddStageResources(file, remoteUri) {
    def keptnInit = keptnLoadFromInit([:])

    if (fileExists(file: file)) {
        def localFile = readFile(file)
        print "loaded file ${file}"
        //perform base64 encoding
        String localFileBase64Encoded = localFile.bytes.encodeBase64().toString()

        //Update SLO in keptn
        def requestBody = """{
            "resources" : [{"resourceURI": "${remoteUri}","resourceContent": "${localFileBase64Encoded}"}]
        }"""

        def addResourceResponse = httpRequest contentType: 'APPLICATION_JSON', 
            customHeaders: [[maskValue: true, name: 'x-token', value: "${keptnInit['keptn_api_token']}"]], 
            httpMode: 'POST', 
            requestBody: requestBody, 
            responseHandle: 'STRING', 
            url: "${keptnInit['keptn_endpoint']}/v1/project/${keptnInit['project']}/stage/${keptnInit['stage']}/resource", 
            validResponseCodes: "100:404",
            ignoreSslErrors: true

        echo "Response from upload resource ${file} to ${remoteUri}: " + addResourceResponse.content

    } else {
        echo "File ${fileName} does not exist"
    }
}

/** 
 * Stores the current local time in keptn.input.json
 */
def markEvaluationStartTime() {
    def startTime = java.time.LocalDateTime.now().toString()

    def keptnContextFileJson
    if (fileExists(file: getKeptnInitJsonFilename())) {
        def keptnContextFileContent = readFile getKeptnInitJsonFilename()
        keptnContextFileJson = readJSON text: keptnContextFileContent
        keptnContextFileJson["starttime"] = startTime
    } else {
        keptnContextFileJson = [starttime:startTime]
    }

    writeJSON file: getKeptnInitJsonFilename(), json: keptnContextFileJson

    return startTime
}

/** 
 * reads the starttime from keptn.input.json or ""
 */
def getEvaluationStartTime() {
    if (fileExists(file: getKeptnInitJsonFilename())) {
        def keptnContextFileContent = readFile getKeptnInitJsonFilename()
        def keptnContextFileJson = readJSON text: keptnContextFileContent
        if (keptnContextFileJson.containsKey("starttime")) {
            return keptnContextFileJson["starttime"]
        }
    }
    
    return ""
}

/**
 * sendStartEvaluationEvent(project, stage, service, starttime, endtime, [keptn_endpoint, keptn_api_token])
 * will start an evaluation and stores the keptn context in keptn.context.json
 * if starttime == "" --> it will first look it up in keptn.context.json as it may have been set with markEvaluationStartTime()
 * if starttime == number in seconds -> will calculate the starttime based on starttime = Now()-number in seconds
 * if endtime == number in seconds -> will calculate the time based on endtime = Now()-number in seconds
 * if endtime == "" --> it will default to Now()
 * Here are a couple of usage options 
 * Last 10 minutes: starttime=600, endtime=
 * Timeframe from Now()-11minutes to Now()-1min: starttime=660, endtime=60
 * From starttime untile now: starttime="2020-04-17T11:30:00.000Z", endtime=""
 */
def sendStartEvaluationEvent(Map args) {
    def keptnInit = keptnLoadFromInit(args)
    
    /* String project, String stage, String service, String deploymentURI, String testStrategy */
    String keptn_endpoint = keptnInit['keptn_endpoint']
    String keptn_api_token = keptnInit['keptn_api_token']

    String project = keptnInit['project']
    String stage = keptnInit['stage']
    String service = keptnInit['service']
    
    String starttime = args.containsKey("starttime") ? args.starttime : ""
    String endtime = args.containsKey("endtime") ? args.endtime : ""

    echo "${starttime} - ${endtime}"

    // lets check on timeframe based on the usage scenarios we support
    if (starttime == "") {
        starttime = getEvaluationStartTime()
        echo "#1 - ${starttime} - ${endtime}"
    }
    if (starttime == "") {
        echo "No starttime specified. Either specify exact time or seconds counting back from Now()"
        return false;
    }
    if (starttime?.isInteger()) {
        seconds = starttime.toInteger()
        if (seconds > 0) {
            starttime = java.time.LocalDateTime.now().minusSeconds((int)starttime.toInteger()).toString()
            echo "Setting starttime to ${starttime}"
        } else {
            echo "No negative numbers allowed for starttime!"
            return false;
        }
    }
    if (endtime?.isInteger()) {
        seconds = endtime.toInteger()
        if (seconds > 0) {
            endtime = java.time.LocalDateTime.now().minusSeconds((int)endtime.toInteger()).toString()
            echo "Setting endtime to ${endtime}"
        } else {
            echo "No negative numbers allowed for endtime!"
            return false;
        }
    }
    if (endtime == "") {
        endtime = java.time.LocalDateTime.now().toString()
        echo "Endttime empty. Setting endtime to Now: ${endtime}"
    }

    if ((starttime == "") || (endtime == "")) {
        echo "Startime (${starttime}) and endtime (${endtime}) not correctly passed!"
        return false;
    }

    if ((project == "") || (stage == "") || (service == "")) {
        echo "Method requires project, stage and service to be set. These values cant be empty!"
        return false;
    }

    echo "Sending a Start-Evaluation event to Keptn for ${project}.${stage}.${service} for ${starttime} - ${endtime}"
    
    def requestBody = """{
        |  "contenttype": "application/json",
        |  "data": {
        |    "teststrategy" : "manual",
        |    "project": "${project}",
        |    "service": "${service}",
        |    "stage": "${stage}",
        |    "start": "${starttime}Z",
        |    "end" : "${endtime}Z",
        |    "image" : "${JOB_NAME}",
        |    "tag" : "${BUILD_NUMBER}",
        |    "labels": {
        |      "build" : "${BUILD_NUMBER}",
        |      "jobname" : "${JOB_NAME}",
        |      "joburl" : "${BUILD_URL}"
        |    }
        |  },
        |  "source": "Jenkins",
        |  "specversion": "0.2",
        |  "type": "sh.keptn.event.start-evaluation"
        |}
    """.stripMargin()

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
    writeFile file: getKeptnContextJsonFilename(), text: response.content
    archiveArtifacts artifacts: getKeptnContextJsonFilename()

    println("Status: "+response.status)
    println("Content: "+response.content)      

    def keptnResponseJson = readJSON text: response.content
    def keptnContext = keptnResponseJson['keptnContext']
    
    echo "Retrieved KeptnContext: ${keptnContext}"
    
    return keptnContext
}

/**
 * waitForEvaluationDoneEvent(setBuildResult, [keptn_context, keptn_endpoint, keptn_api_token])
 */
def waitForEvaluationDoneEvent(Map args) {
    def keptnInit = keptnLoadFromInit(args)
    
    Boolean setBuildResult = args.containsKey("setBuildResult") ? args.setBuildResult : false 
    int waitTime = args.containsKey("waitTime") ? args.waitTime : 3 // default is 3 minute wait 
    String keptn_endpoint = keptnInit['keptn_endpoint']
    String keptn_api_token = keptnInit['keptn_api_token']
    String keptn_context = args.containsKey("keptnContext") ? args.keptnContext : ""

    if ((keptn_context == "" || keptn_context == null) && fileExists(file: getKeptnContextJsonFilename())) {
        def keptnContextFileContent = readFile getKeptnContextJsonFilename()
        def keptnContextFileJson = readJSON text: keptnContextFileContent
        keptn_context = keptnContextFileJson['keptnContext']
    }

    if (keptn_context == "" || keptn_context == null) {
        echo "Couldnt find a current keptnContext. Not getting evaluation results"
        if (setBuildResult) {
           currentBuild.result = 'FAILURE' 
        }
        return false;
    }

    echo "Wait for Evaluation Done for keptnContext: ${keptn_context}"

    def evalResponse = ""
    timeout(time: waitTime, unit: 'MINUTES') {
        script {
            waitUntil {
                // Post the Keptn Context to the Keptn api to get the Evaluation-done event
                def response = httpRequest contentType: 'APPLICATION_JSON', 
                    customHeaders: [[maskValue: true, name: 'x-token', value: "${keptn_api_token}"]], 
                    httpMode: 'GET', 
                    responseHandle: 'STRING', 
                    url: "${keptn_endpoint}/v1/event?keptnContext=${keptn_context}&type=sh.keptn.events.evaluation-done", 
                    validResponseCodes: "100:500", 
                    ignoreSslErrors: true

                //The API returns a response code 500 error if the evalution done event does not exisit
                if (response.status == 500 || response.content.contains("No Keptn sh.keptn.events.evaluation-done event found for context") ) {
                    sleep 10
                    return false
                } else {
                    evalResponse = response.content
                    return true
                } 
            }
        }
    }
    
    if (evalResponse == "") {
        echo "Didnt receive any successful keptn evaluation results"
        if (setBuildResult) {
            currentBuild.result = 'FAILURE' 
        }
        return false;
    }

    // write result to file and archive it
    writeFile file: "keptn.evaluationresult.${keptn_context}.json", text: evalResponse
    archiveArtifacts artifacts: "keptn.evaluationresult.${keptn_context}.json"
    println("Archived Keptn Evaluation Done Result details in keptn.evaluationresult.${keptn_context}.json")

    def keptnResponseJson = readJSON text: evalResponse
    def score = keptnResponseJson['data']['evaluationdetails']['score']
    def result = keptnResponseJson['data']['evaluationdetails']['result']
    
    echo "Retrieved Score: ${score}, Result: ${result}"

    // set build result depending on score
    if (setBuildResult) {
        switch(result) {
            case "pass":
                currentBuild.result = 'SUCCESS' 
                break;
            case "warning":
                currentBuild.result = 'UNSTABLE' 
                break;
            default:
                currentBuild.result = 'FAILURE' 
                break;
        }
    }

    return score
}

def sendDeploymentFinishedEvent(Map args) {
    def keptnInit = keptnLoadFromInit(args)

    /* String project, String stage, String service, String deploymentURI, String testStrategy */
    String keptn_endpoint = args.containsKey("keptn_endpoint") ? args.keptn_endpoint : env.KEPTN_ENDPOINT
    String keptn_api_token = args.containsKey("keptn_api_token") ? args.keptn_api_token : env.KEPTN_API_TOKEN

    String project = keptnInit['project']
    String stage = keptnInit['stage']
    String service = keptnInit['service']
    String deploymentURI = args.containsKey("deploymentURI") ? args.deploymentURI : ""
    String testStrategy = args.containsKey("testStrategy") ? args.testStrategy : ""

    echo "Sending a Deployment Finished event to Keptn for ${project}.${stage}.${service} on ${deploymentURI} with testStrategy ${testStrategy}"
    
    def requestBody = """{
        |  "contenttype": "application/json",
        |  "data": {
        |    "deploymentURIPublic": "${deploymentURI}",
        |    "teststrategy" : "${testStrategy}",
        |    "project": "${project}",
        |    "service": "${service}",
        |    "stage": "${stage}",
        |    "image" : "${JOB_NAME}",
        |    "tag" : "${BUILD_NUMBER}",
        |    "labels": {
        |      "build" : "${BUILD_NUMBER}",
        |      "jobname" : "${JOB_NAME}",
        |      "joburl" : "${BUILD_URL}"
        |    }
        |  },
        |  "source": "performance-service",
        |  "specversion": "0.2",
        |  "type": "sh.keptn.events.deployment-finished"
        |}
    """.stripMargin()

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
    writeFile file: getKeptnContextJsonFilename(), text: response.content
    archiveArtifacts artifacts: getKeptnContextJsonFilename()

    println("Status: "+response.status)
    println("Content: "+response.content)      

    def keptnResponseJson = readJSON text: response.content
    def keptnContext = keptnResponseJson['keptnContext']
    
    echo "Retrieved KeptnContext: ${keptnContext}"
    
    return keptnContext
}

return this
