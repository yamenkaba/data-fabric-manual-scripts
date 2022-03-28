OS: ubuntu
!!! must be adjusted accordingly to OS used !!!

## Unify time across servers:
https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/configuring_basic_system_settings/using-chrony_configuring-basic-system-settings
 
# Checking OS version:
  cat /etc/os-release
		
# Checking CPU architecture:
  uname -m 

#	Checking RAM allocation:
  free -g

#	Checking swap memory size and swapness value:
  lsblk
  swapoff -v /dev/root_vg/swap_lv
  lvresize /dev/root_vg/swap_lv -L +3G
  mkswap /dev/root_vg/swap_lv
  swapon -v /dev/root_vg/swap_lv

# Disable numad/iptable:
  systemctl disable numad
  systemctl disable iptable

# Check/Disable rsyslog:
	systemctl status rsyslog
	systemctl stop rsyslog
			
# Check/Disable nfs:
	systemctl status nfs
	systemctl stop nfs

# Run as root:
  echo never > /sys/kernel/mm/transparent_hugepage/enabled
  sed -i 's/^SELINUX=.*/SELINUX=disabled/g' /etc/selinux/config

# Create mapr user
groupadd -g 5000 mapr && useradd -g 5000 -m -s /bin/bash -u 5000 mapr

# Edit mapr user limits:
vi /etc/security/limits.conf
  mapr - nofile 65536
  mapr - nproc 64000
  mapr - memlock unlimited
  mapr - core unlimited
  mapr - nice -10

# Create a custom tmp directory for mapr and set its permission similar to /tmp:
			mkdir /opt/mapr
			mkdir /opt/mapr/tmp
			chmod 1777 /opt/mapr/tmp
			export JDK_JAVA_OPTIONS="-Djava.io.tmpdir=/opt/mapr/tmp"

### Ubuntu related
# echo "mapr:mapr123" | chpasswd

# all nodes prep
# apt update
# apt upgrade -y
# apt install -y openjdk-11-jdk

# wget -O - https://package.mapr.hpe.com/releases/pub/maprgpg.key | sudo apt-key add -

# echo 'deb https://package.mapr.hpe.com/releases/v6.2.0/ubuntu binary trusty' >> /etc/apt/sources.list
# echo 'deb https://package.mapr.hpe.com/releases/MEP/MEP-8.0.0/ubuntu binary trusty' >> /etc/apt/sources.list
# apt update
### End

### RHEL8 Replacement
passwd mapr
chage -d 2023-01-25 mapr
usermod -aG wheel,root mapr

# To install the package key
rpm --import https://package.mapr.hpe.com/releases/pub/maprgpg.key

# Install dependesies
  # Enable RHEL Base/Development/EPEL repos:
			subscription-manager repos --enable=rhel-8-for-x86_64-baseos-rpms
			subscription-manager repos --enable=rhel-8-for-x86_64-appstream-rpms
  # Install Epel Repo:
      wget http://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm -P /tmp
      rpm -Uvh epel-release-latest-8*.rpm
  # Updating YUM repositories:
			yum update
### End


## UBUNTU dependencies for tools
## I just added all possible dependencies here... because I'm lazy... usually
## you just need to install necessary dependencies
# apt install adduser bash coreutils debianutils dmidecode gawk grep hdparm libltdl7 iputils-arping irqbalance libc6 libcomerr2 libgcc1 libgssapi-krb5-2 libk5crypto3 libkrb5-3 libldap-2.4-2 libpython2.7 libsasl2-dev libsasl2-modules-gssapi-mit libsqlite3-0 libssl1.0.0 libstdc++6 libxml2 libxslt1.1 lsb-base lsof net-tools netcat-openbsd nfs-common perl procps rpcbind sdparm sed syslinux sysvinit-utils unzip zip zlib1g

### RHEL8 Replacement
## ntp python-devel
yum -y install	curl device-mapper iputils libsysfs lvm2 nc nfs-utils nss openssl sdparm sudo syslinux sysstat wget which yum-utils compat-openssl10 python3 telnet
yum -y install bash glibc libgcc libstdc++ lsof net-tools syslinux dmidecode hdparm initscripts irqbalance perl redhat-lsb-core shadow-utils coreutils libxml2 libxslt
yum -y install readline fontconfig cyrus-sasl-gssapi cyrus-sasl-plain sqlite zlib krb5-libs python2 iputils rpcbind userspace-rcu unzip zip nmap-ncat
yum install -y java-11-openjdk java-11-openjdk-devel
yum update -y
export JAVA_HOME="/usr/lib/jvm/java-11-openjdk"
export PATH=$JAVA_HOME/bin:$PATH
### End

## create disk file on all nodes
echo '/dev/sdc' > /tmp/disks.txt
# echo '/dev/sdb' >> /tmp/disks.txt
# echo '/dev/sdd' >> /tmp/disks.txt

