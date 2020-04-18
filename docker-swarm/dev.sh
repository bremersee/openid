#!/usr/bin/env sh
docker service create \
  --replicas 1 \
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
  --constraint node.labels.keycloak==true \
  -e 'constraint:serverclass==gateway' \
  -e KEYCLOAK_USER_FILE='/run/secrets/keycloak_user' \
  -e KEYCLOAK_PASSWORD_FILE='/run/secrets/keycloak_password' \
  -e DB_VENDOR='mariadb' \
  -e DB_ADDR='galera-node' \
  -e DB_PORT='3306' \
  -e DB_DATABASE='keycloak' \
  -e DB_USER_FILE='/run/secrets/keycloak_db_user' \
  -e DB_PASSWORD_FILE='/run/secrets/keycloak_db_password' \
  -e PROXY_ADDRESS_FORWARDING='true' \
  -e KEYCLOAK_HOSTNAME='openid.dev.bremersee.org' \
  -e KEYCLOAK_HTTP_PORT='80' \
  -e KEYCLOAK_HTTPS_PORT='443' \
  -e KEYCLOAK_LOGLEVEL='INFO' \
  -e ROOT_LOGLEVEL='INFO' \
  bremersee/openid:snapshot
