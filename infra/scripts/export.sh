#!/bin/bash
# From a remote pod, dump keycloak configs to json, including client secrets.
# The UI button for exporting realms does not include secrets.
# May be incompatible with Keycloak 23+

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# dump to remote file
kubectl exec --stdin --tty --namespace keycloak \
    -f $DIR/keycloak-deployment.yaml -- \
        bash -c "cp /export-remote.sh /tmp/export-remote.sh && \
        chmod +x /tmp/export-remote.sh && /tmp/export-remote.sh"

# copy to local file
kubectl exec --stdin --tty --namespace keycloak \
    -f $DIR/keycloak-deployment.yaml -- \
        cat /tmp/realms-export-single-file.json > $DIR/export.json
