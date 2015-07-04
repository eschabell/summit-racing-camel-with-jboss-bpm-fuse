#!/bin/sh 
DEMO="JBoss BPM Suite & Fuse Travel Agency Integration Demo"
AUTHORS="Christina Lin, Eric D. Schabell"
PROJECT="git@github.com:jbossdemocentral/bpms-fuse-travel-agency-integration-demo.git"

#BPM env
JBOSS_HOME=./target/jboss-eap-6.4
SERVER_DIR=$JBOSS_HOME/standalone/deployments/
SERVER_CONF=$JBOSS_HOME/standalone/configuration/
SERVER_BIN=$JBOSS_HOME/bin
SRC_DIR=./installs
PRJ_DIR=./projects
SUPPORT_DIR=./support
BPMS=jboss-bpmsuite-6.1.0.GA-installer.jar
EAP=jboss-eap-6.4.0-installer.jar
BPM_VERSION=6.1

#Fuse env 
DEMO_HOME=./target
FUSE=jboss-fuse-6.2.0.redhat-133
FUSE_ZIP=jboss-fuse-full-6.2.0.redhat-133.zip
FUSE_HOME=$DEMO_HOME/$FUSE
FUSE_PROJECT=projects/fuseparent
FUSE_SERVER_CONF=$FUSE_HOME/etc
FUSE_SERVER_SYSTEM=$FUSE_HOME/system
FUSE_SERVER_BIN=$FUSE_HOME/bin
FUSE_VERSION=6.2.0

# wipe screen.
clear 

