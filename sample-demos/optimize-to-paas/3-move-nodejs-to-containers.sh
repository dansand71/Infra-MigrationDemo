#!/bin/bash

#Containerize the nodejs app & push to Azure CR
ssh -i ~/Desktop/msready-demo/aws-linux-vms.pem centos@azure-node-todo bash <<EOF
    sudo su
    cd /source/nodejs-todo
    docker build -t ossdemo/nodejs-todo .
    
    #docker tag ossdemo/nodejs-todo VALUEOF-REGISTRY-SERVER-NAME/ossdemo/nodejs-todo
    docker tag ossdemo/nodejs-todo dansandossdemoinfra.azurecr.io/ossdemo/nodejs-todo
    
    #docker login VALUEOF-REGISTRY-SERVER-NAME -u VALUEOF-REGISTRY-USER-NAME -p VALUEOF-REGISTRY-PASSWORD
    docker login dansandossdemoinfra.azurecr.io -u dansandossdemoinfra -p /fQ+paow/+udNO/d6Lnf=CP4InxZrcJO
    
    #docker push VALUEOF-REGISTRY-SERVER-NAME/ossdemo/nodejs-todo
    docker push dansandossdemoinfra.azurecr.io/ossdemo/nodejs-todo

    echo ".updating the web app with the container details"
    ## Config the Docker Container
    ~/bin/az webapp config container set -n dansandinfra-nodejs-todo -g ossdemo-infra-migrate \
        --docker-registry-server-password /fQ+paow/+udNO/d6Lnf=CP4InxZrcJO \
        --docker-registry-server-user dansandossdemoinfra \
        --docker-registry-server-url dansandossdemoinfra.azurecr.io \
        --docker-custom-image-name dansandossdemoinfra.azurecr.io/ossdemo/nodejs-todo \
        --NODE_TODO_MONGO_DBCONNECTION mongodb://nodejs-todo:VbtkysT46KJx2FcTECQFVCVtOK4EWCTWTM9zwcEA55V3sgF1onpeQrUqPwXTfD1ufwLGrkNTmxLtMA75wyMVmg==@nodejs-todo.documents.azure.com:10255/todo?ssl=true
EOF