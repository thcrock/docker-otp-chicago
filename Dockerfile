FROM debian

MAINTAINER Tristan Crockett <tristan.h.crockett@gmail.com>


RUN apt-get update
RUN apt-get install -y openjdk-7-jre wget
RUN mkdir -p /var/otp
RUN cd /var/otp
RUN wget -S -nv -O /var/otp/otp.jar http://dev.opentripplanner.org/jars/otp-0.18.0.jar
