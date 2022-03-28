# Enter with postgres user and create ooziedatastore/db_user/db_user_pass and grant previliges.
sudo -u postgres psql
create database ooziedatastore;
create user oozieusr with encrypted password 'Datamind123.';
grant all privileges on database ooziedatastore to oozieusr;

# Verify
psql -h localhost -U oozieusr -d ooziedatastore

# Export Oozie database
/opt/mapr/oozie/oozie-<version>/bin/oozie-setup.sh export /tmp/oozie_db.zip

# Stop Oozie
maprcli node services -name oozie -action stop -nodes <node-list>

# Configure Oozie to use PostgreSQL, edit the 
# /opt/mapr/oozie/oozie-<version>/conf/oozie-site.xml file as follow
<property>
 <name>oozie.service.JPAService.jdbc.driver</name>
 <value>org.postgresql.Driver</value>
</property>
<property>
 <name>oozie.service.JPAService.jdbc.url</name>
 <value>jdbc:postgresql://df5.datamind.lab/ooziedatastore</value>
</property>
<property>
 <name>oozie.service.JPAService.jdbc.username</name>
 <value>oozieusr</value>
</property>
<property>
 <name>oozie.service.JPAService.jdbc.password</name>
 <value>Datamind123.</value>
</property>

# Link PostgreSQL JDBC jar file in Oozie 
ln -s /usr/share/java/postgresql-jdbc.jar /opt/mapr/oozie/oozie-<version>/libext/postgresql-jdbc.jar

# Prepare Oozie war file
# /opt/mapr/oozie/oozie-<version>/bin/oozie-setup.sh prepare-war 

# Prepare Oozie schema using below command
/opt/mapr/oozie/oozie-<version>/bin/oozie-setup.sh db create -sqlfile oozie-create.sql -run

# Import Old database
/opt/mapr/oozie/oozie-<version>/oozie-setup.sh import /tmp/oozie_db.zip

# Start Oozie
maprcli node services -name oozie -action start -nodes <node-list>

