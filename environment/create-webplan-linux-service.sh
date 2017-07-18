## Create the plan - only available in West US for now - Already done via template
echo ".creating appservice web plan"
~/bin/az appservice plan create -g ossdemo-infra-migrate -n webtier-plan --is-linux --number-of-workers 1 --sku S1 -l westus

echo ".creating appservice web app"
## Create the appservice - Already done via template
~/bin/az webapp create -g ossdemo-infra-migrate -p webtier-plan -n dansandinfra-nodejs-todo

