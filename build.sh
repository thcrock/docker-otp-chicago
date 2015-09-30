#!/bin/bash

OTP_BASE=/var/otp
OTP_GRAPHS=$OTP_BASE/graphs
OTP_ROUTER=${router:-default}

mkdir -p $OTP_GRAPHS

# Defining the env variables
export JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64"
mkdir $OTP_GRAPHS
wget -S -nv -P $OTP_GRAPHS http://www.transitchicago.com/downloads/sch_data/google_transit.zip
  
java -Xmx8G -jar $OTP_BASE/otp.jar --build $OTP_GRAPHS
