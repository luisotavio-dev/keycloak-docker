FROM quay.io/keycloak/keycloak:26.1.4 AS builder

ARG KC_BOOTSTRAP_ADMIN_PASSWORD KC_BOOTSTRAP_ADMIN_USERNAME KC_DB KC_DB_PASSWORD KC_DB_POOL_MIN_SIZE KC_DB_URL KC_DB_USERNAME KC_FEATURES KC_HEALTH_ENABLED KC_HOSTNAME KC_HOSTNAME_STRICT_HTTPS KC_HTTP_ENABLED KC_HTTP_PORT KC_METRICS_ENABLED KC_PROXY KC_PROXY_ADDRESS_FORWARDING KC_PROXY_HEADERS

#ADD --chown=keycloak:keycloak https://github.com/klausbetz/apple-identity-provider-keycloak/releases/download/1.7.1/apple-identity-provider-1.7.1.jar /opt/keycloak/providers/apple-identity-provider-1.7.1.jar
#ADD --chown=keycloak:keycloak https://github.com/wadahiro/keycloak-discord/releases/download/v0.5.0/keycloak-discord-0.5.0.jar /opt/keycloak/providers/keycloak-discord-0.5.0.jar
COPY /theme/keywind /opt/keycloak/themes/keywind

RUN /opt/keycloak/bin/kc.sh build

FROM quay.io/keycloak/keycloak:26.1.4

COPY java.config /etc/crypto-policies/back-ends/java.config

COPY --from=builder /opt/keycloak/ /opt/keycloak/

ENTRYPOINT ["/opt/keycloak/bin/kc.sh"]

# CMD ["start", "--optimized", "--import-realm"]
CMD ["start-dev", "--import-realm"]
