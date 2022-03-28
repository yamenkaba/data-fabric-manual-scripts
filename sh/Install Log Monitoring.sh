# https://docs.datafabric.hpe.com/62/AdvancedInstallation/InstallLogging.html

# On nodes 1->4
yum -y install mapr-fluentd mapr-elasticsearch

# On nodes 5, 6
yum -y install mapr-fluentd mapr-elasticsearch mapr-kibana


## For secure HPE Ezmeral Data Fabric clusters, run maprlogin print to verify that you have a user ticket for the HPE Ezmeral Data Fabric user and the root user.
## These user tickets are required for a successful installation.
## If you need to generate a HPE Ezmeral Data Fabric user ticket, run maprlogin password

# On ES, Fluentd
/opt/mapr/server/configure.sh -R -v -ES df1.datamind.lab:9200,df2.datamind.lab:9200,df3.datamind.lab:9200,df4.datamind.lab:9200,df5.datamind.lab:9200,df6.datamind.lab:9200 \
-ESDB /opt/mapr/es_db -EPelasticsearch '-password Datamind123.' -EPfluentd '-password Datamind123.'

# On ES, Fluentd and kibana nodes
/opt/mapr/server/configure.sh -R -v -ES df1.datamind.lab:9200,df2.datamind.lab:9200,df3.datamind.lab:9200,df4.datamind.lab:9200,df5.datamind.lab:9200,df6.datamind.lab:9200 \
-ESDB /opt/mapr/es_db -EPelasticsearch '-password Datamind123.' -EPkibana '-password Datamind123.' -EPfluentd '-password Datamind123.'

## For more steps after installation
https://docs.datafabric.hpe.com/62/AdvancedInstallation/InstallLogging.html