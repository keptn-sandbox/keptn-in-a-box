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
        "name": "\uD83D\uDCCA Performance Test Dashboard with Transaction Steps & SLOs",
        "shared": false,
        "owner": "'${OWNER}'",
        "sharingDetails": {
            "linkShared": true,
            "published": false
        },
         "dashboardFilter": {
            "timeframe": "-30m",
            "managementZone": {
                "id": "8449138348211438023",
                "name": "Keptn: keptnorders staging"
            }
        },
        "tags": [" Performance Test"]
    },
    "tiles": [{
        "name": "Custom chart",
        "tileType": "CUSTOM_CHARTING",
        "configured": true,
        "bounds": {
            "top": 1786,
            "left": 190,
            "width": 494,
            "height": 304
        },
        "tileFilter": {},
        "filterConfig": {
            "type": "MIXED",
            "customName": "Host - CPU usage %",
            "defaultName": "Custom chart",
            "chartConfig": {
                "legendShown": true,
                "type": "TIMESERIES",
                "series": [{
                    "metric": "builtin:host.cpu.usage",
                    "aggregation": "AVG",
                    "type": "LINE",
                    "entityType": "HOST",
                    "dimensions": [{
                        "id": "0",
                        "name": "dt.entity.host",
                        "values": [],
                        "entityDimension": true
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
        "name": "Custom chart",
        "tileType": "CUSTOM_CHARTING",
        "configured": true,
        "bounds": {
            "top": 1482,
            "left": 190,
            "width": 494,
            "height": 304
        },
        "tileFilter": {},
        "filterConfig": {
            "type": "MIXED",
            "customName": "Process - CPU usage %",
            "defaultName": "Custom chart",
            "chartConfig": {
                "legendShown": true,
                "type": "TIMESERIES",
                "series": [{
                    "metric": "builtin:tech.generic.cpu.usage",
                    "aggregation": "AVG",
                    "type": "LINE",
                    "entityType": "PROCESS_GROUP_INSTANCE",
                    "dimensions": [{
                        "id": "0",
                        "name": "dt.entity.process_group_instance",
                        "values": [],
                        "entityDimension": true
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
        "name": "Custom chart",
        "tileType": "CUSTOM_CHARTING",
        "configured": true,
        "bounds": {
            "top": 1786,
            "left": 684,
            "width": 494,
            "height": 304
        },
        "tileFilter": {},
        "filterConfig": {
            "type": "MIXED",
            "customName": "Host - Memory used %",
            "defaultName": "Custom chart",
            "chartConfig": {
                "legendShown": true,
                "type": "TIMESERIES",
                "series": [{
                    "metric": "builtin:host.mem.usage",
                    "aggregation": "AVG",
                    "type": "LINE",
                    "entityType": "HOST",
                    "dimensions": [{
                        "id": "0",
                        "name": "dt.entity.host",
                        "values": [],
                        "entityDimension": true
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
        "name": "Custom chart",
        "tileType": "CUSTOM_CHARTING",
        "configured": true,
        "bounds": {
            "top": 1482,
            "left": 684,
            "width": 494,
            "height": 304
        },
        "tileFilter": {},
        "filterConfig": {
            "type": "MIXED",
            "customName": "Process - Memory",
            "defaultName": "Custom chart",
            "chartConfig": {
                "legendShown": true,
                "type": "TIMESERIES",
                "series": [{
                    "metric": "builtin:tech.generic.mem.workingSetSize",
                    "aggregation": "AVG",
                    "type": "LINE",
                    "entityType": "PROCESS_GROUP_INSTANCE",
                    "dimensions": [{
                        "id": "0",
                        "name": "dt.entity.process_group_instance",
                        "values": [],
                        "entityDimension": true
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
        "name": "Custom chart",
        "tileType": "CUSTOM_CHARTING",
        "configured": true,
        "bounds": {
            "top": 874,
            "left": 190,
            "width": 494,
            "height": 304
        },
        "tileFilter": {},
        "filterConfig": {
            "type": "MIXED",
            "customName": "Service - Requests per second",
            "defaultName": "Custom chart",
            "chartConfig": {
                "legendShown": true,
                "type": "TIMESERIES",
                "series": [{
                    "metric": "builtin:service.requestCount.server",
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
                    "aggregationRate": "SECOND"
                }],
                "resultMetadata": {
                    "nullbuiltin:service.keyRequest.count.total|NONE|TOTAL|BAR|SERVICE_KEY_REQUEST": {
                        "lastModified": 1601493752827,
                        "customColor": "#008cdb"
                    },
                    "nullbuiltin:service.requestCount.total|NONE|TOTAL|BAR|SERVICE": {
                        "lastModified": 1602214426809,
                        "customColor": "#008cdb"
                    },
                    "nullbuiltin:service.requestCount.server|NONE|SECOND|BAR|SERVICE": {
                        "lastModified": 1602252591261,
                        "customColor": "#008cdb"
                    },
                    "SERVICE-3F3B7DD9C76EEF2F¦SERVICE»SERVICE-3F3B7DD9C76EEF2F»truebuiltin:service.requestCount.total|NONE|TOTAL|BAR|SERVICE": {
                        "lastModified": 1597889309835,
                        "customColor": "#008cdb"
                    }
                }
            },
            "filtersPerEntityType": {}
        }
    }, {
        "name": "Custom chart",
        "tileType": "CUSTOM_CHARTING",
        "configured": true,
        "bounds": {
            "top": 874,
            "left": 684,
            "width": 494,
            "height": 304
        },
        "tileFilter": {},
        "filterConfig": {
            "type": "MIXED",
            "customName": "Service - Latency",
            "defaultName": "Custom chart",
            "chartConfig": {
                "legendShown": true,
                "type": "TIMESERIES",
                "series": [{
                    "metric": "builtin:service.response.server",
                    "aggregation": "PERCENTILE",
                    "percentile": 50,
                    "type": "AREA",
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
                "resultMetadata": {
                    "SERVICE-3F3B7DD9C76EEF2F¦SERVICE»SERVICE-3F3B7DD9C76EEF2F»truebuiltin:service.response.time|AVG|TOTAL|LINE|SERVICE": {
                        "lastModified": 1597889290418,
                        "customColor": "#7c38a1"
                    },
                    "nullbuiltin:service.response.server|PERCENTILE|TOTAL|50|AREA|SERVICE": {
                        "lastModified": 1601493686172,
                        "customColor": "#7c38a1"
                    },
                    "nullbuiltin:service.response.time|AVG|TOTAL|LINE|SERVICE": {
                        "lastModified": 1598243815544,
                        "customColor": "#7c38a1"
                    }
                }
            },
            "filtersPerEntityType": {}
        }
    }, {
        "name": "Custom chart",
        "tileType": "CUSTOM_CHARTING",
        "configured": true,
        "bounds": {
            "top": 874,
            "left": 1178,
            "width": 494,
            "height": 304
        },
        "tileFilter": {},
        "filterConfig": {
            "type": "MIXED",
            "customName": "Service - Errors",
            "defaultName": "Custom chart",
            "chartConfig": {
                "legendShown": true,
                "type": "TIMESERIES",
                "series": [{
                    "metric": "builtin:service.errors.server.count",
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
                "resultMetadata": {
                    "nullbuiltin:service.errors.fivexx.count|NONE|TOTAL|BAR|SERVICE": {
                        "lastModified": 1597889137069,
                        "customColor": "#ff0000"
                    },
                    "nullbuiltin:service.errors.fourxx.count|NONE|TOTAL|BAR|SERVICE": {
                        "lastModified": 1597889131457,
                        "customColor": "#ef651f"
                    }
                }
            },
            "filtersPerEntityType": {}
        }
    }, {
        "name": "Custom chart",
        "tileType": "CUSTOM_CHARTING",
        "configured": true,
        "bounds": {
            "top": 1178,
            "left": 684,
            "width": 494,
            "height": 304
        },
        "tileFilter": {},
        "filterConfig": {
            "type": "MIXED",
            "customName": "Database - Latency",
            "defaultName": "Custom chart",
            "chartConfig": {
                "legendShown": true,
                "type": "TIMESERIES",
                "series": [{
                    "metric": "builtin:service.response.time",
                    "aggregation": "PERCENTILE",
                    "percentile": 50,
                    "type": "AREA",
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
                "resultMetadata": {
                    "nullbuiltin:service.response.time|PERCENTILE|TOTAL|50|AREA|SERVICE": {
                        "lastModified": 1598243803538,
                        "customColor": "#7c38a1"
                    }
                }
            },
            "filtersPerEntityType": {
                "SERVICE": {
                    "SERVICE_TYPE": ["3"]
                }
            }
        }
    }, {
        "name": "Custom chart",
        "tileType": "CUSTOM_CHARTING",
        "configured": true,
        "bounds": {
            "top": 1178,
            "left": 190,
            "width": 494,
            "height": 304
        },
        "tileFilter": {},
        "filterConfig": {
            "type": "MIXED",
            "customName": "Database - Queries per second",
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
                    "aggregationRate": "SECOND"
                }],
                "resultMetadata": {
                    "nullbuiltin:service.requestCount.total|NONE|SECOND|BAR|SERVICE": {
                        "lastModified": 1598243827297,
                        "customColor": "#008cdb"
                    }
                }
            },
            "filtersPerEntityType": {
                "SERVICE": {
                    "SERVICE_TYPE": ["3"]
                }
            }
        }
    }, {
        "name": "Custom chart",
        "tileType": "CUSTOM_CHARTING",
        "configured": true,
        "bounds": {
            "top": 1178,
            "left": 1178,
            "width": 494,
            "height": 304
        },
        "tileFilter": {},
        "filterConfig": {
            "type": "MIXED",
            "customName": "Database - Errors",
            "defaultName": "Custom chart",
            "chartConfig": {
                "legendShown": true,
                "type": "TIMESERIES",
                "series": [{
                    "metric": "builtin:service.errors.total.count",
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
                "resultMetadata": {
                    "nullbuiltin:service.errors.total.count|NONE|TOTAL|BAR|SERVICE": {
                        "lastModified": 1598243859355,
                        "customColor": "#ff0000"
                    }
                }
            },
            "filtersPerEntityType": {
                "SERVICE": {
                    "SERVICE_TYPE": ["3"]
                }
            }
        }
    }, {
        "name": "Custom chart",
        "tileType": "CUSTOM_CHARTING",
        "configured": true,
        "bounds": {
            "top": 1482,
            "left": 1178,
            "width": 494,
            "height": 304
        },
        "tileFilter": {},
        "filterConfig": {
            "type": "MIXED",
            "customName": "Process - Garbage Collection Suspension Time",
            "defaultName": "Custom chart",
            "chartConfig": {
                "legendShown": true,
                "type": "TIMESERIES",
                "series": [{
                    "metric": "builtin:tech.jvm.memory.gc.suspensionTime",
                    "aggregation": "AVG",
                    "type": "LINE",
                    "entityType": "PROCESS_GROUP_INSTANCE",
                    "dimensions": [{
                        "id": "0",
                        "name": "dt.entity.process_group_instance",
                        "values": [],
                        "entityDimension": true
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
        "name": "Custom chart",
        "tileType": "CUSTOM_CHARTING",
        "configured": true,
        "bounds": {
            "top": 1786,
            "left": 1178,
            "width": 494,
            "height": 304
        },
        "tileFilter": {},
        "filterConfig": {
            "type": "MIXED",
            "customName": "Host - Disk average queue length ",
            "defaultName": "Custom chart",
            "chartConfig": {
                "legendShown": true,
                "type": "TIMESERIES",
                "series": [{
                    "metric": "builtin:host.disk.queueLength",
                    "aggregation": "AVG",
                    "type": "LINE",
                    "entityType": "HOST",
                    "dimensions": [{
                        "id": "0",
                        "name": "dt.entity.host",
                        "values": [],
                        "entityDimension": true
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
        "name": "Custom chart",
        "tileType": "CUSTOM_CHARTING",
        "configured": true,
        "bounds": {
            "top": 570,
            "left": 684,
            "width": 494,
            "height": 304
        },
        "tileFilter": {},
        "filterConfig": {
            "type": "MIXED",
            "customName": "Transaction - Latency",
            "defaultName": "Custom chart",
            "chartConfig": {
                "legendShown": true,
                "type": "TIMESERIES",
                "series": [{
                    "metric": "calc:service.teststepresponsetime",
                    "aggregation": "AVG",
                    "type": "AREA",
                    "entityType": "SERVICE",
                    "dimensions": [{
                        "id": "1",
                        "name": "TestStep",
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
        "name": "Custom chart",
        "tileType": "CUSTOM_CHARTING",
        "configured": true,
        "bounds": {
            "top": 570,
            "left": 1178,
            "width": 494,
            "height": 304
        },
        "tileFilter": {},
        "filterConfig": {
            "type": "MIXED",
            "customName": "Transaction - Errors",
            "defaultName": "Custom chart",
            "chartConfig": {
                "legendShown": true,
                "type": "TIMESERIES",
                "series": [{
                    "metric": "calc:service.teststepfailurerate",
                    "aggregation": "OF_INTEREST_RATIO",
                    "type": "LINE",
                    "entityType": "SERVICE",
                    "dimensions": [{
                        "id": "1",
                        "name": "TestStep",
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
        "name": "Problems",
        "tileType": "OPEN_PROBLEMS",
        "configured": true,
        "bounds": {
            "top": 38,
            "left": 0,
            "width": 152,
            "height": 152
        },
        "tileFilter": {}
    }, {
        "name": "Custom chart",
        "tileType": "CUSTOM_CHARTING",
        "configured": true,
        "bounds": {
            "top": 228,
            "left": 1102,
            "width": 304,
            "height": 304
        },
        "tileFilter": {},
        "filterConfig": {
            "type": "MIXED",
            "customName": "Latency (Max)",
            "defaultName": "Custom chart",
            "chartConfig": {
                "legendShown": true,
                "type": "TOP_LIST",
                "series": [{
                    "metric": "calc:service.teststepresponsetime",
                    "aggregation": "MAX",
                    "type": "LINE",
                    "entityType": "SERVICE",
                    "dimensions": [{
                        "id": "1",
                        "name": "TestStep",
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
        "name": "Custom chart",
        "tileType": "CUSTOM_CHARTING",
        "configured": true,
        "bounds": {
            "top": 228,
            "left": 190,
            "width": 304,
            "height": 304
        },
        "tileFilter": {},
        "filterConfig": {
            "type": "MIXED",
            "customName": "Requests",
            "defaultName": "Custom chart",
            "chartConfig": {
                "legendShown": true,
                "type": "TOP_LIST",
                "series": [{
                    "metric": "calc:service.teststepresponsetime",
                    "aggregation": "COUNT",
                    "type": "LINE",
                    "entityType": "SERVICE",
                    "dimensions": [{
                        "id": "1",
                        "name": "TestStep",
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
        "name": "Custom chart",
        "tileType": "CUSTOM_CHARTING",
        "configured": true,
        "bounds": {
            "top": 228,
            "left": 494,
            "width": 304,
            "height": 304
        },
        "tileFilter": {},
        "filterConfig": {
            "type": "MIXED",
            "customName": "Latency (Avg)",
            "defaultName": "Custom chart",
            "chartConfig": {
                "legendShown": true,
                "type": "TOP_LIST",
                "series": [{
                    "metric": "calc:service.teststepresponsetime",
                    "aggregation": "AVG",
                    "type": "LINE",
                    "entityType": "SERVICE",
                    "dimensions": [{
                        "id": "1",
                        "name": "TestStep",
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
        "name": "Custom chart",
        "tileType": "CUSTOM_CHARTING",
        "configured": true,
        "bounds": {
            "top": 228,
            "left": 798,
            "width": 304,
            "height": 304
        },
        "tileFilter": {},
        "filterConfig": {
            "type": "MIXED",
            "customName": "Latency (Min)",
            "defaultName": "Custom chart",
            "chartConfig": {
                "legendShown": true,
                "type": "TOP_LIST",
                "series": [{
                    "metric": "calc:service.teststepresponsetime",
                    "aggregation": "MIN",
                    "type": "LINE",
                    "entityType": "SERVICE",
                    "dimensions": [{
                        "id": "1",
                        "name": "TestStep",
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
        "name": "Markdown",
        "tileType": "MARKDOWN",
        "configured": true,
        "bounds": {
            "top": 190,
            "left": 190,
            "width": 1482,
            "height": 38
        },
        "tileFilter": {},
        "markdown": "## \uD83D\uDCB9 Transaction Scorecard\n"
    }, {
        "name": "Markdown",
        "tileType": "MARKDOWN",
        "configured": true,
        "bounds": {
            "top": 0,
            "left": 0,
            "width": 152,
            "height": 38
        },
        "tileFilter": {},
        "markdown": "##  \uD83D\uDEA6 Health\n\n"
    }, {
        "name": "Markdown",
        "tileType": "MARKDOWN",
        "configured": true,
        "bounds": {
            "top": 608,
            "left": 0,
            "width": 190,
            "height": 38
        },
        "tileFilter": {},
        "markdown": "- [Transactions](ui/diagnostictools/mda?metric=RESPONSE_TIME&dimension=%7BRequestAttribute:TSN%7D&aggregation=AVERAGE&percentile=80&chart=LINE&sservicefilter=0%1E15%112a0b9950-718f-42af-9f2a-b777dc37709c&mergeServices=false)"
    }, {
        "name": "Markdown",
        "tileType": "MARKDOWN",
        "configured": true,
        "bounds": {
            "top": 646,
            "left": 0,
            "width": 190,
            "height": 38
        },
        "tileFilter": {},
        "markdown": "- [Slow > 5s](ui/diagnostictools/mda?metric=RESPONSE_TIME&dimension=%7BRequestAttribute:TSN%7D&aggregation=MAX&percentile=80&chart=LINE&sservicefilter=0%1E15%112a0b9950-718f-42af-9f2a-b777dc37709c&mergeServices=false&servicefilter=0%1E0%115000000%144611686018427387)"
    }, {
        "name": "Markdown",
        "tileType": "MARKDOWN",
        "configured": true,
        "bounds": {
            "top": 684,
            "left": 0,
            "width": 190,
            "height": 38
        },
        "tileFilter": {},
        "markdown": "- [Errors](ui/diagnostictools/mda?metric=FAILED_REQUEST_COUNT&dimension=%7BRequestAttribute:TSN%7D&aggregation=COUNT&percentile=80&chart=LINE&sservicefilter=0%1E15%112a0b9950-718f-42af-9f2a-b777dc37709c&mergeServices=false&servicefilter=0%1E3%110)"
    }, {
        "name": "Markdown",
        "tileType": "MARKDOWN",
        "configured": true,
        "bounds": {
            "top": 722,
            "left": 0,
            "width": 190,
            "height": 38
        },
        "tileFilter": {},
        "markdown": "- [Exceptions](ui/diagnostictools/mda?metric=EXCEPTION_COUNT&dimension=%7BRequestAttribute:TSN%7D&aggregation=SUM&percentile=80&chart=LINE&sservicefilter=0%1E15%112a0b9950-718f-42af-9f2a-b777dc37709c&mergeServices=false&servicefilter=0%1E29%110%14Any%20exception)\n\n"
    }, {
        "name": "Markdown",
        "tileType": "MARKDOWN",
        "configured": true,
        "bounds": {
            "top": 760,
            "left": 0,
            "width": 190,
            "height": 38
        },
        "tileFilter": {},
        "markdown": "- [Database Time](ui/diagnostictools/mda?mdaId=topdb&metric=DATABASE_CHILD_CALL_TIME&dimension=%7BRequestAttribute:TSN%7D&mergeServices=false&aggregation=MAX&percentile=80&chart=COLUMN)"
    }, {
        "name": "Markdown",
        "tileType": "MARKDOWN",
        "configured": true,
        "bounds": {
            "top": 532,
            "left": 190,
            "width": 1482,
            "height": 38
        },
        "tileFilter": {},
        "markdown": "##  \uD83D\uDCC8  Service Level Indicators (SLIs)\n"
    }, {
        "name": "Markdown",
        "tileType": "MARKDOWN",
        "configured": true,
        "bounds": {
            "top": 570,
            "left": 0,
            "width": 190,
            "height": 38
        },
        "tileFilter": {},
        "markdown": "##  \uD83D\uDD0D Transaction\n"
    }, {
        "name": "Markdown",
        "tileType": "MARKDOWN",
        "configured": true,
        "bounds": {
            "top": 874,
            "left": 0,
            "width": 190,
            "height": 38
        },
        "tileFilter": {},
        "markdown": "## \uD83D\uDD0D  Service"
    }, {
        "name": "Markdown",
        "tileType": "MARKDOWN",
        "configured": true,
        "bounds": {
            "top": 912,
            "left": 0,
            "width": 190,
            "height": 38
        },
        "tileFilter": {},
        "markdown": "- [Requests](ui/diagnostictools/mda?mdaId=topweb&metric=REQUEST_COUNT&dimension=%7BRequest:Name%7D&mergeServices=false&aggregation=COUNT&percentile=80&chart=COLUMN&servicefilter=0%1E26%112%1026%111)"
    }, {
        "name": "Markdown",
        "tileType": "MARKDOWN",
        "configured": true,
        "bounds": {
            "top": 950,
            "left": 0,
            "width": 190,
            "height": 38
        },
        "tileFilter": {},
        "markdown": "- [Slow > 30s](ui/diagnostictools/mda?mdaId=topweb&metric=REQUEST_COUNT&dimension=%7BRequest:Name%7D&mergeServices=false&aggregation=COUNT&percentile=80&chart=COLUMN&servicefilter=0%1E26%112%1026%111%100%1130000000%144611686018427387)"
    }, {
        "name": "Markdown",
        "tileType": "MARKDOWN",
        "configured": true,
        "bounds": {
            "top": 1026,
            "left": 0,
            "width": 190,
            "height": 38
        },
        "tileFilter": {},
        "markdown": "- [5xx Errors](ui/diagnostictools/mda?mdaId=topweb&metric=REQUEST_COUNT&dimension=%7BRequest:Name%7D&mergeServices=false&aggregation=COUNT&percentile=80&chart=COLUMN&servicefilter=0%1E26%112%1026%111%102%11500-599)"
    }, {
        "name": "Markdown",
        "tileType": "MARKDOWN",
        "configured": true,
        "bounds": {
            "top": 1064,
            "left": 0,
            "width": 190,
            "height": 38
        },
        "tileFilter": {},
        "markdown": "- [4xx Errors](ui/diagnostictools/mda?mdaId=topweb&metric=REQUEST_COUNT&dimension=%7BRequest:Name%7D&mergeServices=false&aggregation=COUNT&percentile=80&chart=COLUMN&servicefilter=0%1E26%112%1026%111%102%11400-499)"
    }, {
        "name": "Markdown",
        "tileType": "MARKDOWN",
        "configured": true,
        "bounds": {
            "top": 1102,
            "left": 0,
            "width": 190,
            "height": 38
        },
        "tileFilter": {},
        "markdown": "- [Exceptions](ui/diagnostictools/mda?mdaId=exceptions&metric=EXCEPTION_COUNT&dimension=%7BException:Class%7D&mergeServices=true&aggregation=SUM&percentile=80&chart=COLUMN&servicefilter=0%1E29%110)"
    }, {
        "name": "Markdown",
        "tileType": "MARKDOWN",
        "configured": true,
        "bounds": {
            "top": 1140,
            "left": 0,
            "width": 190,
            "height": 38
        },
        "tileFilter": {},
        "markdown": "- [Services](#newservices)"
    }, {
        "name": "Markdown",
        "tileType": "MARKDOWN",
        "configured": true,
        "bounds": {
            "top": 1178,
            "left": 0,
            "width": 190,
            "height": 38
        },
        "tileFilter": {},
        "markdown": "## \uD83D\uDD0D  Database"
    }, {
        "name": "Markdown",
        "tileType": "MARKDOWN",
        "configured": true,
        "bounds": {
            "top": 1216,
            "left": 0,
            "width": 190,
            "height": 38
        },
        "tileFilter": {},
        "markdown": "- [Top Queries](ui/diagnostictools/mda?mdaId=topdb&metric=REQUEST_COUNT&dimension=%7BRequest:Name%7D&mergeServices=false&aggregation=COUNT&percentile=80&chart=COLUMN&servicefilter=0%1E26%110)"
    }, {
        "name": "Markdown",
        "tileType": "MARKDOWN",
        "configured": true,
        "bounds": {
            "top": 1254,
            "left": 0,
            "width": 190,
            "height": 38
        },
        "tileFilter": {},
        "markdown": "- [Queries > 30s](ui/diagnostictools/mda?mdaId=topdb&metric=RESPONSE_TIME&dimension=%7BRequest:Name%7D&mergeServices=false&aggregation=MAX&percentile=80&chart=COLUMN&servicefilter=0%1E26%110%100%1130000000%144611686018427387)"
    }, {
        "name": "Markdown",
        "tileType": "MARKDOWN",
        "configured": true,
        "bounds": {
            "top": 1292,
            "left": 0,
            "width": 190,
            "height": 38
        },
        "tileFilter": {},
        "markdown": "- [Queries with Errors](ui/diagnostictools/mda?mdaId=topdb&metric=REQUEST_COUNT&dimension=%7BRequest:Name%7D%20&mergeServices=false&aggregation=COUNT&percentile=80&chart=COLUMN&servicefilter=0%1E26%110%103%110)"
    }, {
        "name": "Markdown",
        "tileType": "MARKDOWN",
        "configured": true,
        "bounds": {
            "top": 1330,
            "left": 0,
            "width": 190,
            "height": 38
        },
        "tileFilter": {},
        "markdown": "- [Databases](#newdatabases)"
    }, {
        "name": "Markdown",
        "tileType": "MARKDOWN",
        "configured": true,
        "bounds": {
            "top": 1482,
            "left": 0,
            "width": 190,
            "height": 38
        },
        "tileFilter": {},
        "markdown": "## \uD83D\uDD0D  Process"
    }, {
        "name": "Markdown",
        "tileType": "MARKDOWN",
        "configured": true,
        "bounds": {
            "top": 1786,
            "left": 0,
            "width": 190,
            "height": 38
        },
        "tileFilter": {},
        "markdown": "## \uD83D\uDD0D  Host\n"
    }, {
        "name": "Markdown",
        "tileType": "MARKDOWN",
        "configured": true,
        "bounds": {
            "top": 1520,
            "left": 0,
            "width": 190,
            "height": 38
        },
        "tileFilter": {},
        "markdown": "- [Processes](#newprocessessummary)"
    }, {
        "name": "Markdown",
        "tileType": "MARKDOWN",
        "configured": true,
        "bounds": {
            "top": 1558,
            "left": 0,
            "width": 190,
            "height": 38
        },
        "tileFilter": {},
        "markdown": "- [CPU Analysis](ui/diagnostictools/profiling/cpu)"
    }, {
        "name": "Markdown",
        "tileType": "MARKDOWN",
        "configured": true,
        "bounds": {
            "top": 1596,
            "left": 0,
            "width": 190,
            "height": 38
        },
        "tileFilter": {},
        "markdown": "- [Process Crashes](#processcrashesglobal)"
    }, {
        "name": "Markdown",
        "tileType": "MARKDOWN",
        "configured": true,
        "bounds": {
            "top": 1634,
            "left": 0,
            "width": 190,
            "height": 38
        },
        "tileFilter": {},
        "markdown": "- [Logs](#loganalytics)"
    }, {
        "name": "Markdown",
        "tileType": "MARKDOWN",
        "configured": true,
        "bounds": {
            "top": 1824,
            "left": 0,
            "width": 190,
            "height": 38
        },
        "tileFilter": {},
        "markdown": "- [Hosts](#newhosts)"
    }, {
        "name": "Markdown",
        "tileType": "MARKDOWN",
        "configured": true,
        "bounds": {
            "top": 1862,
            "left": 0,
            "width": 190,
            "height": 38
        },
        "tileFilter": {},
        "markdown": "- [Network](/ui/network?)"
    }, {
        "name": "Markdown",
        "tileType": "MARKDOWN",
        "configured": true,
        "bounds": {
            "top": 1900,
            "left": 0,
            "width": 190,
            "height": 38
        },
        "tileFilter": {},
        "markdown": "- [Smartscape](#smartscape)"
    }, {
        "name": "Custom chart",
        "tileType": "CUSTOM_CHARTING",
        "configured": true,
        "bounds": {
            "top": 570,
            "left": 190,
            "width": 494,
            "height": 304
        },
        "tileFilter": {},
        "filterConfig": {
            "type": "MIXED",
            "customName": "Transaction - Requests",
            "defaultName": "Custom chart",
            "chartConfig": {
                "legendShown": true,
                "type": "TIMESERIES",
                "series": [{
                    "metric": "calc:service.teststepresponsetime",
                    "aggregation": "SUM",
                    "type": "BAR",
                    "entityType": "SERVICE",
                    "dimensions": [{
                        "id": "1",
                        "name": "TestStep",
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
        "name": "Custom chart",
        "tileType": "CUSTOM_CHARTING",
        "configured": true,
        "bounds": {
            "top": 228,
            "left": 1406,
            "width": 266,
            "height": 304
        },
        "tileFilter": {},
        "filterConfig": {
            "type": "MIXED",
            "customName": "Errors",
            "defaultName": "Custom chart",
            "chartConfig": {
                "legendShown": true,
                "type": "TOP_LIST",
                "series": [{
                    "metric": "calc:service.teststepfailurerate",
                    "aggregation": "OF_INTEREST_RATIO",
                    "type": "LINE",
                    "entityType": "SERVICE",
                    "dimensions": [{
                        "id": "1",
                        "name": "TestStep",
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
        "name": "Markdown",
        "tileType": "MARKDOWN",
        "configured": true,
        "bounds": {
            "top": 798,
            "left": 0,
            "width": 190,
            "height": 38
        },
        "tileFilter": {},
        "markdown": "- [Database Queries](ui/diagnostictools/mda?mdaId=topdb&metric=DATABASE_CHILD_CALL_COUNT&dimension=%7BRequestAttribute:TSN%7D&mergeServices=false&aggregation=AVERAGE&percentile=80&chart=COLUMN&servicefilter=0%1E37%111%144611686018427387)"
    }, {
        "name": "Markdown",
        "tileType": "MARKDOWN",
        "configured": true,
        "bounds": {
            "top": 0,
            "left": 190,
            "width": 1482,
            "height": 38
        },
        "tileFilter": {},
        "markdown": "##  ✅  SLOs\n"
    }, {
        "name": "Service-level objective",
        "tileType": "SLO",
        "configured": true,
        "bounds": {
            "top": 38,
            "left": 190,
            "width": 494,
            "height": 152
        },
        "tileFilter": {
            "timeframe": "-30m"
        },
        "assignedEntities": ["334a3b10-e886-3ff6-a072-7440833a4c4f"]
    }, {
        "name": "Service-level objective",
        "tileType": "SLO",
        "configured": true,
        "bounds": {
            "top": 38,
            "left": 684,
            "width": 494,
            "height": 152
        },
        "tileFilter": {
            "timeframe": "-30m"
        },
        "assignedEntities": ["bead06f7-c2f5-38a4-8f5d-075a58f1f1d2"]
    }, {
        "name": "Service-level objective",
        "tileType": "SLO",
        "configured": true,
        "bounds": {
            "top": 38,
            "left": 1178,
            "width": 494,
            "height": 152
        },
        "tileFilter": {
            "timeframe": "-30m"
        },
        "assignedEntities": ["16d94f88-b387-3300-a0f3-6d5c7dd5a5fd"]
    }, {
        "name": "Service health",
        "tileType": "SERVICES",
        "configured": true,
        "bounds": {
            "top": 190,
            "left": 0,
            "width": 152,
            "height": 152
        },
        "tileFilter": {},
        "chartVisible": true
    }, {
        "name": "Database health",
        "tileType": "DATABASES_OVERVIEW",
        "configured": true,
        "bounds": {
            "top": 342,
            "left": 0,
            "width": 152,
            "height": 152
        },
        "tileFilter": {},
        "chartVisible": true
    }, {
        "name": "Markdown",
        "tileType": "MARKDOWN",
        "configured": true,
        "bounds": {
            "top": 988,
            "left": 0,
            "width": 190,
            "height": 38
        },
        "tileFilter": {},
        "markdown": "- [Failed Requests](ui/diagnostictools/mda?metric=FAILED_REQUEST_COUNT&dimension=%7BRequest:Name%7D&aggregation=COUNT&percentile=80&chart=LINE&sservicefilter=0%1E15%112a0b9950-718f-42af-9f2a-b777dc37709c&mergeServices=false&servicefilter=0%1E3%110)"
    }]
}'