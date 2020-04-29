> **DISCLAIMER**: This project was developed for educational purposes only and is not complete, nor supported. It's publishment is only intended for helping others automate environments for delivering workshops with Keptn & Dynatrace. Even though the exposed endpoints of this cluster have valid SSL certificates generated with Cert-Manager and Let's Encrypt, does not mean the Box is secure.    

> ## ***🥼⚗ Spend more time innovating and less time configuring***

# Keptn-in-a-Box (with Dynatrace Software Intelligence empowered) 🎁

Keptn-In-A-Box is part of the automation for delivering Autonomous Cloud Workshops with Dynatrace. This is not a tutorial but more an explanation of what the shell file set up for you on a plain Ubuntu image. 

A simple Bash script will set-up a fully functional Single Node Kubernetes Cluster with Dynatrace installed and Kubernetes Cluster, Cloud Applications and Events monitoring enabled. This script is used as [userdata](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/user-data.html) when spinning up elastic compute images (ec2) in amazon web services, but it can run also manually in a Linux machine or VM with snap installed. The tested distro is  *Ubuntu Server 18.04 LTS & 20.04 LTS*
For spinning up instances automatically with AWS completely configured and set up, and also automating the creation and management of Dynatrace environments, take a look at this project- [Dynatrace - Rest Tenant Automation](https://github.com/sergiohinojosa/Dynatrace-REST-Tenant-Automation) 


![#](doc/ac-concepts-keptninabox.png)

## 🥜The Bash File - Features in a Nutshell
- Update the ubuntu repository
- Installation of Docker (for building own Docker images)
- Installation of Microkubernetes (v1.15)
- Allow the Kube-API to run priviledged pods (necessary for deploying the FullStack Agent via Operator)
- Update IPTABLES: allowing traffic for pods internal and external
- Create a user (dynatrace in this case) with it's own Home directory and SSH access for doing the Hands-On workshop
- Set up of useful BASH Aliases for working with the command line
- Enable autocompletion of Kubectl
- Installation of Dynatrace ActiveGate and configuration of [Cluster](https://www.dynatrace.com/support/help/technology-support/cloud-platforms/kubernetes/monitoring/connect-kubernetes-clusters-to-dynatrace/) and [Workload monitoring](https://www.dynatrace.com/support/help/technology-support/cloud-platforms/kubernetes/monitoring/monitor-workloads-kubernetes/)
- Installation of Istio 1.5.1 
- Installation of Helm Client
- Enabling own Docker Registry for the Cluster
- Convert the public IP in a (magic) domain ([nip.io](https://nip.io/)) for being able to expose all the needed services with subdomains.
- Routing of traffic to Istio-Ingressgateway via a Kubernetes NGINX Ingress using standard HTTP(S) ports 80 and 443. This way we dont need a public IP from the Cloud Provider
- Installation of Keptn 
- Expose the Keptn-Bridge Service
- Installation of Dynatrace OneAgent via Keptn
- Deployment of the Unleash-Server
- Onboard of the Sockshop-Carts Sample project
- Deployment of a cartsloadgenerator PoD
- Deployment of a Autonomous Cloud teaser home page with links to the pipeline, bridge keptn-api. 
- Creation of valid SSL certificates with Certmanager and HTTPs Let's encrypt.
- Create a user account and copy the standard user (ubuntu on this case) with his own home directory (a replica) and allowing SSH connections with text password. 

### 💻The Keptn-in-a-Box Bash Installation

The bash file is scripted in a modular fashion allowing you with  control flags to enable or disable the modules that you want to install in your box. This allows you to have a very slim cluster running keptn with the bare minimal resources or to have a full blown cluster with pretty much all the desired features and frameworks for your CI/CD pipelines and performance testings.


- [keptn-in-a-box.sh](keptn-in-a-box.sh)
- [functions.sh](functions.sh)

## Prerequisites

- [Ubuntu](https://ubuntu.com/#download) with internet connection (tested on 18.04 LTS and 20.04 LTS)

  ### (optional)

- [A Dynatrace Tenant](https://www.dynatrace.com/trial/) 
- AWS Account [Here you can get a free account](https://aws.amazon.com/free/)
- You will get the most ouf of it by having a public ip

### Repository Structure
```
─ doc                       doc folder.
─ keptn-in-a-box.sh         the Bash executable where to define variables
─ functions.sh        		The definiton of functions and modules 
─ resources                 
  ├── cartsloadgenerator    Sources of the load container of the carts app 
  ├── demo                  Scripts for Onboarding the Carts app  
  ├── dynatrace             Scripts for integrating with Dynatrace
  ├── expose-bridge         YAML files for exposing the bridge
  ├── homepage              Sources of the homepage for displaying the Autonomous Cloud teaser  
  ├── istio                 YAML files for mapping istio ingressgw to the nginx ingress
  └── k8-services           YAML files for exposing the k8 services
```

## How to get started
### Run it in an available machine  (manually)
- Get your Ubuntu image 
	
	- For installing all features I recommend using a size t2.2xlarge which has 8 core and 32 Gig of RAM. 
	
- Add the Dynatrace information to the variables:

	- TENANT="https://mytenant.live.dynatrace.com"
	- PAASTOKEN=myDynatracePaaSToken
	- APITOKEN=myDynatraceApiToken

     > For Tenant add it with protocol like:
     >  *https://{your-domain}/e/{your-environment-id}* 
     > for managed or 
     > https://{your-environment-id}.live.dynatrace.com 
     > for SaaS

- Run the script as root or sudo 

  ```bash
  ./keptn-in-a-box.sh
  ```

  > The script is optimized to be run as root without an interactive shell since it is used as userdata passed on creation of the elastic cloud machine


### Spin your preconfigured Keptn-in-a-box machines  (manually in aws)
- Log in to AWS
- Click on "Launch instance"
- Select "Ubuntu Server 18.04 LTS (HVM)"
- Choose Instance Type "t2.2xlarge"
- Select "Next - configure instance details"
- In Configure Instance details - Advanced options copy the keptn-in-a-box.sh file. (as string or drop it, doesn't matter)
- Review it and launch your instance.

### Spin your preconfigured Keptn-in-a-box machines  (automated)

- Description to be added. Please see the [RTA project](https://github.com/sergiohinojosa/Dynatrace-REST-Tenant-Automation) for reference



## Troubleshooting and inspecting the installation
If you spin instances automatically via [RTA](https://github.com/sergiohinojosa/Dynatrace-REST-Tenant-Automation), AWS with UserData or manually, the bash script will write stdout and stderr to a log file. to Inspect do 

```bash
less +F /tmp/install.log
```


## Contributing

If you have any ideas for immprovements or want to contribute that's great. Please just keep in mind the file is used as UserData and AWS has a limitation of 16384 bytes. Please do:
```bash
ls -las keptn-in-a-box.sh 
```
and check that the size is not bigger than 16200 so you leave a buffer (184 bytes) for the initialization of the TENANT, PAASTOKEN and APITOKEN variables.


