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
  --env 'constraint:serverclass==gateway' \
  --env 'KEYCLOAK_USER_FILE=/run/secrets/keycloak_user' \
  --env 'KEYCLOAK_PASSWORD_FILE=/run/secrets/keycloak_password' \
  --env 'DB_VENDOR=mariadb' \
  --env 'DB_ADDR=galera_node' \
  --env 'DB_PORT=3306' \
  --env 'DB_DATABASE=keycloak' \
  --env 'DB_USER_FILE=/run/secrets/keycloak_db_user' \
  --env 'DB_PASSWORD_FILE=/run/secrets/keycloak_db_password' \
  --env 'PROXY_ADDRESS_FORWARDING=true' \
  --env 'KEYCLOAK_HOSTNAME=openid.bremersee.org' \
  --env 'KEYCLOAK_HTTP_PORT=80' \
  --env 'KEYCLOAK_HTTPS_PORT=443' \
  --env 'KEYCLOAK_LOGLEVEL=INFO' \
  --env 'ROOT_LOGLEVEL=INFO' \
  --env 'JGROUPS_DISCOVERY_PROTOCOL=JDBC_PING' \
  --env 'JGROUPS_DISCOVERY_PROPERTIES=datasource_jndi_name=java:jboss/datasources/KeycloakDS' \
  --env 'CACHE_OWNERS_COUNT=2' \
  bremersee/openid:latest
