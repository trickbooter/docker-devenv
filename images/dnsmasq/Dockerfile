FROM ubuntu:precise
MAINTAINER trickbooter (paul@trickbooter.com)

VOLUME [ "/etc/dnsmasq.d" ]

RUN apt-get update
RUN apt-get install -y dnsmasq-base

RUN echo "user=root" > /etc/dnsmasq.conf
RUN echo "listen-address=__LOCAL_IP__" >> /etc/dnsmasq.conf
RUN echo "resolv-file=/etc/resolv.dnsmasq.conf" >> /etc/dnsmasq.conf
RUN echo "conf-dir=/etc/dnsmasq.d"  >> /etc/dnsmasq.conf
RUN echo "domain=devcluster.local"  >> /etc/dnsmasq.conf

RUN echo "nameserver 8.8.8.8" >> /etc/resolv.dnsmasq.conf

ADD files /root/dnsmasq_files

CMD ["/root/dnsmasq_files/default_cmd"]