# add executeable in installs
chmod +x installs/*.zip

echo
echo "#####################################################################################"
echo "##                                                                                 ##"   
echo "##  Setting up the                                                                 ##"
echo "##                                                                                 ##"   
echo "##            ${DEMO}                ##"
echo "##                                                                                 ##"   
echo "##                                                                                 ##"   
echo "##        ####   ####    #   #    ###             ####  #  #   ###  ####           ##"
echo "##        #   #  #   #  # # # #  #         #      #     #  #  #     #              ##"
echo "##        ####   ####   #  #  #   ##      ###     ###   #  #   ##   ###            ##"
echo "##        #   #  #      #     #     #      #      #     #  #     #  #              ##"
echo "##        ####   #      #     #  ###              #     ####  ###   ####           ##"
echo "##                                                                                 ##"   
echo "##                                                                                 ##"   
echo "##  brought to you by,                                                             ##"   
echo "##                     ${AUTHORS}                             ##"
echo "##                                                                                 ##"   
echo "##  ${PROJECT}   ##"
echo "##                                                                                 ##"   
echo "#####################################################################################"
echo

command -v mvn -q >/dev/null 2>&1 || { echo >&2 "Maven is required but not installed yet... aborting."; exit 1; }

# make some checks first before proceeding.	
if [ -r $SRC_DIR/$EAP ] || [ -L $SRC_DIR/$EAP ]; then
	echo Product sources are present...
	echo
else
	echo Need to download $EAP package from the Customer Portal 
	echo and place it in the $SRC_DIR directory to proceed...
	echo
	exit
fi

if [ -r $SRC_DIR/$BPMS ] || [ -L $SRC_DIR/$BPMS ]; then
	echo Product sources BPM are present...
	echo
else
	echo Need to download $BPMS package from the Customer Portal 
	echo and place it in the $SRC_DIR directory to proceed...
	echo
	exit
fi

if [ -r $SRC_DIR/$FUSE_ZIP ]||[ -L $SRC_DIR/$FUSE_ZIP ]; then
		echo $DEMO FUSE is present...
		echo
else
		echo Need to download $FUSE_ZIP package from the Customer Support Portal 
		echo and place it in the $SRC_DIR directory to proceed...
		echo
		exit
fi

# Remove JBoss product installation if exists.
if [ -x target ]; then
	echo "  - existing JBoss product installation detected..."
	echo
	echo "  - removing existing JBoss product installation..."
	echo
	rm -rf target
fi

# Run installers.
echo "JBoss EAP installer running now..."
echo
java -jar $SRC_DIR/$EAP $SUPPORT_DIR/installation-eap -variablefile $SUPPORT_DIR/installation-eap.variables

if [ $? -ne 0 ]; then
	echo
	echo Error occurred during JBoss EAP installation!
	exit
fi

echo
echo "JBoss BPM Suite installer running now..."
echo
java -jar $SRC_DIR/$BPMS $SUPPORT_DIR/installation-bpms -variablefile $SUPPORT_DIR/installation-bpms.variables

if [ $? -ne 0 ]; then
	echo Error occurred during BPMS installation!
	exit
fi

echo
echo Installing JBoss FUSE $FUSE_VERSION
echo
echo Unpacking JBoss FUSE $VERSION
echo
unzip -q -d $DEMO_HOME $SRC_DIR/$FUSE_ZIP

echo
echo "  - enabling demo accounts role setup in application-roles.properties file..."
echo
cp $SUPPORT_DIR/application-roles.properties $SERVER_CONF

echo "  - setting up demo projects..."
echo
cp -r $SUPPORT_DIR/bpm-suite-demo-niogit $SERVER_BIN/.niogit

echo "  - setting up web services..."
echo
mvn clean install -f $PRJ_DIR/pom.xml

echo
echo "  - adding acmeDataModel-1.0.jar to business-central.war/WEB-INF/lib"
echo
cp -r $PRJ_DIR/acme-data-model/target/acmeDataModel-1.0.jar $SERVER_DIR/business-central.war/WEB-INF/lib

echo "  - deploying external-client-ui-form-1.0.war to EAP deployments directory"
echo
cp -r $PRJ_DIR/external-client-ui-form/target/external-client-ui-form-1.0.war $SERVER_DIR/

echo "  - setting up standalone.xml configuration adjustments..."
echo
cp $SUPPORT_DIR/standalone.xml $SERVER_CONF

echo "  - making sure standalone.sh for server is executable..."
echo
chmod u+x $JBOSS_HOME/bin/standalone.sh

echo "  - setup email task notification users..."
echo
cp $SUPPORT_DIR/userinfo.properties $SERVER_DIR/business-central.war/WEB-INF/classes/

echo "  - updating the CustomWorkItemHandler.conf file to use the appropriate email server..."
echo
cp -f $SUPPORT_DIR/CustomWorkItemHandlers.conf $SERVER_DIR/business-central.war/WEB-INF/classes/META-INF

# Optional: uncomment this to install mock data for BPM Suite.
#
#echo - setting up mock bpm dashboard data...
#cp $SUPPORT_DIR/1000_jbpm_demo_h2.sql $SERVER_DIR/dashbuilder.war/WEB-INF/etc/sql
#echo

#SETUP and INSTALL FUSE services
echo "  - enabling demo accounts logins in users.properties file..."
echo
cp $SUPPORT_DIR/fuse/users.properties $FUSE_SERVER_CONF

echo "  - Add local bpm repo config file..."
echo
cp $SUPPORT_DIR/fuse/org.ops4j.pax.url.mvn.cfg $FUSE_SERVER_CONF

echo "  - create h2 database file..."
echo

if [ -x ~/h2 ]; then
	rm -rf ~/h2/travelagency.mv.db
else
	mkdir ~/h2
fi

cp $SUPPORT_DIR/fuse/data/travelagency.mv.db ~/h2/

echo
echo "==========================================================================================="
echo "=                                                                                         ="
echo "=  You can now start the workshop by following the rest of the instructions in:           ="
echo "=                                                                                         ="
echo "=     Summit-Lab-Tavel-Agency-Start.odt or Summit-Lab-Tavel-Agency-Start.pdf              ="
echo "=                                                                                         ="
echo "=   $DEMO Setup Complete.                 ="
echo "==========================================================================================="
echo
