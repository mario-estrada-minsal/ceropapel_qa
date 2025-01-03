FROM registry.access.redhat.com/ubi8/ubi:latest

USER root

# Instalar Java 8 usando UBI
RUN yum install -y java-1.8.0-openjdk

USER 1001
CMD ["/opt/jboss/wildfly/bin/standalone.sh", "-b", "0.0.0.0"]
