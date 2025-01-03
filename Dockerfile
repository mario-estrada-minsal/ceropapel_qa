FROM quay.io/wildfly/wildfly:26.1.2.Final

USER root

# Reemplazar repositorios con CentOS Vault
RUN sed -i 's|mirrorlist=http://mirrorlist.centos.org|#mirrorlist=http://mirrorlist.centos.org|' /etc/yum.repos.d/CentOS-Base.repo && \
    sed -i 's|#baseurl=http://vault.centos.org|baseurl=http://vault.centos.org|' /etc/yum.repos.d/CentOS-Base.repo

# Instalar Java 8 después de corregir repositorios
RUN yum clean all && yum install -y java-1.8.0-openjdk

USER 1001
CMD ["/opt/jboss/wildfly/bin/standalone.sh", "-b", "0.0.0.0"]
