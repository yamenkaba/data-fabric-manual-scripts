# Create the Airflow db_user on OS level:
useradd ailrflowusr
passwd ailrflowusr
chage -d 2024-01-25 ailrflowusr

# Enter with postgres user and create Airflowmetastoredb/db_user/db_user_pass and grant previliges.
sudo -u postgres psql
create database airflowmetastore;
create user ailrflowusr with encrypted password 'Datamind123.';
grant all privileges on database airflowmetastore to ailrflowusr;