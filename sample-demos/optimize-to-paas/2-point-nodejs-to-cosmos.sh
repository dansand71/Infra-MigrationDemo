#!/bin/bash

#RUN THIS FROM YOUR DESKTOP CLIENT to change the Azure backend servers
#if this fails it is likely you have not updated the /etc/hosts with the correct IP addresses

echo "SSH into Node Frontend and set variables"
echo "  replace: dansand-mongo-svr1:27017/todo"
echo "  with the new cosmosdb connection"

ssh -i ~/Desktop/msready-demo/aws-linux-vms.pem centos@dansand-az-nodetodo.eastus.cloudapp.azure.com bash <<EOF
    sudo su

    #CHANGE the db connection string
    sed -i 's|NODE_TODO_MONGO_DBCONNECTION.*|NODE_TODO_MONGO_DBCONNECTION: '\''mongodb://nodejs-todo:VbtkysT46KJx2FcTECQFVCVtOK4EWCTWTM9zwcEA55V3sgF1onpeQrUqPwXTfD1ufwLGrkNTmxLtMA75wyMVmg==@nodejs-todo.documents.azure.com:10255/todo?ssl=true'\''|g' /source/nodejs-todo/ecosystem.config.js
    sed -i 's|NODE_DB_Type.*|NODE_DB_Type: '\''cosmosdb mongo instance'\'',|g' /source/nodejs-todo/ecosystem.config.js
    
    #RESTART PM2 and bring up the NODE app
    cd /source/nodejs-todo
    pm2 delete nodejs-todo
    pm2 save
    pm2 start ecosystem.config.js
    pm2 save
EOF