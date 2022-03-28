# https://docs.datafabric.hpe.com/62/Hive/config-remote-postgres-db-hive-metastore.html

# Download the PostgreSQL JDBC driver
wget https://jdbc.postgresql.org/download/postgresql-42.3.3.jar -P /tmp
mv /tmp/<postgresql-jdbc.jar> /usr/share/java/postgresql-jdbc.jar
chmod 644 /usr/share/java/postgresql-jdbc.jar
ln -s /usr/share/java/postgresql-jdbc.jar /opt/mapr/hive/hive-<version>/lib/postgresql-jdbc.jar

# Enter with postgres user and create hivemetastore/db_user/db_user_pass and grant previliges.
sudo -u postgres psql
create database hivemetastore;
create user hiveusr with encrypted password 'Datamind123.';
grant all privileges on database hivemetastore to hiveusr;

# Verify
psql -h localhost -U hiveusr -d hivemetastore

# Configure the Metastore service to communicate with the PostgreSQL database by setting the necessary properties (shown below) in the
# /opt/mapr/hive//hive-<version>/conf/hive-site.xml file. Suppose a PostgreSQL database running on host myhost under the user account hive with the password mypassword,
# set the following configuration properties in the hive-site.xml file
<property>
  <name>javax.jdo.option.ConnectionURL</name>
  <value>jdbc:postgresql://df5.datamind.lab/hivemetastore</value>
</property>
 
<property>
  <name>javax.jdo.option.ConnectionDriverName</name>
  <value>org.postgresql.Driver</value>
</property>
 
<property>
  <name>javax.jdo.option.ConnectionUserName</name>
  <value>hiveusr</value>
</property>
 
<property>
  <name>javax.jdo.option.ConnectionPassword</name>
  <value>Datamind123.</value>
</property>

<property>
  <name>hive.metastore.uris</name>
  <value>thrift://df5.datamind.lab:9083</value>
  <description>IP address (or fully-qualified domain name) and port of the metastore host</description>
</property>

# Initiate metastore database
/opt/mapr/hive/hive-<version>/bin/schematool -dbType postgres -initSchema