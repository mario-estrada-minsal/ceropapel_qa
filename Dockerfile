# Imagen base UBI8 minimalista
FROM registry.access.redhat.com/ubi8/ubi:latest

USER root

# Instalar Java 8 y herramientas básicas
RUN yum install -y java-1.8.0-openjdk wget unzip && \
    yum clean all

# Descargar e instalar WildFly 26
ENV WILDFLY_VERSION=26.1.2.Final
ENV WILDFLY_HOME=/opt/wildfly

RUN wget https://github.com/wildfly/wildfly/releases/download/$WILDFLY_VERSION/wildfly-$WILDFLY_VERSION.zip -O /tmp/wildfly.zip && \
    unzip /tmp/wildfly.zip -d /opt/ && \
    mv /opt/wildfly-$WILDFLY_VERSION $WILDFLY_HOME && \
    rm /tmp/wildfly.zip

# Cambiar permisos y propietario
RUN chown -R 1001:1001 $WILDFLY_HOME

# Cambiar al usuario no root
USER 1001

# Establecer JAVA_HOME y añadir al PATH
ENV JAVA_HOME=/usr/lib/jvm/java-1.8.0
ENV PATH=$JAVA_HOME/bin:$PATH

# Ejecutar WildFly
CMD ["/opt/wildfly/bin/standalone.sh", "-b", "0.0.0.0"]
