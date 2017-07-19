#!/bin/bash

#RUN THIS FROM YOUR DESKTOP CLIENT to change the Azure backend servers
#this resets the env variables and db back to the local mongodb

echo "SSH into Node Frontend and reset PM2"
echo "  PM2 can fail to start if the MONGO DB Server came up after the NODE Server.  Lets just poke it to see if it is ok..."
ssh -i ~/Desktop/msready-demo/aws-linux-vms.pem centos@dansand-az-nodetodo.eastus.cloudapp.azure.com bash <<EOF
    sudo su
    cd /source/nodejs-todo
    pm2 delete nodejs-todo
    pm2 save
    pm2 start ecosystem.config.js
    pm2 save
    pm2 list
EOF