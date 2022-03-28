# https://docs.datafabric.hpe.com/62/AdvancedInstallation/InstallingHttpFS.html

# On nodes 1->3
yum install -y mapr-httpfs

## Run server configure.sh -R on all HttpFS nodes
/opt/mapr/server/configure.sh -R