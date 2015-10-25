# Apache Cassandra

FROM digitalwonderland/oracle-jre-8:latest

ENV CASSANDRA_CONF /etc/cassandra/conf

ADD ./src /

RUN chmod +x /usr/local/sbin/start.sh

RUN yum install -y cassandra22 && yum clean all \
  && rm /etc/security/limits.d/cassandra.conf

EXPOSE 7000 7001 7199 9042 9160

VOLUME ["/var/lib/cassandra"]

ENTRYPOINT ["/usr/local/sbin/start.sh"]
