#!/usr/bin/env sh
# Clustering see:
# - https://www.keycloak.org/2019/08/keycloak-jdbc-ping
# - https://www.techrunnr.com/keycloak-cluster-using-docker-swarm/
# - https://github.com/fit2anything/keycloak-cluster-setup-and-configuration
docker service create \
  --replicas 2 \
  --name keycloak \
  --network proxy \
  --publish=58880:8080 \
  --secret keycloak_user \
  --secret keycloak_password \
  --secret keycloak_db_user \
  --secret keycloak_db_password \
  --restart-delay 10s \
  --restart-max-attempts 10 \
  --restart-window 60s \
  --constraint node.labels.primary==true \
  -e 'constraint:serverclass==gateway' \
  -e KEYCLOAK_USER_FILE='/run/secrets/keycloak_user' \
  -e KEYCLOAK_PASSWORD_FILE='/run/secrets/keycloak_password' \
  -e DB_VENDOR='mariadb' \
  -e DB_ADDR='galera_node' \
  -e DB_PORT='3306' \
  -e DB_DATABASE='keycloak' \
  -e DB_USER_FILE='/run/secrets/keycloak_db_user' \
  -e DB_PASSWORD_FILE='/run/secrets/keycloak_db_password' \
  -e PROXY_ADDRESS_FORWARDING='true' \
  -e KEYCLOAK_HOSTNAME='openid.bremersee.org' \
  -e KEYCLOAK_HTTP_PORT='80' \
  -e KEYCLOAK_HTTPS_PORT='443' \
  -e KEYCLOAK_LOGLEVEL='INFO' \
  -e ROOT_LOGLEVEL='INFO' \
  -e JGROUPS_DISCOVERY_PROTOCOL='JDBC_PING' \
  -e JGROUPS_DISCOVERY_PROPERTIES='datasource_jndi_name=java:jboss/datasources/KeycloakDS' \
  -e CACHE_OWNERS_COUNT='2' \
  bremersee/openid:latest
