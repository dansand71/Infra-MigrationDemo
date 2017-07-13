#!bin/bash
#Containerize the nodejs app & push to Azure CR
#export the mongo database & import it into cosmos



echo ".updating the web app with the container details"
## Config the Docker Container
~/bin/az webapp config container set -n VALUEOF-UNIQUE-SERVER-PREFIX-nodejs-todo -g ossdemo-infra-migrate \
    --docker-registry-server-password VALUEOF-REGISTRY-PASSWORD \
    --docker-registry-server-user VALUEOF-REGISTRY-USER-NAME \
    --docker-registry-server-url VALUEOF-REGISTRY-SERVER-NAME \
    --docker-custom-image-name VALUEOF-REGISTRY-SERVER-NAME/ossdemo/nodejs-todo