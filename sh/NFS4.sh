# https://docs.datafabric.hpe.com/62/AdvancedInstallation/InstallNFS.html

## Download, if necessary, and install the nfs-utils package, if it is already not installed, on the host where you plan to install the NFSv4 server
yum install -y nfs-utils

## Ensure that rpc.statd is running on the node
ps -ef| grep rpc.st
# if not
/sbin/rpc.statd

## Install NFSv4 server package
yum install -y mapr-nfs4server

## Mounting NFS for the HPE Ezmeral Data Fabric to filesystem on a Cluster Node
sudo mkdir /mapr

## Add the following line to /opt/mapr/conf/mapr_fstab:
<hostname>:/mapr /mapr hard,nolock
df1.datamind.lab:/mapr /mapr hard,nolock
df2.datamind.lab:/mapr /mapr hard,nolock
df3.datamind.lab:/mapr /mapr hard,nolock
df4.datamind.lab:/mapr /mapr hard,nolock
df5.datamind.lab:/mapr /mapr hard,nolock
df6.datamind.lab:/mapr /mapr hard,nolock

## Run configure.sh utility with the -u and -g options to configure the services to run under user mapr and the group of the mapr user.
/opt/mapr/server/configure.sh -R -u mapr -g mapr

## Restart Warden on all nodes
systemctl restart mapr-warden.service

## Accessing Data with NFS v4
https://docs.datafabric.hpe.com/62/AdministratorGuide/AccessDataWithNFSv4.html