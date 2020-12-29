#!/bin/bash
source ~/keptn-in-a-box/resources/dynatrace/utils.sh

cp ~/keptn-in-a-box/resources/dynatrace/creds_dt.json .

readCredsFromFile
printVariables

echo $DT_TENANT
echo $DT_API_TOKEN

DT_TENANT=$DT_TENANT
DT_API_TOKEN=$DT_API_TOKEN

curl --location --request POST 'https://'${DT_TENANT}'/api/config/v1/dashboards?Api-Token='${DT_API_TOKEN}'' \
--header 'Content-Type: application/json; charset=utf-8' \
--header 'Cookie: SRV=server1; apmsessionid=node01agda24vqgd8u11wwko4qyhaiw10949.node0' \
--data-raw '{
    "dashboardMetadata": {
        "name": "☁ Autonomous Cloud Concepts with Keptn",
        "shared": true,
        "sharingDetails": {
            "linkShared": true,
            "published": false
        },
        "dashboardFilter": {
            "timeframe": "",
            "managementZone": null
        }
    },
    "tiles": [
        {
            "name": "Markdown",
            "tileType": "MARKDOWN",
            "configured": true,
            "bounds": {
                "top": 0,
                "left": 228,
                "width": 684,
                "height": 38
            },
            "tileFilter": {
                "timeframe": null,
                "managementZone": null
            },
            "markdown": "[🌐 KeptnInABox](http://52-88-6-197.nip.io)  -   [🥽 Pipeline Overview](http://52-88-6-197.nip.io/pipeline)  -  [  Keptn Bridge](http://keptn.52-88-6-197.nip.io/bridge) - [👱<200d>♀️ Davis Assistant](https://assistant.dynatrace.com) - ☄ [unleash server](http://unleash.unleash-dev.52-88-6-197.nip.io)"
        },
        {
            "name": "",
            "tileType": "CUSTOM_CHARTING",
            "configured": true,
            "bounds": {
                "top": 190,
                "left": 1368,
                "width": 304,
                "height": 266
            },
            "tileFilter": {
                "timeframe": null,
"load1.sh" 1187L, 42139C                                                                                                                                                                                 22,9          Top
                                }
                            ],
                            "sortAscending": false,
                            "sortColumn": true,
                            "aggregationRate": "TOTAL"
                        }
                    ],
                    "resultMetadata": {}
                },
                "filtersPerEntityType": {}
            }
        },
        {
            "name": "",
            "tileType": "CUSTOM_CHARTING",
            "configured": true,
            "bounds": {
                "top": 646,
                "left": 1368,
                "width": 304,
                "height": 190
            },
            "tileFilter": {
                "timeframe": null,
                "managementZone": null
            },
            "filterConfig": {
                "type": "MIXED",
                "customName": "🏎 Running PoDs",
                "defaultName": "Custom chart",
                "chartConfig": {
                    "legendShown": true,
                    "type": "TIMESERIES",
                    "series": [
                        {
                            "metric": "builtin:cloud.kubernetes.workload.runningPods",
                            "aggregation": "AVG",
                            "percentile": null,
                            "type": "BAR",
                            "entityType": "CLOUD_APPLICATION",
                            "dimensions": [
                                {
                                    "id": "0",
                                    "name": "dt.entity.cloud_application",
                                    "values": [],
                                    "entityDimension": true
                                }
                            ],
                            "sortAscending": false,
                            "sortColumn": true,
                            "aggregationRate": "TOTAL"
                        }
                    ],
                    "resultMetadata": {}
                },
                "filtersPerEntityType": {}
            }
        }
    ]
}'