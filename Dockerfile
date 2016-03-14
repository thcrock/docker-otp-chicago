FROM debian:sid

MAINTAINER Tristan Crockett <tristan.h.crockett@gmail.com>

RUN \
  apt-get update && \
  apt-get install -y openjdk-8-jre wget

ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64

RUN mkdir -p /var/otp && wget -O /var/otp/otp.jar http://maven.conveyal.com.s3.amazonaws.com/org/opentripplanner/otp/0.19.0/otp-0.19.0-shaded.jar

ENV OTP_BASE /var/otp
ENV OTP_GRAPHS /var/otp/graphs

RUN \
  mkdir -p /var/otp/graphs && \
  wget -O /var/otp/graphs/pace.zip http://www.pacebus.com/gtfs/gtfs.zip && \
  wget -O /var/otp/graphs/metra.zip http://transitfeeds.com/p/metra/169/latest/download && \
  wget -O /var/otp/graphs/cta.zip http://www.transitchicago.com/downloads/sch_data/google_transit.zip && \
  wget -P /var/otp/graphs https://s3.amazonaws.com/metro-extracts.mapzen.com/chicago_illinois.osm.pbf && \
  java -Xmx8G -jar /var/otp/otp.jar --build /var/otp/graphs

EXPOSE 8080
EXPOSE 8081

ENTRYPOINT [ "java", "-Xmx6G", "-Xverify:none", "-jar", "/var/otp/otp.jar" ]

CMD [ "--help" ]
