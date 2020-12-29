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
            "markdown": "[🌐 KeptnInABox](http://52-88-6-197.nip.io)  -   [🥽 Pipeline Overview](http://52-88-6-197.nip.io/pipeline)  -  [🌉 Keptn Bridge](http://keptn.52-88-6-197.nip.io/bridge) - [👱‍♀️ Davis Assistant](https://assistant.dynatrace.com) - ☄ [unleash server](http://unleash.unleash-dev.52-88-6-197.nip.io)"
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
                "managementZone": null
            },
            "filterConfig": {
                "type": "MIXED",
                "customName": "🏎Running PoDs",
                "defaultName": "Custom chart",
                "chartConfig": {
                    "legendShown": true,
                    "type": "TOP_LIST",
                    "series": [
                        {
                            "metric": "builtin:cloud.kubernetes.namespace.runningPods",
                            "aggregation": "AVG",
                            "percentile": null,
                            "type": "LINE",
                            "entityType": "CLOUD_APPLICATION_NAMESPACE",
                            "dimensions": [
                                {
                                    "id": "0",
                                    "name": "dt.entity.cloud_application_namespace",
                                    "values": [],
                                    "entityDimension": true
                                },
                                {
                                    "id": "1",
                                    "name": "Deployment type",
                                    "values": [],
                                    "entityDimension": false
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
            "name": "Markdown",
            "tileType": "MARKDOWN",
            "configured": true,
            "bounds": {
                "top": 38,
                "left": 0,
                "width": 456,
                "height": 38
            },
            "tileFilter": {
                "timeframe": null,
                "managementZone": null
            },
            "markdown": "Stages: [🛒Carts Development](http://carts.sockshop-dev.52-88-6-197.nip.io/)"
        },
        {
            "name": "",
            "tileType": "SERVICES",
            "configured": true,
            "bounds": {
                "top": 76,
                "left": 0,
                "width": 152,
                "height": 152
            },
            "tileFilter": {
                "timeframe": null,
                "managementZone": null
            },
            "filterConfig": {
                "type": "SERVICE",
                "customName": "Sockshop Development services",
                "defaultName": "Sockshop Development services",
                "chartConfig": {
                    "legendShown": true,
                    "type": "TIMESERIES",
                    "series": [],
                    "resultMetadata": {}
                },
                "filtersPerEntityType": {
                    "SERVICE": {
                        "AUTO_TAGS": [
                            "keptn_stage:dev"
                        ]
                    }
                }
            },
            "chartVisible": true
        },
        {
            "name": "",
            "tileType": "SERVICES",
            "configured": true,
            "bounds": {
                "top": 76,
                "left": 456,
                "width": 152,
                "height": 152
            },
            "tileFilter": {
                "timeframe": null,
                "managementZone": null
            },
            "filterConfig": {
                "type": "SERVICE",
                "customName": "Sockshop Staging services",
                "defaultName": "Sockshop Staging services",
                "chartConfig": {
                    "legendShown": true,
                    "type": "TIMESERIES",
                    "series": [],
                    "resultMetadata": {}
                },
                "filtersPerEntityType": {
                    "SERVICE": {
                        "AUTO_TAGS": [
                            "keptn_stage:staging"
                        ]
                    }
                }
            },
            "chartVisible": true
        },
        {
            "name": "",
            "tileType": "SERVICES",
            "configured": true,
            "bounds": {
                "top": 76,
                "left": 912,
                "width": 152,
                "height": 152
            },
            "tileFilter": {
                "timeframe": null,
                "managementZone": null
            },
            "filterConfig": {
                "type": "SERVICE",
                "customName": "Sockshop Production services",
                "defaultName": "Sockshop Production services",
                "chartConfig": {
                    "legendShown": true,
                    "type": "TIMESERIES",
                    "series": [],
                    "resultMetadata": {}
                },
                "filtersPerEntityType": {
                    "SERVICE": {
                        "AUTO_TAGS": [
                            "keptn_stage:production"
                        ]
                    }
                }
            },
            "chartVisible": true
        },
        {
            "name": "Custom chart",
            "tileType": "CUSTOM_CHARTING",
            "configured": true,
            "bounds": {
                "top": 228,
                "left": 0,
                "width": 456,
                "height": 228
            },
            "tileFilter": {
                "timeframe": null,
                "managementZone": null
            },
            "filterConfig": {
                "type": "MIXED",
                "customName": "Response time",
                "defaultName": "Custom chart",
                "chartConfig": {
                    "legendShown": true,
                    "type": "TIMESERIES",
                    "series": [
                        {
                            "metric": "builtin:service.response.time",
                            "aggregation": "AVG",
                            "percentile": null,
                            "type": "LINE",
                            "entityType": "SERVICE",
                            "dimensions": [
                                {
                                    "id": "0",
                                    "name": "dt.entity.service",
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
                "filtersPerEntityType": {
                    "SERVICE": {
                        "AUTO_TAGS": [
                            "keptn_stage:dev"
                        ]
                    }
                }
            }
        },
        {
            "name": "Custom chart",
            "tileType": "CUSTOM_CHARTING",
            "configured": true,
            "bounds": {
                "top": 228,
                "left": 912,
                "width": 456,
                "height": 228
            },
            "tileFilter": {
                "timeframe": null,
                "managementZone": null
            },
            "filterConfig": {
                "type": "MIXED",
                "customName": "Response time",
                "defaultName": "Custom chart",
                "chartConfig": {
                    "legendShown": true,
                    "type": "TIMESERIES",
                    "series": [
                        {
                            "metric": "builtin:service.response.time",
                            "aggregation": "AVG",
                            "percentile": null,
                            "type": "LINE",
                            "entityType": "SERVICE",
                            "dimensions": [
                                {
                                    "id": "0",
                                    "name": "dt.entity.service",
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
                "filtersPerEntityType": {
                    "SERVICE": {
                        "AUTO_TAGS": [
                            "keptn_stage:production"
                        ]
                    }
                }
            }
        },
        {
            "name": "Custom chart",
            "tileType": "CUSTOM_CHARTING",
            "configured": true,
            "bounds": {
                "top": 76,
                "left": 760,
                "width": 152,
                "height": 152
            },
            "tileFilter": {
                "timeframe": null,
                "managementZone": null
            },
            "filterConfig": {
                "type": "MIXED",
                "customName": "Failures",
                "defaultName": "Custom chart",
                "chartConfig": {
                    "legendShown": true,
                    "type": "SINGLE_VALUE",
                    "series": [
                        {
                            "metric": "builtin:service.errors.total.rate",
                            "aggregation": "AVG",
                            "percentile": null,
                            "type": "LINE",
                            "entityType": "SERVICE",
                            "dimensions": [
                                {
                                    "id": "0",
                                    "name": "dt.entity.service",
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
                "filtersPerEntityType": {
                    "SERVICE": {
                        "AUTO_TAGS": [
                            "keptn_stage:staging"
                        ]
                    }
                }
            }
        },
        {
            "name": "Custom chart",
            "tileType": "CUSTOM_CHARTING",
            "configured": true,
            "bounds": {
                "top": 76,
                "left": 1216,
                "width": 152,
                "height": 152
            },
            "tileFilter": {
                "timeframe": null,
                "managementZone": null
            },
            "filterConfig": {
                "type": "MIXED",
                "customName": "Failures",
                "defaultName": "Custom chart",
                "chartConfig": {
                    "legendShown": true,
                    "type": "SINGLE_VALUE",
                    "series": [
                        {
                            "metric": "builtin:service.errors.total.rate",
                            "aggregation": "AVG",
                            "percentile": null,
                            "type": "LINE",
                            "entityType": "SERVICE",
                            "dimensions": [
                                {
                                    "id": "0",
                                    "name": "dt.entity.service",
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
                "filtersPerEntityType": {
                    "SERVICE": {
                        "AUTO_TAGS": [
                            "keptn_stage:production"
                        ]
                    }
                }
            }
        },
        {
            "name": "Custom chart",
            "tileType": "CUSTOM_CHARTING",
            "configured": true,
            "bounds": {
                "top": 76,
                "left": 304,
                "width": 152,
                "height": 152
            },
            "tileFilter": {
                "timeframe": null,
                "managementZone": null
            },
            "filterConfig": {
                "type": "MIXED",
                "customName": "Failures",
                "defaultName": "Custom chart",
                "chartConfig": {
                    "legendShown": true,
                    "type": "SINGLE_VALUE",
                    "series": [
                        {
                            "metric": "builtin:service.errors.total.rate",
                            "aggregation": "AVG",
                            "percentile": null,
                            "type": "LINE",
                            "entityType": "SERVICE",
                            "dimensions": [
                                {
                                    "id": "0",
                                    "name": "dt.entity.service",
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
                "filtersPerEntityType": {
                    "SERVICE": {
                        "AUTO_TAGS": [
                            "keptn_stage:dev"
                        ]
                    }
                }
            }
        },
        {
            "name": "Custom chart",
            "tileType": "CUSTOM_CHARTING",
            "configured": true,
            "bounds": {
                "top": 76,
                "left": 1064,
                "width": 152,
                "height": 152
            },
            "tileFilter": {
                "timeframe": null,
                "managementZone": null
            },
            "filterConfig": {
                "type": "MIXED",
                "customName": "Response Time",
                "defaultName": "Custom chart",
                "chartConfig": {
                    "legendShown": true,
                    "type": "SINGLE_VALUE",
                    "series": [
                        {
                            "metric": "builtin:service.response.time",
                            "aggregation": "AVG",
                            "percentile": null,
                            "type": "LINE",
                            "entityType": "SERVICE",
                            "dimensions": [
                                {
                                    "id": "0",
                                    "name": "dt.entity.service",
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
                "filtersPerEntityType": {
                    "SERVICE": {
                        "AUTO_TAGS": [
                            "keptn_stage:production"
                        ]
                    }
                }
            }
        },
        {
            "name": "Custom chart",
            "tileType": "CUSTOM_CHARTING",
            "configured": true,
            "bounds": {
                "top": 76,
                "left": 152,
                "width": 152,
                "height": 152
            },
            "tileFilter": {
                "timeframe": null,
                "managementZone": null
            },
            "filterConfig": {
                "type": "MIXED",
                "customName": "Response Time",
                "defaultName": "Custom chart",
                "chartConfig": {
                    "legendShown": true,
                    "type": "SINGLE_VALUE",
                    "series": [
                        {
                            "metric": "builtin:service.response.time",
                            "aggregation": "AVG",
                            "percentile": null,
                            "type": "LINE",
                            "entityType": "SERVICE",
                            "dimensions": [
                                {
                                    "id": "0",
                                    "name": "dt.entity.service",
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
                "filtersPerEntityType": {
                    "SERVICE": {
                        "AUTO_TAGS": [
                            "keptn_stage:dev"
                        ]
                    }
                }
            }
        },
        {
            "name": "Custom chart",
            "tileType": "CUSTOM_CHARTING",
            "configured": true,
            "bounds": {
                "top": 76,
                "left": 608,
                "width": 152,
                "height": 152
            },
            "tileFilter": {
                "timeframe": null,
                "managementZone": null
            },
            "filterConfig": {
                "type": "MIXED",
                "customName": "Response Time",
                "defaultName": "Custom chart",
                "chartConfig": {
                    "legendShown": true,
                    "type": "SINGLE_VALUE",
                    "series": [
                        {
                            "metric": "builtin:service.response.time",
                            "aggregation": "AVG",
                            "percentile": null,
                            "type": "LINE",
                            "entityType": "SERVICE",
                            "dimensions": [
                                {
                                    "id": "0",
                                    "name": "dt.entity.service",
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
                "filtersPerEntityType": {
                    "SERVICE": {
                        "AUTO_TAGS": [
                            "keptn_stage:staging"
                        ]
                    }
                }
            }
        },
        {
            "name": "Markdown",
            "tileType": "MARKDOWN",
            "configured": true,
            "bounds": {
                "top": 38,
                "left": 912,
                "width": 304,
                "height": 38
            },
            "tileFilter": {
                "timeframe": null,
                "managementZone": null
            },
            "markdown": "[🛒Carts Production](http://carts.sockshop-production.52-88-6-197.nip.io)\n"
        },
        {
            "name": "Markdown",
            "tileType": "MARKDOWN",
            "configured": true,
            "bounds": {
                "top": 38,
                "left": 456,
                "width": 304,
                "height": 38
            },
            "tileFilter": {
                "timeframe": null,
                "managementZone": null
            },
            "markdown": "[🛒Carts Staging](http://carts.sockshop-staging.52-88-6-197.nip.io)\n"
        },
        {
            "name": "Custom chart",
            "tileType": "CUSTOM_CHARTING",
            "configured": true,
            "bounds": {
                "top": 456,
                "left": 912,
                "width": 456,
                "height": 228
            },
            "tileFilter": {
                "timeframe": null,
                "managementZone": null
            },
            "filterConfig": {
                "type": "MIXED",
                "customName": "Request count",
                "defaultName": "Custom chart",
                "chartConfig": {
                    "legendShown": true,
                    "type": "TIMESERIES",
                    "series": [
                        {
                            "metric": "builtin:service.requestCount.total",
                            "aggregation": "NONE",
                            "percentile": null,
                            "type": "BAR",
                            "entityType": "SERVICE",
                            "dimensions": [
                                {
                                    "id": "0",
                                    "name": "dt.entity.service",
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
                "filtersPerEntityType": {
                    "SERVICE": {
                        "AUTO_TAGS": [
                            "keptn_stage:production"
                        ]
                    }
                }
            }
        },
        {
            "name": "Custom chart",
            "tileType": "CUSTOM_CHARTING",
            "configured": true,
            "bounds": {
                "top": 456,
                "left": 0,
                "width": 456,
                "height": 228
            },
            "tileFilter": {
                "timeframe": null,
                "managementZone": null
            },
            "filterConfig": {
                "type": "MIXED",
                "customName": "Request count",
                "defaultName": "Custom chart",
                "chartConfig": {
                    "legendShown": true,
                    "type": "TIMESERIES",
                    "series": [
                        {
                            "metric": "builtin:service.requestCount.total",
                            "aggregation": "NONE",
                            "percentile": null,
                            "type": "BAR",
                            "entityType": "SERVICE",
                            "dimensions": [
                                {
                                    "id": "0",
                                    "name": "dt.entity.service",
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
                "filtersPerEntityType": {
                    "SERVICE": {
                        "AUTO_TAGS": [
                            "keptn_stage:dev"
                        ]
                    }
                }
            }
        },
        {
            "name": "Custom chart",
            "tileType": "CUSTOM_CHARTING",
            "configured": true,
            "bounds": {
                "top": 684,
                "left": 0,
                "width": 456,
                "height": 152
            },
            "tileFilter": {
                "timeframe": null,
                "managementZone": null
            },
            "filterConfig": {
                "type": "MIXED",
                "customName": "Failures",
                "defaultName": "Custom chart",
                "chartConfig": {
                    "legendShown": true,
                    "type": "TIMESERIES",
                    "series": [
                        {
                            "metric": "builtin:service.errors.total.rate",
                            "aggregation": "AVG",
                            "percentile": null,
                            "type": "BAR",
                            "entityType": "SERVICE",
                            "dimensions": [
                                {
                                    "id": "0",
                                    "name": "dt.entity.service",
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
                "filtersPerEntityType": {
                    "SERVICE": {
                        "AUTO_TAGS": [
                            "keptn_stage:dev"
                        ]
                    }
                }
            }
        },
        {
            "name": "Custom chart",
            "tileType": "CUSTOM_CHARTING",
            "configured": true,
            "bounds": {
                "top": 684,
                "left": 456,
                "width": 456,
                "height": 152
            },
            "tileFilter": {
                "timeframe": null,
                "managementZone": null
            },
            "filterConfig": {
                "type": "MIXED",
                "customName": "Failures",
                "defaultName": "Custom chart",
                "chartConfig": {
                    "legendShown": true,
                    "type": "TIMESERIES",
                    "series": [
                        {
                            "metric": "builtin:service.errors.total.rate",
                            "aggregation": "AVG",
                            "percentile": null,
                            "type": "BAR",
                            "entityType": "SERVICE",
                            "dimensions": [
                                {
                                    "id": "0",
                                    "name": "dt.entity.service",
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
                "filtersPerEntityType": {
                    "SERVICE": {
                        "AUTO_TAGS": [
                            "keptn_stage:staging"
                        ]
                    }
                }
            }
        },
        {
            "name": "Custom chart",
            "tileType": "CUSTOM_CHARTING",
            "configured": true,
            "bounds": {
                "top": 684,
                "left": 912,
                "width": 456,
                "height": 152
            },
            "tileFilter": {
                "timeframe": null,
                "managementZone": null
            },
            "filterConfig": {
                "type": "MIXED",
                "customName": "Failures",
                "defaultName": "Custom chart",
                "chartConfig": {
                    "legendShown": true,
                    "type": "TIMESERIES",
                    "series": [
                        {
                            "metric": "builtin:service.errors.total.rate",
                            "aggregation": "AVG",
                            "percentile": null,
                            "type": "BAR",
                            "entityType": "SERVICE",
                            "dimensions": [
                                {
                                    "id": "0",
                                    "name": "dt.entity.service",
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
                "filtersPerEntityType": {
                    "SERVICE": {
                        "AUTO_TAGS": [
                            "keptn_stage:production"
                        ]
                    }
                }
            }
        },
        {
            "name": "Markdown",
            "tileType": "MARKDOWN",
            "configured": true,
            "bounds": {
                "top": 0,
                "left": 0,
                "width": 228,
                "height": 38
            },
            "tileFilter": {
                "timeframe": null,
                "managementZone": null
            },
            "markdown": "[📊](#dashboards) \n [📗Keptn.sh](https://keptn.sh/) \n   [🌐ACM](https://www.dynatrace.com/solutions/autonomous-cloud-management/) "
        },
        {
            "name": "Markdown",
            "tileType": "MARKDOWN",
            "configured": true,
            "bounds": {
                "top": 0,
                "left": 912,
                "width": 456,
                "height": 38
            },
            "tileFilter": {
                "timeframe": null,
                "managementZone": null
            },
            "markdown": "💻 SSH access: dynatrace@52-88-6-197.nip.io 🔑=..."
        },
        {
            "name": "Markdown",
            "tileType": "MARKDOWN",
            "configured": true,
            "bounds": {
                "top": 38,
                "left": 1216,
                "width": 152,
                "height": 38
            },
            "tileFilter": {
                "timeframe": null,
                "managementZone": null
            },
            "markdown": "📞👨‍🔧[LiveHelp](livehelp.placeholder)"
        },
        {
            "name": "Markdown",
            "tileType": "MARKDOWN",
            "configured": true,
            "bounds": {
                "top": 0,
                "left": 1368,
                "width": 304,
                "height": 190
            },
            "tileFilter": {
                "timeframe": null,
                "managementZone": null
            },
            "markdown": "Best Practices with Microservices\n\n- [Service Naming Rules](#settings/servicenamingsettings;gf=all)\n-  [ProcessGroup Naming Rules](#settings/pgnamingsettings;gf=all)\n\n\nQuick Integration\n\n-  [API Token](#settings/integration/apikeys;gf=all)\n- [PaaS Token](#settings/integration/paastokens;gf=all)\n- [Problem notifications](#settings/integration/notification;gf=all)\n\n"
        },
        {
            "name": "Custom chart",
            "tileType": "CUSTOM_CHARTING",
            "configured": true,
            "bounds": {
                "top": 228,
                "left": 456,
                "width": 456,
                "height": 228
            },
            "tileFilter": {
                "timeframe": null,
                "managementZone": null
            },
            "filterConfig": {
                "type": "MIXED",
                "customName": "Response time",
                "defaultName": "Custom chart",
                "chartConfig": {
                    "legendShown": true,
                    "type": "TIMESERIES",
                    "series": [
                        {
                            "metric": "builtin:service.response.time",
                            "aggregation": "AVG",
                            "percentile": null,
                            "type": "LINE",
                            "entityType": "SERVICE",
                            "dimensions": [
                                {
                                    "id": "0",
                                    "name": "dt.entity.service",
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
                "filtersPerEntityType": {
                    "SERVICE": {
                        "AUTO_TAGS": [
                            "keptn_stage:staging"
                        ]
                    }
                }
            }
        },
        {
            "name": "Custom chart",
            "tileType": "CUSTOM_CHARTING",
            "configured": true,
            "bounds": {
                "top": 456,
                "left": 456,
                "width": 456,
                "height": 228
            },
            "tileFilter": {
                "timeframe": null,
                "managementZone": null
            },
            "filterConfig": {
                "type": "MIXED",
                "customName": "Request count",
                "defaultName": "Custom chart",
                "chartConfig": {
                    "legendShown": true,
                    "type": "TIMESERIES",
                    "series": [
                        {
                            "metric": "builtin:service.requestCount.total",
                            "aggregation": "NONE",
                            "percentile": null,
                            "type": "BAR",
                            "entityType": "SERVICE",
                            "dimensions": [
                                {
                                    "id": "0",
                                    "name": "dt.entity.service",
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
                "filtersPerEntityType": {
                    "SERVICE": {
                        "AUTO_TAGS": [
                            "keptn_stage:staging"
                        ]
                    }
                }
            }
        },
        {
            "name": "",
            "tileType": "CUSTOM_CHARTING",
            "configured": true,
            "bounds": {
                "top": 456,
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
                "customName": "🧙‍♂️Desired PoDs",
                "defaultName": "Custom chart",
                "chartConfig": {
                    "legendShown": true,
                    "type": "TIMESERIES",
                    "series": [
                        {
                            "metric": "builtin:cloud.kubernetes.workload.desiredPods",
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
                "customName": "🏎Running PoDs",
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