# Source Controlled Dashboards

Source controlling Grafana dashboards.

## Dashboards

Dashboards are located in the dashboard folder, to add a new dashboard simply export your dashboard from
Grafana as json, and paste it into a file in one of the folders.

Each folder is a Configmap and configMaps can't exceed 1MiB or they'll fail to deploy.
This is why there are multiple folders with the same name and an additional digit.

If you need to create a new folder ensure you also update `azul/templates/dashboards.yaml`
It needs to be updated to take all of the yaml files from the new folder and create a Configmap.

### Dashboard edits

If you are just editing a dashboard simply copy the dashboard in the Grafana UI and make the necessary changes.
You then export the dashboard as json and paste it over the old dashboard file.
Ensure you pay careful attention to the `title`, `time` and `uid` and only change them if you actually intended to.

## Normalising the datasource

At the time of writing this, we're only using 1 Prometheus datasource, change if necessary.

By default the datasource is Prometheus and when a new dashboard panel is created it will automatically use this.
Configurations have been deployed to make the default datasource's UID 'Prometheus'

Make sure that your dashboards are pointing to the correct datasource:

- Click the settings cogwheel in the top right hand corner,
 -Click 'JSON Model' in the left pane,
- Ensure the JSON is reporting the correct 'Prometheus' Datasource (don't change the "-- Grafana --" entry),
- Click 'Save change' & 'Save dashboard'.

## Alerts and Notifiers

We use multiple notifiers and `alert rules`.

To update them you need to go to the `Alerting -> Alert Rules` section of the Grafana UI.

You can then modify the rules you need to (you will likely have to make a copy of the existing rules)

Once you are done export the `Alert Rule` and place the exported json into the appropriate file within `azul/monitoring/alerts/*.yaml`. The files are named based on the receiver they are using.

The files contain the associated `rules:`, if you add a new file remeber to update `azul/templates/monitoring/dashboards.yaml`

Remember to put it under the appropriate folder that corresponds to the interval you want.
