#!bin/bash

#Create machines with Azure + Rovelo OR AWS API
#NODE Front End - Centos 7
#Install latest NODE - https://nodejs.org/en/download/package-manager/#enterprise-linux-and-fedora
curl --silent --location https://rpm.nodesource.com/setup_6.x | bash -
sudo yum -y install nodejs
mkdir /source
cd /source
sudo chmod 777 -R .
git clone -b AWSMigrationDemo https://github.com/dansand71/nodejs-todo.git
cd nodejs-todo
npm install
#SET ENV Variables
#echo 'export NODE_TODO_MONGO_DBCONNECTION="mongodb://REPLACE-MONGODB-SERVERNAME:27017/todo"' >> $HOME/.bashrc
echo 'export NODE_TODO_MONGO_DBCONNECTION="mongodb://dansand-mongo-svr1:27017/todo"' >> $HOME/.bashrc
#reload the bash profile
. ~/.bash_profile

#Setup HOSTS - for node front end to find the mongo backend
sudo echo "172.31.2.8  dansand-mongo-svr1" >> /etc/hosts
#setup network rules so the front end can see the backend

#Setup NODE to start on server reboot with PM2 as root
sudo npm install pm2 -g
sudo su
pm2 start ecosystem.config.js
pm2 save
env PATH=$PATH:/usr/bin /usr/lib/node_modules/pm2/bin/pm2 startup centos -u root --hp /root






#MONGODB Back End - Ubutnu 14.04 - 