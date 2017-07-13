#!bin/bash

#Create machines with Azure + Rovelo OR AWS API
#NODE Front End - Ubuntu 14 
echo " Install Mongodb from: https://www.digitalocean.com/community/tutorials/how-to-install-and-secure-mongodb-on-ubuntu-16-04"
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6
echo "deb [ arch=amd64,arm64 ] http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.4.list
sudo apt-get update -y
sudo apt-get install mongodb-org -y
sudo systemctl start mongod
sudo systemctl status mongod
sudo service mongod enable
echo "setup mongodb for remote connections.  Edit bindip to be 0.0.0.0 for remote connections 127.0.0.1 for local only"
sudo vi /etc/mongod.conf
sudo service mongod restart