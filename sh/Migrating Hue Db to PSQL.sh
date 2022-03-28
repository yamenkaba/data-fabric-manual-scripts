# Enter with postgres user and create huemetastoredb/db_user/db_user_pass and grant previliges
sudo -u postgres psql
create database huemetastore;
create user hueusr with encrypted password 'Datamind123.';
grant all privileges on database huemetastore to hueusr;

# To migrate your existing data to PostgreSQL, use the following command to dump the existing database data to a text file. Note that using the “.json” extension is required.
# /opt/mapr/hue/hue-4.6.0/bin/hue dumpdata > ./hue_db_dump.json

# Install the following packages
sudo yum install -y gcc postgresql-devel

# Download necessary python package 
cd /opt/mapr/hue/hue-<version>
source ./bin/activate
pip install psycopg2
deactivate

# Open the /opt/mapr/hue/hue-4.6.0/desktop/conf/hue.ini file and edit the [[database]] section (modify for your MySQL setup).
[[database]] 
engine=postgresql_psycopg2
host=df5.datamind.lab
port=5432
user=hueusr
password=Datamind123.
name=huemetastore

# As the Mapr user, configure Hue to load the existing data and create the necessary database tables.
sudo /opt/mapr/server/configure.sh -R

# Your system is now configured and you can start the Hue server as normal.
maprcli node services -name hue -action restart -nodes df2.datamind.lab,df3.datamind.lab