# Imagen base UBI8 con WildFly
FROM registry.access.redhat.com/ubi8/ubi:latest

USER root

# Instalar Java 8, curl y unzip
RUN yum install -y java-1.8.0-openjdk curl unzip && \
    yum clean all

# Definir JAVA_HOME y PATH correctamente
ENV JAVA_HOME=/usr/lib/jvm/jre-1.8.0-openjdk
ENV PATH=$JAVA_HOME/bin:$PATH

# Descargar e instalar WildFly
ENV WILDFLY_VERSION=26.1.2.Final
ENV WILDFLY_HOME=/opt/wildfly
RUN curl -L https://github.com/wildfly/wildfly/releases/download/$WILDFLY_VERSION/wildfly-$WILDFLY_VERSION.zip -o /tmp/wildfly.zip && \
    unzip /tmp/wildfly.zip -d /opt/ && \
    mv /opt/wildfly-$WILDFLY_VERSION $WILDFLY_HOME && \
    rm /tmp/wildfly.zip

# Agregar el módulo de PostgreSQL al contenedor
RUN mkdir -p $WILDFLY_HOME/modules/system/layers/base/org/postgresql/main/ && \
    curl -o $WILDFLY_HOME/modules/system/layers/base/org/postgresql/main/postgresql-42.7.0.jar \
    https://jdbc.postgresql.org/download/postgresql-42.7.0.jar && \
    echo '<?xml version="1.0" encoding="UTF-8"?> \
    <module xmlns="urn:jboss:module:1.1" name="org.postgresql"> \
        <resources> \
            <resource-root path="postgresql-42.7.0.jar"/> \
        </resources> \
        <dependencies> \
            <module name="javax.api"/> \
            <module name="javax.transaction.api"/> \
        </dependencies> \
    </module>' > $WILDFLY_HOME/modules/system/layers/base/org/postgresql/main/module.xml

# Registrar el driver PostgreSQL usando la CLI de WildFly
RUN $WILDFLY_HOME/bin/standalone.sh & \
    sleep 10 && \
    $WILDFLY_HOME/bin/jboss-cli.sh --connect --commands=
    "module add --name=org.postgresql --resources=$WILDFLY_HOME/modules/system/layers/base/org/postgresql/main/postgresql-42.7.0.jar --dependencies=javax.api,javax.transaction.api", \
    "/subsystem=datasources/jdbc-driver=postgresql:add(driver-name=postgresql, driver-module-name=org.postgresql, driver-class-name=org.postgresql.Driver)" && \
    pkill java

# Cambiar permisos para usuario no root
RUN chown -R 1000:1000 $WILDFLY_HOME

USER 1000

# Exponer puertos para administración y aplicación
EXPOSE 8080 9990

# Ejecutar WildFly
CMD ["/opt/wildfly/bin/standalone.sh", "-b", "0.0.0.0"]
