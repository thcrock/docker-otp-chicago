FROM debian:sid

MAINTAINER Tristan Crockett <tristan.h.crockett@gmail.com>

RUN \
  apt-get update && \
  apt-get install -y openjdk-8-jre wget osmosis

ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64

RUN \
  mkdir -p /var/otp && \
  wget -O /var/otp/otp.jar http://maven.conveyal.com.s3.amazonaws.com/org/opentripplanner/otp/0.19.0/otp-0.19.0-shaded.jar && \
  wget -O /var/otp/jython.jar http://search.maven.org/remotecontent?filepath=org/python/jython-standalone/2.7.0/jython-standalone-2.7.0.jar

ENV OTP_BASE /var/otp
ENV OTP_GRAPHS /var/otp/graphs

RUN \
  mkdir -p /var/otp/graphs/chicago && \
  wget -O /var/otp/graphs/chicago/illinois.osm.pbf http://download.geofabrik.de/north-america/us/illinois-latest.osm.pbf && \
  wget -O /var/otp/graphs/chicago/wisconsin.osm.pbf http://download.geofabrik.de/north-america/us/wisconsin-latest.osm.pbf

RUN \
  osmosis --read-pbf file=/var/otp/graphs/chicago/illinois.osm.pbf --bounding-box left=-88.9151 bottom=41.325264 --write-pbf /var/otp/graphs/chicago/illinois-metra.pbf && \
  osmosis --read-pbf file=/var/otp/graphs/chicago/wisconsin.osm.pbf --bounding-box left=-88.073959 top=42.67032 --write-pbf /var/otp/graphs/chicago/kenosha-metra.pbf && \
  rm /var/otp/graphs/chicago/illinois.osm.pbf && \
  rm /var/otp/graphs/chicago/wisconsin.osm.pbf && \
  osmosis --read-pbf file=/var/otp/graphs/chicago/illinois-metra.pbf --read-pbf file=/var/otp/graphs/chicago/kenosha-metra.pbf --merge --write-pbf /var/otp/graphs/chicago/chicago-metra.pbf && \
  rm /var/otp/graphs/chicago/illinois-metra.pbf && \
  rm /var/otp/graphs/chicago/kenosha-metra.pbf

RUN \
  wget -O /var/otp/graphs/chicago/pace.zip http://www.pacebus.com/gtfs/gtfs.zip && \
  wget -O /var/otp/graphs/chicago/metra.zip http://transitfeeds.com/p/metra/169/latest/download && \
  wget -O /var/otp/graphs/chicago/cta.zip http://www.transitchicago.com/downloads/sch_data/google_transit.zip && \
  java -Xmx8G -jar /var/otp/otp.jar --build /var/otp/graphs/chicago

EXPOSE 8080
EXPOSE 8081

ENTRYPOINT [ "java", "-Xmx6G", "-Xverify:none", "-cp", "/var/otp/otp.jar:/var/otp/jython.jar", "org.opentripplanner.standalone.OTPMain" ]

CMD [ "--help" ]
