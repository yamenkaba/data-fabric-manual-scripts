# https://docs.datafabric.hpe.com/62/AdvancedInstallation/InstallingHive.html

# On nodes 1, 2
yum install -y mapr-hive mapr-hivewebhcat

# On nodes 3, 4
yum install -y mapr-hive mapr-hivemetastore

# On nodes 5, 6
yum install -y mapr-hive mapr-hiveserver2

## Configure the database for Hive Metastore
https://docs.datafabric.hpe.com/62/Hive/Config-HiveMetastore.html

## Run server configure.sh -R on all nodes
/opt/mapr/server/configure.sh -R

## What is next
https://docs.datafabric.hpe.com/62/Hive/HiveUserImpersonation.html