node {
    properties([
        parameters([
         string(defaultValue: 'easytravel-public-ip.nip.io', description: 'Magic Domain of the EasyTravel Application you want to run a test against, example 10.12.34.123.nip.io . The REST endpoint and EasyTravel Classic application will be accessed via subdomains e.g. http://rest.10.12.34.123.nip.io ', name: 'DeploymentURI', trim: false),
        ]),
        pipelineTriggers([cron('H(0-1) * * * *')])
    ])

    stage('Triggering a scheduled job') {

       def now = new Date()
       println(now.format("yyMMdd.HHmm", TimeZone.getTimeZone('UTC')))

       def t = Integer.parseInt(now.format("HH", TimeZone.getTimeZone('UTC')))

       println("And the number is: " + t.toString())

       //  0  1  2  3  4  5 
       //  6  7  8  9 10 11 
       // 12  13 14 15 16 17 
       // 18  19 20 21 22 23
       def problemPattern = "Zero"

       if ( t == 0 ||  t == 6 ||  t == 12 ||  t == 18 ){
          problemPattern = "Zero"
       } else if( t == 1 ||  t == 7 ||  t == 13 ||  t == 19 ){
          problemPattern = "CPULoadJourneyService"
       } else if( t == 2 ||  t == 8 ||  t == 14 ||  t == 20 ){
           problemPattern = "DBSpammingAuthWithAppDeployment"
       } else if( t == 3 ||  t == 9 ||  t == 15 ||  t == 21 ){
           problemPattern = "LoginProblems"
       } else if( t == 4 ||  t == 10 ||  t == 16 ||  t == 22 ){
           problemPattern = "JourneyUpdateSlow"
       } else if( t == 5 ||  t == 11 ||  t == 17 ||  t == 23 ){
           problemPattern = "CreditCardCheckError500"
       } else {
          problemPattern = "Zero"
       }

       println("And the problemPattern is:" + problemPattern)
       println("triggering continuous pipeline for :" + params.DeploymentURI )

       build(
             job: 'easytravel-continuous-deployment',
             parameters: [
               [ $class: 'StringParameterValue', name: 'EasyTravelDeployment',value: "${problemPattern}" ],
               [ $class: 'StringParameterValue', name: 'Project',value: "easytravel" ],
               [ $class: 'StringParameterValue', name: 'Stage',value: "staging" ],
               [ $class: 'StringParameterValue', name: 'Service',value: "classic-eval" ],
               [ $class: 'StringParameterValue', name: 'TestStrategy',value: "fullbooking_5_100" ],
               [ $class: 'StringParameterValue', name: 'DeploymentURI',value: "${params.DeploymentURI}" ]
             ],
            )
    }
}

