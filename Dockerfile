FROM quay.io/wildfly/wildfly:26.1.2.Final

# Instalar OpenJDK 8
USER root
RUN yum install -y java-1.8.0-openjdk

# Configurar JAVA_HOME
ENV JAVA_HOME=/usr/lib/jvm/java-1.8.0
ENV PATH=$JAVA_HOME/bin:$PATH

USER 1001
CMD ["/opt/jboss/wildfly/bin/standalone.sh", "-b", "0.0.0.0"]
