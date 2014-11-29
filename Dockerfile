# Apache Cassandra

FROM digitalwonderland/oracle-jre-8:latest

ENV CASSANDRA_CONF /etc/cassandra/conf

ADD ./src /

RUN chmod +x /usr/local/sbin/start.sh

RUN yum install -y cassandra21 && yum clean all \
  && rm /etc/security/limits.d/cassandra.conf

EXPOSE 7000 7001 9042

VOLUME ["/var/lib/cassandra"]

ENTRYPOINT ["/usr/local/sbin/start.sh"]
