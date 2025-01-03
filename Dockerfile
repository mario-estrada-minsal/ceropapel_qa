# Imagen base UBI8 minimalista
FROM registry.access.redhat.com/ubi8/ubi:latest

USER root

# Instalar Java 8 usando UBI
RUN yum install -y java-1.8.0-openjdk curl unzip && \
    yum clean all

# Definir correctamente JAVA_HOME y PATH
ENV JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk
ENV PATH=$JAVA_HOME/bin:$PATH

# Descargar e instalar WildFly
ENV WILDFLY_VERSION=26.1.2.Final
ENV WILDFLY_HOME=/opt/wildfly
RUN curl -L https://github.com/wildfly/wildfly/releases/download/$WILDFLY_VERSION/wildfly-$WILDFLY_VERSION.zip -o /tmp/wildfly.zip && \
    unzip /tmp/wildfly.zip -d /opt/ && \
    mv /opt/wildfly-$WILDFLY_VERSION $WILDFLY_HOME && \
    rm /tmp/wildfly.zip

# Cambiar permisos al usuario no root
RUN chown -R 1001:1001 $WILDFLY_HOME

USER 1001

# Ejecutar WildFly usando la ruta correcta
CMD ["/opt/wildfly/bin/standalone.sh", "-b", "0.0.0.0"]
