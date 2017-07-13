#Read in the demo default template values and crate a new registry with that name and a new storage account
#Add ACR if it isnt there
~/bin/az component update --add acr

source /source/appdev-demo-EnvironmentTemplateValues
echo ""
echo "Creating AZ Registry ${DEMO_UNIQUE_SERVER_PREFIX}arcinfra.  Current Template Values:"
echo "      DEMO_UNIQUE_SERVER_PREFIX="$DEMO_UNIQUE_SERVER_PREFIX   
echo "Running command: az acr create -n ${DEMO_UNIQUE_SERVER_PREFIX}arcinfra -g ossdemo-infra-migrate -l eastus --admin-enabled true --sku Basic"
az acr create -n ${DEMO_UNIQUE_SERVER_PREFIX}arcinfra -g ossdemo-infra-migrate -l eastus --admin-enabled true --sku Basic

