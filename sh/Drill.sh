# https://docs.datafabric.hpe.com/62/Drill/ApacheDrillonMapR.html

# Run on all nodes
sudo yum install mapr-drill-yarn

## Run server configure.sh -R on all Livy nodes
/opt/mapr/server/configure.sh -R

# Configure Drill to run under YARN
# https://docs.datafabric.hpe.com/62/Drill/configure_drill_to_run_under_yarn.html#configure_drill_to_run_under_yarn
# https://docs.datafabric.hpe.com/62/Drill/step_2__drill_on_yarn_configuration.html

# Create the site directory and an environment variable for the directory
export DRILL_SITE=/opt/mapr/drill/site
mkdir $DRILL_SITE

# Copy the drill-env.sh, drill-override.conf, drill-on-yarn.conf, and distrib-env.sh files from $DRILL_HOME/conf/ into the site directory.
# In the following example, $DRILL_HOME is the location of the new Drill installation (usually /opt/mapr/drill/drill-<version>)
cp $DRILL_HOME/conf/drill-override.conf $DRILL_SITE
cp $DRILL_HOME/conf/drill-env.sh $DRILL_SITE
cp $DRILL_HOME/conf/drill-on-yarn.conf $DRILL_SITE
cp $DRILL_HOME/conf/distrib-env.sh $DRILL_SITE

# Use the Site Directory to Test Drill
$DRILL_HOME/bin/drill-on-yarn.sh --site $DRILL_SITE start
$DRILL_HOME/bin/drill-on-yarn.sh --site $DRILL_SITE status