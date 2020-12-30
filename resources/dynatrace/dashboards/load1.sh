#!/bin/bash
source ~/keptn-in-a-box/resources/dynatrace/utils.sh

cp ~/keptn-in-a-box/resources/dynatrace/creds_dt.json .

readCredsFromFile
printVariables

echo $DT_TENANT
echo $DT_API_TOKEN

DT_TENANT=$DT_TENANT
DT_API_TOKEN=$DT_API_TOKEN

DOMAIN=$1
OWNER=$2

curl --location --request POST 'https://'${DT_TENANT}'/api/config/v1/dashboards?Api-Token='${DT_API_TOKEN}'' \
--header 'Content-Type: application/json; charset=utf-8' \
--data-raw '{
    "dashboardMetadata": {
        "name": "☁ Autonomous Cloud Concepts with Keptn",
        "shared": true,
        "owner": "'${OWNER}'",
        "sharingDetails": {
            "linkShared": true,
            "published": true
        },
        "dashboardFilter": {
            "timeframe": ""
        }
    },
    "tiles": [{
        "name": "Markdown",
        "tileType": "MARKDOWN",
        "configured": true,
        "bounds": {
            "top": 0,
            "left": 228,
            "width": 684,
            "height": 38
        },
        "tileFilter": {},
        "markdown": "[\uD83C\uDF10 KeptnInABox](http://'${DOMAIN}')  -    [\uD83C\uDF09 Keptn Bridge](http://keptn.'${DOMAIN}'/bridge) - [\uD83D\uDC71‍♀️ Davis Assistant](https://assistant.dynatrace.com) - ☄ [unleash server](http://unleash.unleash-'${DOMAIN}')"
    }, {
        "name": "",
        "tileType": "CUSTOM_CHARTING",
        "configured": true,
        "bounds": {
            "top": 304,
            "left": 912,
            "width": 304,
            "height": 228
        },
        "tileFilter": {},
        "filterConfig": {
            "type": "MIXED",
            "customName": "\uD83C\uDFCERunning PoDs",
            "defaultName": "Custom chart",
            "chartConfig": {
                "legendShown": true,
                "type": "TOP_LIST",
                "series": [{
                    "metric": "builtin:cloud.kubernetes.namespace.runningPods",
                    "aggregation": "AVG",
                    "type": "LINE",
                    "entityType": "CLOUD_APPLICATION_NAMESPACE",
                    "dimensions": [{
                        "id": "0",
                        "name": "dt.entity.cloud_application_namespace",
                        "values": [],
                        "entityDimension": true
                    }, {
                        "id": "1",
                        "name": "Deployment type",
                        "values": [],
                        "entityDimension": false
                    }],
                    "sortAscending": false,
                    "sortColumn": true,
                    "aggregationRate": "TOTAL"
                }],
                "resultMetadata": {}
            },
            "filtersPerEntityType": {}
        }
    }, {
        "name": "",
        "tileType": "SERVICES",
        "configured": true,
        "bounds": {
            "top": 76,
            "left": 0,
            "width": 152,
            "height": 152
        },
        "tileFilter": {},
        "filterConfig": {
            "type": "SERVICE",
            "customName": "KeptnOrders Staging services",
            "defaultName": "KeptnOrders Staging services",
            "chartConfig": {
                "legendShown": true,
                "type": "TIMESERIES",
                "series": [],
                "resultMetadata": {}
            },
            "filtersPerEntityType": {
                "SERVICE": {
                    "AUTO_TAGS": ["keptn_stage:staging", "keptn_project:keptnorders"]
                }
            }
        },
        "chartVisible": true
    }, {
        "name": "",
        "tileType": "SERVICES",
        "configured": true,
        "bounds": {
            "top": 76,
            "left": 456,
            "width": 152,
            "height": 152
        },
        "tileFilter": {},
        "filterConfig": {
            "type": "SERVICE",
            "customName": "KeptnOrders Production services",
            "defaultName": "KeptnOrders Production services",
            "chartConfig": {
                "legendShown": true,
                "type": "TIMESERIES",
                "series": [],
                "resultMetadata": {}
            },
            "filtersPerEntityType": {
                "SERVICE": {
                    "AUTO_TAGS": ["keptn_stage:production", "keptn_project:keptnorders"]
                }
            }
        },
        "chartVisible": true
    }, {
        "name": "Custom chart",
        "tileType": "CUSTOM_CHARTING",
        "configured": true,
        "bounds": {
            "top": 228,
            "left": 456,
            "width": 456,
            "height": 228
        },
        "tileFilter": {},
        "filterConfig": {
            "type": "MIXED",
            "customName": "Response time",
            "defaultName": "Custom chart",
            "chartConfig": {
                "legendShown": true,
                "type": "TIMESERIES",
                "series": [{
                    "metric": "builtin:service.response.time",
                    "aggregation": "AVG",
                    "type": "LINE",
                    "entityType": "SERVICE",
                    "dimensions": [{
                        "id": "0",
                        "name": "dt.entity.service",
                        "values": [],
                        "entityDimension": true
                    }],
                    "sortAscending": false,
                    "sortColumn": true,
                    "aggregationRate": "TOTAL"
                }],
                "resultMetadata": {}
            },
            "filtersPerEntityType": {
                "SERVICE": {
                    "AUTO_TAGS": ["keptn_stage:production", "keptn_project:keptnorders"]
                }
            }
        }
    }, {
        "name": "Custom chart",
        "tileType": "CUSTOM_CHARTING",
        "configured": true,
        "bounds": {
            "top": 76,
            "left": 304,
            "width": 152,
            "height": 152
        },
        "tileFilter": {},
        "filterConfig": {
            "type": "MIXED",
            "customName": "Failures",
            "defaultName": "Custom chart",
            "chartConfig": {
                "legendShown": true,
                "type": "SINGLE_VALUE",
                "series": [{
                    "metric": "builtin:service.errors.total.rate",
                    "aggregation": "AVG",
                    "type": "LINE",
                    "entityType": "SERVICE",
                    "dimensions": [{
                        "id": "0",
                        "name": "dt.entity.service",
                        "values": [],
                        "entityDimension": true
                    }],
                    "sortAscending": false,
                    "sortColumn": true,
                    "aggregationRate": "TOTAL"
                }],
                "resultMetadata": {}
            },
            "filtersPerEntityType": {
                "SERVICE": {
                    "AUTO_TAGS": ["keptn_stage:staging", "keptn_project:keptnorders"]
                }
            }
        }
    }, {
        "name": "Custom chart",
        "tileType": "CUSTOM_CHARTING",
        "configured": true,
        "bounds": {
            "top": 76,
            "left": 760,
            "width": 152,
            "height": 152
        },
        "tileFilter": {},
        "filterConfig": {
            "type": "MIXED",
            "customName": "Failures",
            "defaultName": "Custom chart",
            "chartConfig": {
                "legendShown": true,
                "type": "SINGLE_VALUE",
                "series": [{
                    "metric": "builtin:service.errors.total.rate",
                    "aggregation": "AVG",
                    "type": "LINE",
                    "entityType": "SERVICE",
                    "dimensions": [{
                        "id": "0",
                        "name": "dt.entity.service",
                        "values": [],
                        "entityDimension": true
                    }],
                    "sortAscending": false,
                    "sortColumn": true,
                    "aggregationRate": "TOTAL"
                }],
                "resultMetadata": {}
            },
            "filtersPerEntityType": {
                "SERVICE": {
                    "AUTO_TAGS": ["keptn_stage:production", "keptn_project:keptnorders"]
                }
            }
        }
    }, {
        "name": "Custom chart",
        "tileType": "CUSTOM_CHARTING",
        "configured": true,
        "bounds": {
            "top": 76,
            "left": 608,
            "width": 152,
            "height": 152
        },
        "tileFilter": {},
        "filterConfig": {
            "type": "MIXED",
            "customName": "Response Time",
            "defaultName": "Custom chart",
            "chartConfig": {
                "legendShown": true,
                "type": "SINGLE_VALUE",
                "series": [{
                    "metric": "builtin:service.response.time",
                    "aggregation": "AVG",
                    "type": "LINE",
                    "entityType": "SERVICE",
                    "dimensions": [{
                        "id": "0",
                        "name": "dt.entity.service",
                        "values": [],
                        "entityDimension": true
                    }],
                    "sortAscending": false,
                    "sortColumn": true,
                    "aggregationRate": "TOTAL"
                }],
                "resultMetadata": {}
            },
            "filtersPerEntityType": {
                "SERVICE": {
                    "AUTO_TAGS": ["keptn_stage:production", "keptn_project:keptnorders"]
                }
            }
        }
    }, {
        "name": "Custom chart",
        "tileType": "CUSTOM_CHARTING",
        "configured": true,
        "bounds": {
            "top": 76,
            "left": 152,
            "width": 152,
            "height": 152
        },
        "tileFilter": {},
        "filterConfig": {
            "type": "MIXED",
            "customName": "Response Time",
            "defaultName": "Custom chart",
            "chartConfig": {
                "legendShown": true,
                "type": "SINGLE_VALUE",
                "series": [{
                    "metric": "builtin:service.response.time",
                    "aggregation": "AVG",
                    "type": "LINE",
                    "entityType": "SERVICE",
                    "dimensions": [{
                        "id": "0",
                        "name": "dt.entity.service",
                        "values": [],
                        "entityDimension": true
                    }],
                    "sortAscending": false,
                    "sortColumn": true,
                    "aggregationRate": "TOTAL"
                }],
                "resultMetadata": {}
            },
            "filtersPerEntityType": {
                "SERVICE": {
                    "AUTO_TAGS": ["keptn_stage:staging", "keptn_project:keptnorders"]
                }
            }
        }
    }, {
        "name": "Markdown",
        "tileType": "MARKDOWN",
        "configured": true,
        "bounds": {
            "top": 38,
            "left": 456,
            "width": 456,
            "height": 38
        },
        "tileFilter": {},
        "markdown": "[KeptnOrders-Production](http://frontend.keptnorders-production.'${DOMAIN}')\n"
    }, {
        "name": "Markdown",
        "tileType": "MARKDOWN",
        "configured": true,
        "bounds": {
            "top": 38,
            "left": 0,
            "width": 456,
            "height": 38
        },
        "tileFilter": {},
        "markdown": "[KeptnOrders-staging](http://frontend.keptnorders-staging.'${DOMAIN}')\n"
    }, {
        "name": "Custom chart",
        "tileType": "CUSTOM_CHARTING",
        "configured": true,
        "bounds": {
            "top": 456,
            "left": 456,
            "width": 456,
            "height": 228
        },
        "tileFilter": {},
        "filterConfig": {
            "type": "MIXED",
            "customName": "Request count",
            "defaultName": "Custom chart",
            "chartConfig": {
                "legendShown": true,
                "type": "TIMESERIES",
                "series": [{
                    "metric": "builtin:service.requestCount.total",
                    "aggregation": "NONE",
                    "type": "BAR",
                    "entityType": "SERVICE",
                    "dimensions": [{
                        "id": "0",
                        "name": "dt.entity.service",
                        "values": [],
                        "entityDimension": true
                    }],
                    "sortAscending": false,
                    "sortColumn": false,
                    "aggregationRate": "TOTAL"
                }],
                "resultMetadata": {}
            },
            "filtersPerEntityType": {
                "SERVICE": {
                    "AUTO_TAGS": ["keptn_stage:production", "keptn_project:keptnorders"]
                }
            }
        }
    }, {
        "name": "Custom chart",
        "tileType": "CUSTOM_CHARTING",
        "configured": true,
        "bounds": {
            "top": 684,
            "left": 0,
            "width": 456,
            "height": 152
        },
        "tileFilter": {},
        "filterConfig": {
            "type": "MIXED",
            "customName": "Failures",
            "defaultName": "Custom chart",
            "chartConfig": {
                "legendShown": true,
                "type": "TIMESERIES",
                "series": [{
                    "metric": "builtin:service.errors.total.rate",
                    "aggregation": "AVG",
                    "type": "BAR",
                    "entityType": "SERVICE",
                    "dimensions": [{
                        "id": "0",
                        "name": "dt.entity.service",
                        "values": [],
                        "entityDimension": true
                    }],
                    "sortAscending": false,
                    "sortColumn": true,
                    "aggregationRate": "TOTAL"
                }],
                "resultMetadata": {}
            },
            "filtersPerEntityType": {
                "SERVICE": {
                    "AUTO_TAGS": ["keptn_stage:staging", "keptn_project:keptnorders"]
                }
            }
        }
    }, {
        "name": "Custom chart",
        "tileType": "CUSTOM_CHARTING",
        "configured": true,
        "bounds": {
            "top": 684,
            "left": 456,
            "width": 456,
            "height": 152
        },
        "tileFilter": {},
        "filterConfig": {
            "type": "MIXED",
            "customName": "Failures",
            "defaultName": "Custom chart",
            "chartConfig": {
                "legendShown": true,
                "type": "TIMESERIES",
                "series": [{
                    "metric": "builtin:service.errors.total.rate",
                    "aggregation": "AVG",
                    "type": "BAR",
                    "entityType": "SERVICE",
                    "dimensions": [{
                        "id": "0",
                        "name": "dt.entity.service",
                        "values": [],
                        "entityDimension": true
                    }],
                    "sortAscending": false,
                    "sortColumn": false,
                    "aggregationRate": "TOTAL"
                }],
                "resultMetadata": {}
            },
            "filtersPerEntityType": {
                "SERVICE": {
                    "AUTO_TAGS": ["keptn_stage:production", "keptn_project:keptnorders"]
                }
            }
        }
    }, {
        "name": "Markdown",
        "tileType": "MARKDOWN",
        "configured": true,
        "bounds": {
            "top": 0,
            "left": 0,
            "width": 228,
            "height": 38
        },
        "tileFilter": {},
        "markdown": "[\uD83D\uDCCA](#dashboards) \n [\uD83D\uDCD7Keptn.sh](https://keptn.sh/) \n   [\uD83C\uDF10ACM](https://www.dynatrace.com/solutions/autonomous-cloud-management/) "
    }, {
        "name": "Markdown",
        "tileType": "MARKDOWN",
        "configured": true,
        "bounds": {
            "top": 0,
            "left": 912,
            "width": 456,
            "height": 38
        },
        "tileFilter": {},
        "markdown": "\uD83D\uDCBB SSH access: ubuntu@'${DOMAIN}' \uD83D\uDD11=..."
    }, {
        "name": "Markdown",
        "tileType": "MARKDOWN",
        "configured": true,
        "bounds": {
            "top": 0,
            "left": 1368,
            "width": 152,
            "height": 38
        },
        "tileFilter": {},
        "markdown": "\uD83D\uDCDE\uD83D\uDC68‍\uD83D\uDD27[LiveHelp](livehelp.placeholder)"
    }, {
        "name": "Markdown",
        "tileType": "MARKDOWN",
        "configured": true,
        "bounds": {
            "top": 76,
            "left": 1216,
            "width": 304,
            "height": 190
        },
        "tileFilter": {},
        "markdown": "Best Practices with Microservices\n\n- [Service Naming Rules](#settings/servicenamingsettings;gf=all)\n-  [ProcessGroup Naming Rules](#settings/pgnamingsettings;gf=all)\n\n\nQuick Integration\n\n-  [API Token](#settings/integration/apikeys;gf=all)\n- [PaaS Token](#settings/integration/paastokens;gf=all)\n- [Problem notifications](#settings/integration/notification;gf=all)\n\n"
    }, {
        "name": "Custom chart",
        "tileType": "CUSTOM_CHARTING",
        "configured": true,
        "bounds": {
            "top": 228,
            "left": 0,
            "width": 456,
            "height": 228
        },
        "tileFilter": {},
        "filterConfig": {
            "type": "MIXED",
            "customName": "Response time",
            "defaultName": "Custom chart",
            "chartConfig": {
                "legendShown": true,
                "type": "TIMESERIES",
                "series": [{
                    "metric": "builtin:service.response.time",
                    "aggregation": "AVG",
                    "type": "LINE",
                    "entityType": "SERVICE",
                    "dimensions": [{
                        "id": "0",
                        "name": "dt.entity.service",
                        "values": [],
                        "entityDimension": true
                    }],
                    "sortAscending": false,
                    "sortColumn": false,
                    "aggregationRate": "TOTAL"
                }],
                "resultMetadata": {}
            },
            "filtersPerEntityType": {
                "SERVICE": {
                    "AUTO_TAGS": ["keptn_stage:staging", "keptn_project:keptnorders"]
                }
            }
        }
    }, {
        "name": "Custom chart",
        "tileType": "CUSTOM_CHARTING",
        "configured": true,
        "bounds": {
            "top": 456,
            "left": 0,
            "width": 456,
            "height": 228
        },
        "tileFilter": {},
        "filterConfig": {
            "type": "MIXED",
            "customName": "Request count",
            "defaultName": "Custom chart",
            "chartConfig": {
                "legendShown": true,
                "type": "TIMESERIES",
                "series": [{
                    "metric": "builtin:service.requestCount.total",
                    "aggregation": "NONE",
                    "type": "BAR",
                    "entityType": "SERVICE",
                    "dimensions": [{
                        "id": "0",
                        "name": "dt.entity.service",
                        "values": [],
                        "entityDimension": true
                    }],
                    "sortAscending": false,
                    "sortColumn": true,
                    "aggregationRate": "TOTAL"
                }],
                "resultMetadata": {}
            },
            "filtersPerEntityType": {
                "SERVICE": {
                    "AUTO_TAGS": ["keptn_stage:staging", "keptn_project:keptnorders"]
                }
            }
        }
    }, {
        "name": "",
        "tileType": "CUSTOM_CHARTING",
        "configured": true,
        "bounds": {
            "top": 532,
            "left": 912,
            "width": 304,
            "height": 228
        },
        "tileFilter": {},
        "filterConfig": {
            "type": "MIXED",
            "customName": "\uD83E\uDDD9‍♂️Desired PoDs",
            "defaultName": "Custom chart",
            "chartConfig": {
                "legendShown": true,
                "type": "SINGLE_VALUE",
                "series": [{
                    "metric": "builtin:cloud.kubernetes.workload.desiredPods",
                    "aggregation": "SUM_DIMENSIONS",
                    "type": "BAR",
                    "entityType": "CLOUD_APPLICATION",
                    "dimensions": [],
                    "sortAscending": false,
                    "sortColumn": true,
                    "aggregationRate": "TOTAL"
                }],
                "resultMetadata": {}
            },
            "filtersPerEntityType": {}
        }
    }, {
        "name": "",
        "tileType": "CUSTOM_CHARTING",
        "configured": true,
        "bounds": {
            "top": 760,
            "left": 912,
            "width": 304,
            "height": 228
        },
        "tileFilter": {},
        "filterConfig": {
            "type": "MIXED",
            "customName": "\uD83C\uDFCERunning PoDs",
            "defaultName": "Custom chart",
            "chartConfig": {
                "legendShown": true,
                "type": "SINGLE_VALUE",
                "series": [{
                    "metric": "builtin:cloud.kubernetes.workload.runningPods",
                    "aggregation": "SUM_DIMENSIONS",
                    "type": "BAR",
                    "entityType": "CLOUD_APPLICATION",
                    "dimensions": [],
                    "sortAscending": false,
                    "sortColumn": true,
                    "aggregationRate": "TOTAL"
                }],
                "resultMetadata": {}
            },
            "filtersPerEntityType": {}
        }
    }, {
        "name": "Custom chart",
        "tileType": "CUSTOM_CHARTING",
        "configured": true,
        "bounds": {
            "top": 76,
            "left": 912,
            "width": 304,
            "height": 228
        },
        "tileFilter": {},
        "filterConfig": {
            "type": "MIXED",
            "customName": "Pods",
            "defaultName": "Custom chart",
            "chartConfig": {
                "legendShown": true,
                "type": "PIE",
                "series": [{
                    "metric": "builtin:cloud.kubernetes.workload.pods",
                    "aggregation": "AVG",
                    "type": "LINE",
                    "entityType": "CLOUD_APPLICATION",
                    "dimensions": [{
                        "id": "1",
                        "name": "Pod phase",
                        "values": [],
                        "entityDimension": false
                    }],
                    "sortAscending": false,
                    "sortColumn": true,
                    "aggregationRate": "TOTAL"
                }],
                "resultMetadata": {
                    "null¦Pod phase»Running»falsebuiltin:cloud.kubernetes.workload.pods|AVG|TOTAL|LINE|CLOUD_APPLICATION": {
                        "lastModified": 1609338381718,
                        "customColor": "#64bd64"
                    }
                }
            },
            "filtersPerEntityType": {}
        }
    }, {
        "name": "Markdown",
        "tileType": "MARKDOWN",
        "configured": true,
        "bounds": {
            "top": 38,
            "left": 912,
            "width": 304,
            "height": 38
        },
        "tileFilter": {},
        "markdown": "[Kubernetes](http://kubernetes.'${DOMAIN}'/)\n"
    }]
}'