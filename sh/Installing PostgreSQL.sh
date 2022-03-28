# https://www.postgresql.org/download/linux/redhat/

# Installing PostgreSQL latest version
# # Install the repository RPM
sudo dnf install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-8-x86_64/pgdg-redhat-repo-latest.noarch.rpm

# Disable the built-in PostgreSQL module
sudo dnf -qy module disable postgresql

# Install PostgreSQL
sudo dnf install -y postgresql14-server

# Optionally initialize the database and enable automatic start
sudo /usr/pgsql-14/bin/postgresql-14-setup initdb
sudo systemctl enable postgresql-14
sudo systemctl start postgresql-14

# Post installation
postgresql-setup --initdb
systemctl enable postgresql.service
systemctl start postgresql.service

# Edit /var/lib/pgsql/14/data/pg_hba.conf file add:
# Or you can specify a saperate record for each IP
# TYPE  DATABASE        USER            ADDRESS                 METHOD

# "local" is for Unix domain socket connections only
local   all             all                                     trust
# IPv4 local connections:
host    all             all             0.0.0.0/32              password
# IPv6 local connections:
host    all             all             ::1/128                 password
# Allow replication connections from localhost, by a user with the
# replication privilege.
local   replication     all                                     trust
host    replication     all             0.0.0.0/32              password
host    replication     all             ::1/128                 password

# Open Listeinig from all IPs, edit /var/lib/pgsql/14/data/postgresql.conf
# You can use * or, specify every ip as space saperated list
# edit listen_addresses = '*'

# Restart PostgreSQL
systemctl restart postgresql-14