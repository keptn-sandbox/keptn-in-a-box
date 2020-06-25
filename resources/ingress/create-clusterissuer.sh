#!/bin/bash

generateRandomEmail(){
 echo "email-$RANDOM-$RANDOM@dynatrace.ai"
}

if [ $# -eq 1 ]; then
    EMAIL=$1
    echo "Creating ClusterIssuer for $EMAIL"
    # Simplecheck to check if the email address is valid 
    if [[ $EMAIL == *"@"* ]]; then
        echo "It's valid!"
    else 
        echo "Email address is not valid. Email will be generated"
        EMAIL=$(generateRandomEmail)
    fi
else
    echo "Email not passed.  Email will be generated"
    EMAIL=$(generateRandomEmail)
fi
echo "EmailAccount for ClusterIssuer $EMAIL, creating ClusterIssuer"
cat clusterissuer.yaml | sed 's~email.placeholder~'"$EMAIL"'~' > ./gen/issuer/clusterissuer.yaml

kubectl apply -f gen/issuer/clusterissuer.yaml
