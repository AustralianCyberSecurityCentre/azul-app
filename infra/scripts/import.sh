#!/bin/bash
# From a remote pod, dump keycloak configs to json, including client secrets.
# The UI button for exporting realms does not include secrets.
# May be incompatible with Keycloak 23+

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

kubectl exec --stdin --tty --namespace keycloak \
    -f $DIR/keycloak-deployment.yaml -- \
    /opt/jboss/keycloak/bin/standalone.sh \
        -Djboss.socket.binding.port-offset=110 \
        -Dkeycloak.migration.action=import \
        -Dkeycloak.migration.provider=singleFile \
        -Dkeycloak.migration.realmName=azul \
        -Dkeycloak.migration.strategy=OVERWRITE_EXISTING \
        -Dkeycloak.migration.file=/tmp/cfg/azul-realm.json