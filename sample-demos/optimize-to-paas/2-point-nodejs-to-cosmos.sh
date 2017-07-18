#!/bin/bash

#RUN THIS FROM YOUR DESKTOP CLIENT to change the Azure backend servers
#if this fails it is likely you have not updated the /etc/hosts with the correct IP addresses

echo "SSH into Node Frontend and set variables"
echo "  replace: dansand-mongo-svr1:27017/todo"
echo "  with the new cosmosdb connection"

ssh -i ~/Desktop/msready-demo/aws-linux-vms.pem centos@azure-node-todo bash <<EOF
    sudo su
    sed -i 's|NODE_TODO_MONGO_DBCONNECTION.*|NODE_TODO_MONGO_DBCONNECTION: '\''mongodb://nodejs-todo:VbtkysT46KJx2FcTECQFVCVtOK4EWCTWTM9zwcEA55V3sgF1onpeQrUqPwXTfD1ufwLGrkNTmxLtMA75wyMVmg==@nodejs-todo.documents.azure.com:10255/todo?ssl=true'\''|g' /source/nodejs-todo/ecosystem.config.js
    cd /source/nodejs-todo
    pm2 delete nodejs-todo
    pm2 save
    pm2 start ecosystem.config.js
    pm2 save
EOF