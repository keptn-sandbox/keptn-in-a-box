

https://github.com/helm/charts/tree/master/stable/jenkins
https://dev.to/psfeng/setting-up-jenkins-on-microk8s-4b8a
https://akomljen.com/set-up-a-jenkins-ci-cd-pipeline-with-kubernetes/

# SRE https://github.com/keptn/spec/blob/master/sre.md#remediation-action


# Install Jenkins
helm init
helm repo update
helm install stable/jenkins -n jenkins -f values.yaml

# Print jenkins password
kubectl get secret jenkins -ojsonpath={.data.jenkins-admin-password} | base64 --decode

# For deleting Jenkins (and the deleted deployment)
helm del --purge jenkins

# Add the plugins
## Install plugins
https://plugins.jenkins.io/http_request/
https://plugins.jenkins.io/pipeline-utility-steps/
blueocean


# Add the Keptn Library - OK JCAAC


# Global Pipeline Libraries
url= https://github.com/keptn-sandbox/keptn-jenkins-library.git
# Add the Global ENV Variables
#  Global ENV Variables
KEPTN_API_TOKEN
KEPTN_BRIDGE
KEPTN_ENDPOINT


# Add Pipelines

https://github.com/acm-workshops/jenkins-tutorial/blob/master/usecases/uc1_qualitygates/keptnevaluation.Jenkinsfile



https://raw.githubusercontent.com/keptn-sandbox/jenkins-tutorial/master/usecases/uc1_qualitygates/keptnevaluatewithtest.Jenkinsfile


# tag evalservice

# MZ
# Dashboard
http://18-130-14-238.nip.io/easytravel
/:home;/rest/users/random:users;/rest/bookings/recent/3:bookings;/rest/journeys/special-offers:special-offers

/:homepage;/contact:contact;/login:login;/rest/bookings/recent/3:bookings;/rest/journeys/special-offers:special-offers

curl -X GET -H " x-token: " -H "Content-Type: application/json" https://api.keptn.xxxxx.nip.io/v1/event?keptnContext=xxxx--xxx&type=sh.keptn.events.evaluation-done

-H "Content-Type: application/json"

### Feedback
https://github.com/keptn-contrib/dynatrace-service/tree/feature/115_116/support_non_keptn_deployed_service

https://github.com/keptn-sandbox/jenkins-tutorial/blob/master/usecases/uc1_qualitygates/keptn/jmeter/jmeter.conf.yaml



- Keptn Internal server error (500) when waiting for result
  
- How to get the Ingress and not Service/Port? 
    "joburl" : "http://left-umbrellabird-jenkins:8080/job/Keptn%20Performance%20as%20a%20Service/2/"

- Store the SLI/SLO (edit and save results)

- PerformanceAsAService, just with one tag? instead of 3? KeyValues?











