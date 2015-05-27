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
FUSE=jboss-fuse-6.1.1.redhat-412
FUSE_ZIP=jboss-fuse-full-6.1.1.redhat-412.zip
FUSE_HOME=$DEMO_HOME/$FUSE
FUSE_PROJECT=projects/fuseparent
FUSE_SERVER_CONF=$FUSE_HOME/etc
FUSE_SERVER_SYSTEM=$FUSE_HOME/system
FUSE_SERVER_BIN=$FUSE_HOME/bin
FUSE_VERSION=6.1.1



echo "Start compile and deploy the rest of travel agency camel demo project to fuse"
echo         
mvn clean fabric8:deploy 



echo "Create containers and add profiles for Flight web service endpoint"
echo         
sh $FUSE_SERVER_BIN/client -r 2 -d 5 'container-create-child --profile demo-travelagency-webendpoint root wsflightcon'

echo "Create containers and add profiles for Hotel web service endpoint"
echo         
sh $FUSE_SERVER_BIN/client -r 2 -d 5 'container-create-child --profile demo-travelagency-hotelwsendpoint root wshotelcon

echo "Create containers and add profiles for flight booking service"
echo         
sh $FUSE_SERVER_BIN/client -r 2 -d 5 'container-create-child --profile demo-travelagency-bookingservice root bookingflightcon'

echo "Create containers and add profiles for hotel booking service"
echo         
sh $FUSE_SERVER_BIN/client -r 2 -d 5 'container-create-child --profile demo-travelagency-hotelbookingservice root bookinhotelgcon'

echo "Create containers and add profiles flight promotion"
echo
sh $FUSE_SERVER_BIN/client -r 2 -d 5 'container-create-child --profile demo-travelagency-promotionflight root promoflightcon'

