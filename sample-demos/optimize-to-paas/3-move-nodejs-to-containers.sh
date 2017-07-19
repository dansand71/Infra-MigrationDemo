#!/bin/bash

#Containerize the nodejs app & push to Azure CR
ssh -i ~/Desktop/msready-demo/aws-linux-vms.pem centos@dansand-az-nodetodo.eastus.cloudapp.azure.com bash <<EOF
    sudo su
    cd /source/nodejs-todo
    
    #BUILD the new container
    docker build -t ossdemo/nodejs-todo .
    
    #TAG the Image
    docker tag ossdemo/nodejs-todo dansandossdemoinfra.azurecr.io/ossdemo/nodejs-todo
    
    #LOGIN to the Azure Container Registry
    docker login dansandossdemoinfra.azurecr.io -u dansandossdemoinfra -p /fQ+paow/+udNO/d6Lnf=CP4InxZrcJO
    
    #PUSH the new image up
    docker push dansandossdemoinfra.azurecr.io/ossdemo/nodejs-todo

    
EOF
## Config the Docker Container
echo ""
echo ".updating the web app with the container details"
echo ".setting the docker registry settings on the webapp"
    ~/bin/az webapp config container set -n dansandinfra-nodejs-todo -g ossdemo-infra-migrate \
        --docker-registry-server-password /fQ+paow/+udNO/d6Lnf=CP4InxZrcJO \
        --docker-registry-server-user dansandossdemoinfra \
        --docker-registry-server-url dansandossdemoinfra.azurecr.io \
        --docker-custom-image-name dansandossdemoinfra.azurecr.io/ossdemo/nodejs-todo 

echo ".setting the MONGODB Connection for the container..."    
## Config the Mongo DB Connection
    ~/bin/az webapp config appsettings set -n dansandinfra-nodejs-todo -g ossdemo-infra-migrate \
        --settings NODE_TODO_MONGO_DBCONNECTION="mongodb://nodejs-todo:VbtkysT46KJx2FcTECQFVCVtOK4EWCTWTM9zwcEA55V3sgF1onpeQrUqPwXTfD1ufwLGrkNTmxLtMA75wyMVmg==@nodejs-todo.documents.azure.com:10255/todo?ssl=true"