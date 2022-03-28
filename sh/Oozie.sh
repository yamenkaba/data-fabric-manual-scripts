# https://docs.datafabric.hpe.com/62/AdvancedInstallation/InstallOozie.html

# On nodes 3, 4
yum install -y mapr-oozie mapr-oozie-internal

## Restart the YARN services
maprcli node services -name nodemanager -action restart -nodes df1.datamind.lab,df2.datamind.lab,df3.datamind.lab,df4.datamind.lab,df5.datamind.lab,df6.datamind.lab
maprcli node services -name resourcemanager -action restart -nodes df4.datamind.lab,df5.datamind.lab,df6.datamind.lab

## Run server configure.sh -R on all Oozie nodes
/opt/mapr/server/configure.sh -R

## Export the Oozie URL to your environment
## For secure clusters, use the following export command, and specify the oozie_port_number as 11443:
export OOZIE_URL='<https://<Oozie_node>:<oozie_port_number>/oozie>'
export OOZIE_URL='https://df4.datamind.lab:11443/oozie'

## Check the Oozie status with the following command
/opt/mapr/oozie/oozie-<version>/bin/oozie admin -status

## If high availability for the Resource Manager is configured, edit the job.properties file for each workflow and insert the following statement
JobTracker=maprfs:///

## If high availability for the Resource Manager is not configured, provide the address of the node running the active ResourceManager and the port used for ResourceManager client RPCs (port 8032). For each workflow, edit the job.properties file and insert the following statement:
JobTracker=<ResourceManager_address>:8032

## Install extjs for web ui
# https://docs.datafabric.hpe.com/62/Oozie/ManageOozieServicesEnableWebUI.html
wget http://archive.cloudera.com/gplextras/misc/ext-2.2.zip -P /tmp
cp ext-2.2.zip /opt/mapr/oozie/oozie-<version>/libext/

## Restart Oozie:
maprcli node services -name oozie -action restart -nodes <space delimited list of nodes>