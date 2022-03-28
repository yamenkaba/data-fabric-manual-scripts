# https://docs.datafabric.hpe.com/62/AdvancedInstallation/InstallingHue.html
# https://docs.datafabric.hpe.com/62/Hue/IntegrateHue.html

# On nodes 2, 3
yum install -y mapr-hue

## Run server configure.sh -R on all Hue nodes
/opt/mapr/server/configure.sh -R

# Configure HTTPFS with HUE
# Edit hue.ini
webhdfs_url=https://df3.datamind.lab:14000/webhdfs/v1

# Configure Oozie with HUE
# Edit hue.ini
# https://docs.datafabric.hpe.com/62/Hue/ConfigureHuewithOozie.html
# [liboozie]   
# The URL (host IP address) where the Oozie service is running. This is required in order for # users to submit jobs. 
oozie_url=http://<ip_address>:<oozie_port_number>/oozie

# Restart Oozie
maprcli node services -name oozie -action restart -nodes df3.datamind.lab,df4.datamind.lab