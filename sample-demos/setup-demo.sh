#!/bin/bash
RESET="\e[0m"
BOLD="\e[4m"
INPUT="\e[7m"
YELLOW="\033[38;5;11m"
RED="\033[0;31m"
echo -e "${BOLD}Welcome to the OSS Demo for Infrastructure Migration.  This demo will configure:${RESET}"
echo "    - Resource group - ossdemo-infra-migrate"
echo ""
echo "    - Create a private Azure Container Registry - used across all demos"
echo "    - Create an application insights instance - used across all demos"
echo "    - Optionally create an OMS instance - used across all demos"
echo ""
echo ""
echo "Installation & Configuration will require SU rights."
echo ""
source /source/appdev-demo-EnvironmentTemplateValues
echo ""
echo -e "${BOLD}Current Template Values:${RESET}"
echo "      DEMO_UNIQUE_SERVER_PREFIX="$DEMO_UNIQUE_SERVER_PREFIX
echo "      DEMO_STORAGE_ACCOUNT="$DEMO_STORAGE_ACCOUNT
echo "      DEMO_ADMIN_USER="$DEMO_ADMIN_USER
echo "      DEMO_REGISTRY_SERVER-NAME="$DEMO_REGISTRY_SERVER_NAME
echo "      DEMO_REGISTRY_USER_NAME="$DEMO_REGISTRY_USER_NAME
echo "      DEMO_REGISTRY_PASSWORD="$DEMO_REGISTRY_PASSWORD
echo "      DEMO_OMS_WORKSPACE="$DEMO_OMS_WORKSPACE
echo "      DEMO_OMS_PRIMARYKEY="$DEMO_OMS_PRIMARYKEY
echo "      DEMO_APPLICATION_INSIGHTS_NODEJSTODO_KEY="$DEMO_APPLICATION_INSIGHTS_NODEJSTODO_KEY
echo ""
#ensure we are in the root of the demo directory
cd /source/Infra-MigrationDemo
if [[ -z $DEMO_UNIQUE_SERVER_PREFIX  ]]; then
   echo "   Server PREFIX is null.  Please correct and re-run this script.."
   exit
fi
echo "The remainder of this script requires the template values be filled in the /source/appdev-demo-EnvironmentTemplateValues file."
read -p "Press any key to continue or CTRL-C to exit... " startscript

echo "Logging in to Azure"
#Checking to see if we are logged into Azure
echo "    Checking if we are logged in to Azure."
#We need to redirect the output streams to stdout
azstatus=`~/bin/az group list 2>&1` 
if [[ $azstatus =~ "Please run 'az login' to setup account." ]]; then
   echo "   We need to login to azure.."
   az login
else
   echo "    Logged in."
fi
echo -e "${BOLD}Confirm Azure Subscription${RESET}"
read -p "Change default subscription? [y/N]:" changesubscription
if [[ ${changesubscription,,} =~ "y" ]];then
    read -p "      New Subscription Name:" newsubscription
    ~/bin/az account set --subscription "$newsubscription"
else
    echo "    Using default existing subscription."
fi

cd /source

#Set Scripts as executable & ensure everything is writeable
echo ".setting scripts as executables"
find /source/Infra-MigrationDemo  -type f -name "*.sh" -exec sudo chmod +x {} \;
sudo chmod 777 -R /source

#RESET DEMO VALUES
echo -e "${BOLD}Configuring demo scripts with defaults.${RESET}"
cd /source/Infra-MigrationDemo
/source/Infra-MigrationDemo/environment/reset-demo-template-values.sh

#DOWNLOAD SOURCE FILES
#/source/Infra-MigrationDemo/environment/download-source-projects.sh

echo "---------------------------------------------"
echo -e "${INPUT}Resource Group Creation${RESET}"
read -p "Apply JSON Templates for and network rules and create NSG and Subnets? [Y/n]:"  continuescript
if [[ $continuescript != "n" ]];then
    #BUILD RESOURCE GROUPS
    
    #APPLY JSON TEMPLATES
    echo ".create ossdemo-appdev-iaas in case it doesnt exist."
    ~/bin/az group create --name ossdemo-infra-migrate --location eastus
    echo -e ".apply ./environment/ossdemo-appdev-iaas.json template."
    ~/bin/az group deployment create --resource-group ossdemo-infra-migrate --name InitialDeployment \
        --template-file /source/Infra-MigrationDemo/environment/ossdemo-infra-migrate.json
    
  echo ".configuring iaas docker hosts with the new docker engine adn OMS agent"
  echo "----------------------------------------------"
  # we need to make sure we run the ansible playbook from this directory to pick up the cfg file
  cd /source/Infra-MigrationDemo/environment/iaas/ 
  /source/Infra-MigrationDemo/environment/iaas/deploy-docker-engine.sh
  

  echo ".calling paas server creation"
  /source/Infra-MigrationDemo/environment/paas/create-webplan-linux-service.sh

fi

#do we have the latest verion of .net?
echo ".Installing libunwind libicu"
sudo yum install -qq libunwind libicu -y
echo ".Set the dotnet path variables"
echo "export PATH=$PATH:/usr/local/bin" >> ~/.bashrc

#ensure .net is setup correctly
echo ".installing gcc libffi-devel python-devel openssl-devel"
sudo yum install -y -q gcc libffi-devel python-devel openssl-devel
echo ".installing npm"
sudo yum install -q -y npm
echo ".installing bower"
sudo npm install bower -g -silent
echo ".installing gulp"
sudo npm install gulp -g -silent
echo ".installing python 35 and pip"
sudo yum install -y -q python35u python35u-pip 

#Install Rimraf for Node Apps
echo ".Installing rimfraf, webpack, node-saas"
sudo npm install rimraf -g -silent
sudo npm install webpack -g -silent
sudo npm install node-sass -g -silent

echo "${BOLD}Demo environment setup complete.  Please review demos found under /source/Infra-MigrationDemo for Migration.${RESET}"