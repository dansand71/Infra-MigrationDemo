# Infra-MigrationDemo
OSS on Azure Demos framework - Infrastructure OSS Migration

This project builds from the https://github.com/dansand71/OSSonAzure environment setup.  This demo shows:
- Deployment of AWS instances for a simple nodejs todo application
- Deployment of Hyper-V nexted virtualization (DV3) for emulating a private DC migration
- Assesment of the infrastructure with Stratozone
- Migration of the application with CloudEndure & Zerto
- and many more to come....


To get started with these demo's:
1. ensure you have a Azure and optionally AWS subscriptions
2. clone this project from git
3. mark the scripts as executable
4. run the 1-create-settings-file.sh environment template file creation script
5. after editing the template file with your values run the 2-setup-demo.sh script

## SCRIPT to Install
```
cd /source
git clone https://github.com/dansand71/Infra-MigrationDemo
sudo chmod +x /source/AppDev-ContainerDemo/1-create-settings-file.sh
/source/AppDev-ContainerDemo/1-create-settings-file.sh
```

