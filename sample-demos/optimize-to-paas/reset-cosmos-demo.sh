#!/bin/bash

#RUN THIS FROM YOUR DESKTOP CLIENT to change the Azure backend servers
#this resets the env variables and db back to the local mongodb

echo "SSH into Node Frontend and set variables"
echo "  replace the cosmosdb connection with mongodb://dansand-mongo-svr1:27017/todo"
ssh -i ~/Desktop/msready-demo/aws-linux-vms.pem centos@dansand-az-nodetodo.eastus.cloudapp.azure.com bash <<EOF
    sudo su
    sed -i 's|NODE_TODO_MONGO_DBCONNECTION.*|NODE_TODO_MONGO_DBCONNECTION: '\''mongodb://dansand-mongo-svr1:27017/todo'\''|g' /source/nodejs-todo/ecosystem.config.js
    sed -i 's|NODE_DB_Type.*|NODE_DB_Type: '\''iaas mongo instance'\''|g' /source/nodejs-todo/ecosystem.config.js
    cd /source/nodejs-todo
    pm2 delete nodejs-todo
    pm2 save
    pm2 start ecosystem.config.js
    pm2 save
EOF