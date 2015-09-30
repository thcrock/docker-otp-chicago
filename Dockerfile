FROM debian:sid

MAINTAINER Tristan Crockett <tristan.h.crockett@gmail.com>


RUN apt-get update
RUN apt-get install -y openjdk-8-jre wget
RUN mkdir -p /var/otp
RUN cd /var/otp
RUN wget -S -nv -O /var/otp/otp.jar http://dev.opentripplanner.org/jars/otp-0.18.0.jar


ADD build.sh /root/
RUN chmod +x /root/build.sh

ENTRYPOINT [ "/root/build.sh" ]

CMD ['--help']