## Adding the Internet Repository on RHEL, CentOS, or Oracle Linux
# Create a text file called maprtech.repo in the /etc/yum.repos.d/ directory with the following content, replacing <version> with the version of data-fabric software that you want to install.
[maprtech]
name=Datamind
baseurl=https://package.mapr.hpe.com/releases/v6.2.0/redhat/
enabled=1
gpgcheck=1
protect=1

[maprecosystem]
name=Datamind
baseurl=https://package.mapr.hpe.com/releases/MEP/MEP-8.1/redhat/
enabled=1
gpgcheck=1
protect=1

## Change Systemctl configuration:
vi /etc/sysctl.conf
  fs.file-max = 51200
  net.core.rmem_max = 8388608
  net.core.wmem_max = 8388608
  net.core.rmem_default=1048576
  net.core.wmem_default=1048576
  net.core.netdev_max_backlog=30000
  net.ipv4.tcp_rmem = 4096 262144 8388608
  net.ipv4.tcp_wmem = 4096 262144 8388608
  net.ipv4.tcp_mem=8388608 8388608 8388608
  net.ipv4.tcp_retries2=5
  net.ipv4.tcp_syn_retries=4
  vm.dirty_ratio=6
  vm.dirty_background_ratio=3
  vm.swappiness=1
  vm.overcommit_memory=0
  fs.aio-max-nr=262144
sysctl -p /etc/sysctl.conf

node 1 2
yum install -y mapr-fileserver mapr-cldb mapr-webserver mapr-apiserver mapr-mastgateway

node 3
yum install -y mapr-fileserver mapr-cldb mapr-mastgateway

node 4 5 6
yum install -y mapr-fileserver mapr-zookeeper mapr-gateway

# Installing NFS
https://docs.datafabric.hpe.com/62/AdvancedInstallation/InstallNFS.html

#### configuring nodes...
#>> enter node 1
#initial cfg
/opt/mapr/server/configure.sh -secure -genkeys -dare \
  -C df1.datamind.lab,df2.datamind.lab,df3.datamind.lab \
  -Z df4.datamind.lab,df5.datamind.lab,df6.datamind.lab \
  -N datafabric.datamind.com \
  -F /tmp/disks.txt

# copy cldb key to all cldb/zk nodes
scp /opt/mapr/conf/cldb.key df2.datamind.lab:/opt/mapr/conf/
scp /opt/mapr/conf/cldb.key df3.datamind.lab:/opt/mapr/conf/
scp /opt/mapr/conf/cldb.key df4.datamind.lab:/opt/mapr/conf/
scp /opt/mapr/conf/cldb.key df5.datamind.lab:/opt/mapr/conf/
scp /opt/mapr/conf/cldb.key df6.datamind.lab:/opt/mapr/conf/

# copy dare master key to all cldb nodes
scp /opt/mapr/conf/dare.master.key df2.datamind.lab:/opt/mapr/conf/
scp /opt/mapr/conf/dare.master.key df3.datamind.lab:/opt/mapr/conf/

# copy all files involved in secured cluster to all nodes
cd /opt/mapr/conf
scp maprserverticket ssl_keystore ssl_keystore.csr ssl_keystore.p12 ssl_keystore.pem ssl_keystore-signed.pem ssl_truststore \
  ssl_truststore.p12 ssl_truststore.pem ssl-server.xml ssl-client.xml ssl_userkeystore ssl_userkeystore.csr ssl_userkeystore.p12 \
  ssl_userkeystore.pem ssl_userkeystore-signed.pem ssl_usertruststore ssl_usertruststore.p12 ssl_usertruststore.pem \
  df2.datamind.lab:/opt/mapr/conf/
scp maprserverticket ssl_keystore ssl_keystore.csr ssl_keystore.p12 ssl_keystore.pem ssl_keystore-signed.pem ssl_truststore \
  ssl_truststore.p12 ssl_truststore.pem ssl-server.xml ssl-client.xml ssl_userkeystore ssl_userkeystore.csr ssl_userkeystore.p12 \
  ssl_userkeystore.pem ssl_userkeystore-signed.pem ssl_usertruststore ssl_usertruststore.p12 ssl_usertruststore.pem \
  df3.datamind.lab:/opt/mapr/conf/
scp maprserverticket ssl_keystore ssl_keystore.csr ssl_keystore.p12 ssl_keystore.pem ssl_keystore-signed.pem ssl_truststore \
  ssl_truststore.p12 ssl_truststore.pem ssl-server.xml ssl-client.xml ssl_userkeystore ssl_userkeystore.csr ssl_userkeystore.p12 \
  ssl_userkeystore.pem ssl_userkeystore-signed.pem ssl_usertruststore ssl_usertruststore.p12 ssl_usertruststore.pem \
  df4.datamind.lab:/opt/mapr/conf/
