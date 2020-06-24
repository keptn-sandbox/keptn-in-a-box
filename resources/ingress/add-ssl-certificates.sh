#!/bin/bash 
# Function to uncomment the cluster-issuer and secretname

echo "reading created ingresses and uncommenting the certmanager and secret"
for file in gen/*.yaml; do
   yaml=${file##*/}
   echo $file $yaml
   cat $file | sed -e 's~#cert-manager.io~'cert-manager.io'~' -e 's~#secretName~'secretName'~' > gen/ssl/$yaml
done

echo "Create a certificate for each ingress in the gen/ssl directory"
kubectl apply -f gen/ssl/

