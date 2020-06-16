

https://github.com/helm/charts/tree/master/stable/jenkins

https://dev.to/psfeng/setting-up-jenkins-on-microk8s-4b8a

https://akomljen.com/set-up-a-jenkins-ci-cd-pipeline-with-kubernetes/


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


> In here
# Add the Keptn Library

but as GIT and not Legacy



## https://github.com/keptn-sandbox/keptn-jenkins-library

## add the variables als ENV variables
KEPTN_ENDPOINT=https://api.keptn.$(kubectl get cm keptn-domain -n keptn -ojsonpath={.data.app_domain})
KEPTN_API_TOKEN=$(kubectl get secret keptn-api-token -n keptn -ojsonpath={.data.keptn-api-token} | base64 --decode)

KEPTN_ENDPOINT=https://api.keptn.domain.placeholder
KEPTN_BRIDGE=https://bridge.keptn.domain.placeholder
KEPTN_API_TOKEN=xxxxx

Once you have everything configured use it in your Jenkins Pipeline like this

@library('keptn-library')
import sh.keptn.Keptn
def keptn = new sh.keptn.Keptn()

.......?? now what?

https://github.com/keptn-sandbox/jenkins-tutorial

# Copy pipeline

https://raw.githubusercontent.com/keptn-sandbox/jenkins-tutorial/master/usecases/uc1_qualitygates/keptnevaluatewithtest.Jenkinsfile

Git

https://github.com/keptn-sandbox/keptn-jenkins-library

tag evalservice


# http://18-130-213-16.nip.io/easytravel/rest/journeys/recommendation/  -> EasytravelService

http://18-130-213-16.nip.io
/easytravel/rest/journeys/recommendation/:recomendation;/easytravel/rest/config/nodejsurl:nodeUrl;/easytravel/rest/config/blogurl:blogUrl;/easytravel/rest/bookings/recent/5:recentBookings

/easytravel/rest/config/nodejsurl
/easytravel/rest/config/blogurl
/easytravel/rest/bookings/recent/5

/:homepage;/echo:echo;/version:version;/invoke?url=www.keptn.sh:invoke


curl -X GET -H " x-token: J07C4MQg5G8+C1KmJrwAMA==" -H "Content-Type: application/json" https://api.keptn.3-10-178-206.nip.io/v1/event?keptnContext=01c2b624-105b-4537-90a4-d0ca2ffa9b48&type=sh.keptn.events.evaluation-done

J07C4MQg5G8+C1KmJrwAMA==

-H "Content-Type: application/json"

### Feedback
https://github.com/keptn-contrib/dynatrace-service/tree/feature/115_116/support_non_keptn_deployed_service

https://github.com/keptn-sandbox/jenkins-tutorial/blob/master/usecases/uc1_qualitygates/keptn/jmeter/jmeter.conf.yaml



- Keptn Internal server error (500) when waiting for result
  
- How to get the Ingress and not Service/Port? 
    "joburl" : "http://left-umbrellabird-jenkins:8080/job/Keptn%20Performance%20as%20a%20Service/2/"

- Store the SLI/SLO (edit and save results)

- PerformanceAsAService, just with one tag? instead of 3? KeyValues?