scp maprserverticket ssl_keystore ssl_keystore.csr ssl_keystore.p12 ssl_keystore.pem ssl_keystore-signed.pem ssl_truststore \
  ssl_truststore.p12 ssl_truststore.pem ssl-server.xml ssl-client.xml ssl_userkeystore ssl_userkeystore.csr ssl_userkeystore.p12 \
  ssl_userkeystore.pem ssl_userkeystore-signed.pem ssl_usertruststore ssl_usertruststore.p12 ssl_usertruststore.pem \
  df5.datamind.lab:/opt/mapr/conf/
scp maprserverticket ssl_keystore ssl_keystore.csr ssl_keystore.p12 ssl_keystore.pem ssl_keystore-signed.pem ssl_truststore \
  ssl_truststore.p12 ssl_truststore.pem ssl-server.xml ssl-client.xml ssl_userkeystore ssl_userkeystore.csr ssl_userkeystore.p12 \
  ssl_userkeystore.pem ssl_userkeystore-signed.pem ssl_usertruststore ssl_usertruststore.p12 ssl_usertruststore.pem \
  df6.datamind.lab:/opt/mapr/conf/


## intermediate step >> create ca certificate folder on all other nodes (2 3 4 5 6)
mkdir /opt/mapr/conf/ca

## go back to node 1
## copy the certificate to all nodes
scp /opt/mapr/conf/ca/chain-ca.pem /opt/mapr/conf/ca/root-ca.pem /opt/mapr/conf/ca/signing-ca.pem df2.datamind.lab:/opt/mapr/conf/ca/
scp /opt/mapr/conf/ca/chain-ca.pem /opt/mapr/conf/ca/root-ca.pem /opt/mapr/conf/ca/signing-ca.pem df3.datamind.lab:/opt/mapr/conf/ca/
scp /opt/mapr/conf/ca/chain-ca.pem /opt/mapr/conf/ca/root-ca.pem /opt/mapr/conf/ca/signing-ca.pem df4.datamind.lab:/opt/mapr/conf/ca/
scp /opt/mapr/conf/ca/chain-ca.pem /opt/mapr/conf/ca/root-ca.pem /opt/mapr/conf/ca/signing-ca.pem df5.datamind.lab:/opt/mapr/conf/ca/
scp /opt/mapr/conf/ca/chain-ca.pem /opt/mapr/conf/ca/root-ca.pem /opt/mapr/conf/ca/signing-ca.pem df6.datamind.lab:/opt/mapr/conf/ca/



###################################
###################################
###   undocumented part .....   ###
#vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
#vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv

## copy the ssl-server.xml with the password to all nodes
##  - internally it seems like this file is used as the base for truststore key configuration
scp /opt/mapr/hadoop/hadoop-2.7.6/etc/hadoop/ssl-server.xml df2.datamind.lab:/opt/mapr/hadoop/hadoop-2.7.6/etc/hadoop/
scp /opt/mapr/hadoop/hadoop-2.7.6/etc/hadoop/ssl-server.xml df3.datamind.lab:/opt/mapr/hadoop/hadoop-2.7.6/etc/hadoop/
scp /opt/mapr/hadoop/hadoop-2.7.6/etc/hadoop/ssl-server.xml df4.datamind.lab:/opt/mapr/hadoop/hadoop-2.7.6/etc/hadoop/
scp /opt/mapr/hadoop/hadoop-2.7.6/etc/hadoop/ssl-server.xml df5.datamind.lab:/opt/mapr/hadoop/hadoop-2.7.6/etc/hadoop/
scp /opt/mapr/hadoop/hadoop-2.7.6/etc/hadoop/ssl-server.xml df6.datamind.lab:/opt/mapr/hadoop/hadoop-2.7.6/etc/hadoop/

#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
###   undocumented part .....   ###
###################################
###################################



## run the configure script without genkeys on node 2 and 3
/opt/mapr/server/configure.sh -secure -dare \
  -C df1.datamind.lab,df2.datamind.lab,df3.datamind.lab \
  -Z df4.datamind.lab,df5.datamind.lab,df6.datamind.lab \
  -N datafabric.datamind.com \
  -F /tmp/disks.txt


## now run configure script without genkeys on node 4 5 6 
## >> without storage <<
## we will add storage to these nodes later. Because we need a running system
## so that the disksetup tool can communicate with a running cldb service
## run the configure script without genkeys on node 2 and 3
/opt/mapr/server/configure.sh -secure -dare \
  -C df1.datamind.lab,df2.datamind.lab,df3.datamind.lab \
  -Z df4.datamind.lab,df5.datamind.lab,df6.datamind.lab \
  -N datafabric.datamind.com

## bring up the cluster 
## start zookeeper on node 4 5 6
systemctl restart mapr-zookeeper.service

## run deisksetup to format disks on node 4 5 6
## the -F option stands only for 'forced reformat' if you need to rerun this step
/opt/mapr/server/disksetup -F /tmp/disks.txt

## should be Active: active (running) after this
## start mapr-warden on all nodes
systemctl restart mapr-warden.service
