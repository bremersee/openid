FROM jboss/keycloak:9.0.3
MAINTAINER Christian Bremer <bremersee@googlemail.com>
ADD cli/TCPPING.cli /opt/jboss/tools/cli/jgroups/discovery/
ADD cli/JDBC_PING.cli /opt/jboss/tools/cli/jgroups/discovery/
