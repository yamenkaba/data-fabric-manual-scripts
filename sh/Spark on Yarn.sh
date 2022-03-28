# https://docs.datafabric.hpe.com/62/AdvancedInstallation/InstallSparkonYARN.html

## Verify that JDK 11 or later is installed on the node where you want to install Spark.

## Create the /apps/spark directory on the cluster filesystem, and set the correct permissions on the directory
hadoop fs -mkdir /apps/spark
hadoop fs -chmod 777 /apps/spark

# On node 1->5
yum install -y mapr-spark

# On node 6
yum install -y mapr-spark mapr-spark-historyserver mapr-spark-thriftserver

## If you want to use a Streaming Producer, add the spark-streaming-kafka-producer_2.12.jar from the data-fabric Maven repository
## to the Spark classpath (/opt/mapr/spark/spark-<versions>/jars/).
## For repository-specific information, see Maven Artifacts for the HPE Ezmeral Data Fabric
https://docs.datafabric.hpe.com/62/DevelopmentGuide/MavenArtifacts.html

## After installing Spark on YARN but before running your Spark jobs, follow the steps outlined at Configuring Spark on YARN
https://docs.datafabric.hpe.com/62/Spark/ConfigureSparkOnYarn.html#concept_jwp_3nk_w5

## Configure Spark JAR Location
# Create a zip archive containing all the JARs from the SPARK_HOME/jars directory
cd /opt/mapr/spark/spark-<version>/jars/
zip /opt/mapr/spark/spark-<version>/spark-jars.zip ./*

# Copy the zip file from the local filesystem to a world-readable location on filesystem.
hadoop fs -put /opt/mapr/spark/spark-<version>/spark-jars.zip /user/mapr/

# Set the spark.yarn.archive property in the spark-defaults.conf file to point to the world-readable location where you added the zip file.
# Apply this setting on the node where you will be submitting your Spark jobs.
spark.yarn.archive maprfs:///user/mapr/spark-jars.zip

# On all nodes
/opt/mapr/server/configure.sh -R

## Restart Warden on all nodes
systemctl restart mapr-warden.service