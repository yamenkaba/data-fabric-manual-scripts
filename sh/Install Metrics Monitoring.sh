# https://docs.datafabric.hpe.com/62/AdvancedInstallation/InstallMetrics.html

# On node 1
yum -y install mapr-collectd

# On nodes 2, 3
yum -y install mapr-collectd mapr-grafana

# On nodes 4->6
yum -y install mapr-collectd mapr-opentsdb

# On Grafana nodes
/opt/mapr/server/configure.sh -R -OT df4.datamind.lab:4040,df5.datamind.lab:4040,df6.datamind.lab:4040 -EPgrafana '-password Datamind123.'

# On the other nodes
/opt/mapr/server/configure.sh -R -OT df4.datamind.lab:4040,df5.datamind.lab:4040,df6.datamind.lab:4040

## To start collecting metrics for the NodeManager and ResourceManager services, restart these services on each node where they are installed
maprcli node services -name nodemanager -nodes <space separated list of hostname/IPaddresses> -action restart
maprcli node services -name resourcemanager -nodes <space separated list of hostname/IPaddresses> -action restart 

## For more detailes
https://docs.datafabric.hpe.com/62/AdvancedInstallation/InstallMetrics.html