# https://docs.datafabric.hpe.com/62/AdvancedInstallation/InstallingAirflow.html

# On nodes 4, 5
yum install -y mapr-airflow mapr-airflow-webserver mapr-airflow-scheduler

## Run server configure.sh -R on all nodes
/opt/mapr/server/configure.sh -R