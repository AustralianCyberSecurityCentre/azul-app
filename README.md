# Azul base app

This repo contains the Helm Charts for Azul.

## Validation

[json schema](https://json-schema.org/understanding-json-schema/reference) validates the `values.yaml` entries.
Azul helm charts use the [draft-07](https://json-schema.org/draft-07/schema)
schema version.

This is the latest release that Helm supports (see[here](https://github.com/helm/helm/pull/11340)
and [here](https://github.com/helm/helm/issues/10732)) and vscode knows how to parse.

## ./azul

The main Helm Chart for Azul.
Ensure you read and understand the contents of `values.yaml`.

You'll need to create your own `values.yaml` with content relevant to your specific deployment environment.

### Redis

Redis is integrated into the Azul chart as its very unlikely you'll ever want to run redis elsewhere.

Redis can be updated by updating the image in the images list.

## ./infra

The Helm chart to deploy optional infrastructure related components of Azul is located in `infra`.
This allows installation of services that Azul relies on such as Opensearch and Minio.

In production it is recommended that large components such as Opensearch, Kafka and Minio
be installed outside the K8s cluster on dedicated hardware or an equivalent managed service by a provider is used.

Currently this includes:

- Opensearch
- Minio
- Redis
- Keycloak
- Kafka

Data safety is not currently guaranteed between different versions of the `infra` chart.
PVCs may be deleted during an upgrade.
Please ensure all required data is backed up via the Azul disaster recovery module or otherwise.
DO NOT back data up to the Minio cluster provisioned by this chart.

## Disaster Recovery

The recovery service backs up Azul binary events and streams to S3.
This requires an external s3-compatible service, ideally running outside of the Azul infrastructure.

Backup and restore can be configured in the main `azul/values.yaml` file, disabled by default.

Please see Azul documentation for further information on configuring a backup and performing a restore.
Also reference `.recovery` in `values.yaml` for specific values that can be configured.

### Backup

Backup runs like a plugin taking in all kafka events and then downloading all their binary streams, it then saves this data to an S3 server. This is a continuous backup of current state and will never 'finish'.
Note - avoid deleting this pod as deletions will cause data not to be backed up.

### Restore

Runs as a k8s 'job'. It will restore all raw stream data first and then restore all the kafka events.

Once restore is successful, remember to configure the backup to run instead.
You should configure backup to a different bucket and delete the old bucket.


## Networking port allocations

### Port Purposes

To keep the system more secure specific ports are allocated for specific purposes.

Here is the table of values

### Azul Ports

| Port      | Pod/Service                           | Description                                                   | Flow Direction |
|-----------|---------------------------------------|---------------------------------------------------------------|----------------|
| 53        | All                                   | DNS                                                           | Egress         |
| 80        | Internet                              | Connecting out to internet services                           | Egress         |
| 443       | Internet                              | Connecting out to internet services                           | Egress         |
| 3100      | Audit Forwarder                       | Connection outbound to Loki for log scraping                  | Egress         |
| 3100      | PromTail Side car                     | Connection outbound to Loki for log scraping                  | Egress         |
| 6379      | Redis                                 | Connections to and from Redis                                 | Both           |
| 8000      | RestAPI                               | Inbound connections to the RestAPI                            | Ingress        |
| 8080      | Docs,WebUI                            | Inbound connections to the WebUI/Docs                         | Ingress        |
| 8090      | Scaler                                | Inbound connections from Keda to Scaler.                      | Ingress        |
| 8111      | Dispatcher,lost-tasks                 | Internal communication between dispatcher and everything else | Both           |
| 8850      | Assemblyline Receiver                 | Receive data from Assemblyline and hosts stats                | Ingress        |
| 8851      | Smart string finder                   | Filter strings for restapi and hosts stats                    | Both           |
| 8852      | Retrohunt-server                      | Hosts the retrohunt server                                    | Ingress        |
| 8853      | NSRL lookup Server                    | Hosts the Nsrl lookup server                                  | Ingress        |
| 8854      | Virustotal Server                     | Hosts the Virustotal push server.                             | Ingress        |
| 8855      | Audit Forwarder                       | Audit forwarder health probe.                                 | Ingress        |
| 8900      | Scaler                                | Outbound connection to burrow from scaler.                    | Egress         |
| 8900      | Burrow,Stats,Ingestors,age-off,Backup | Default Prometheus statistic collection                       | Ingress        |
| 8900-8950 | Retrohunt Workers                     | Extra ports for statistic collection                          | Ingress        |
| 9000      | Minio                                 | For connection to Minio S3 Storage                            | Egress         |
| 9091      | Prometheus Push Gateway               | Connection to Prometheus pushgateway for stat collection      | Egress         |
| 9090-9093 | Kafka                                 | Allow connections out to Kafka                                | Egress         |
| 9200-9700 | Opensearch                            | Allow connections out to Opensearch                           | Egress         |
| 9998      | Tika Side cart                        | Allow connection between the Tika plugin and it's sidecar     | Both           |

## Licensing

See the license.md file for Azul licensing details.

This repository includes additional pre-packaged charts which are included for simplicity, and are distributed under their respective licenses:

- kube-prometheus-stack: Apache 2.0
- loki: AGPL 3.0
- prometheus-blackbox-exporter: Apache 2.0
- prometheus-pushgateway: Apache 2.0

