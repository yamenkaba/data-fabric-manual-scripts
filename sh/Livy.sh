# https://docs.datafabric.hpe.com/62/AdvancedInstallation/Installing_Livy.html

# On nodes 5, 6
yum install -y mapr-livy

## Run server configure.sh -R on all Livy nodes
/opt/mapr/server/configure.sh -R

# Configuer Livy to run spark on yarn
# Edit /opt/mapr/livy/livy-<version>/conf/livy.conf
vim /opt/mapr/livy/livy-<version>/conf/livy.conf