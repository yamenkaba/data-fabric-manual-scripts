# https://docs.datafabric.hpe.com/62/AdvancedInstallation/InstallingHadoop.html

# On node 1
yum -y install mapr-hadoop-core mapr-nodemanager

# On node 2
yum -y install mapr-hadoop-core mapr-nodemanager mapr-timelineserver

# On node 3
yum -y install mapr-hadoop-core mapr-nodemanager mapr-historyserver mapr-timelineserver

# On nodes 4->6
yum -y install mapr-hadoop-core mapr-nodemanager mapr-resourcemanager

## Run server configure.sh -R on all nodes
/opt/mapr/server/configure.sh -R

## Restart Warden on all nodes
systemctl restart mapr-warden.service