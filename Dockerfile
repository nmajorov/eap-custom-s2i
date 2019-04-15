FROM registry.redhat.io/jboss-eap-7/eap72-openshift:latest

ENV TZ Europe/Amsterdam

COPY s2i/bin/run   /usr/local/s2i/run
COPY s2i/bin/datasource.sh    $JBOSS_HOME/bin/launch/datasource.sh
COPY s2i/bin/tx-datasource.sh $JBOSS_HOME/bin/launch/tx-datasource.sh


ADD modules/com/    /opt/eap/modules/com/


LABEL com.redhat.deployments-dir="/opt/eap/standalone/deployments" \
      io.k8s.description="Vladi  EAP 7.2" \
      io.k8s.display-name="Vladi JBoss 7.2" \
      io.openshift.expose-services="8080:http" \
      io.openshift.s2i.scripts-url="image:///usr/local/s2i" \
      io.openshift.tags="builder,javaee,eap,eap6" \
      org.jboss.deployments-dir="/opt/eap/standalone/deployments"
