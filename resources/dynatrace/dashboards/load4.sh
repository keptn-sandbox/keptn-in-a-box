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
        "name": "\uD83E\uDDEC Software intelligence - Release better software faster - sample ",
        "shared": true,
        "owner": "'${OWNER}'",
        "sharingDetails": {
            "linkShared": true,
            "published": false
        },
        "dashboardFilter": {
            "timeframe": "-24h to now"
        }
    },
    "tiles": [{
        "name": "Custom chart",
        "tileType": "CUSTOM_CHARTING",
        "configured": true,
        "bounds": {
            "top": 380,
            "left": 304,
            "width": 684,
            "height": 304
        },
        "tileFilter": {},
        "filterConfig": {
            "type": "MIXED",
            "customName": "Request count vs 95th ResponseTime",
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
                }, {
                    "metric": "builtin:service.response.time",
                    "aggregation": "PERCENTILE",
                    "percentile": 95,
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
            "filtersPerEntityType": {}
        }
    }, {
        "name": "Markdown",
        "tileType": "MARKDOWN",
        "configured": true,
        "bounds": {
            "top": 342,
            "left": 304,
            "width": 646,
            "height": 38
        },
        "tileFilter": {},
        "markdown": "[\uD83D\uDC22 TX > 10 Sec](#topglobalwebrequests;gtf=l_2_HOURS;gf=all;servicefilter=0%1E0%1110000000%144611686018427387) [\uD83D\uDC0C >30 Sec](#topglobalwebrequests;gtf=l_2_HOURS;gf=all;servicefilter=0%1E0%1130000000%144611686018427387) -  [⚡Exceptions](#exceptionsoverview;) - [❗Failed requests](#topglobalwebrequests;gtf=l_2_HOURS;gf=all;servicefilter=0%1E3%110) \n - [❗HTTP 4XX](#topglobalwebrequests;gtf=l_2_HOURS;gf=all;servicefilter=0%1E2%11400-499) - [❗HTTP 5XX](#topglobalwebrequests;gtf=l_2_HOURS;gf=all;servicefilter=0%1E2%11500-599)"
    }, {
        "name": "Markdown",
        "tileType": "MARKDOWN",
        "configured": true,
        "bounds": {
            "top": 0,
            "left": 646,
            "width": 494,
            "height": 38
        },
        "tileFilter": {},
        "markdown": "[Live Sessions \uD83D\uDC68‍\uD83D\uDCBB](#usersearchoverview;filtrfilterLive=1) [Happy users \uD83D\uDE04](#usersearchoverview;filtrfilterUXScore=3) [Tolerated users \uD83D\uDE0F](#usersearchoverview;filtrfilterUXScore=2) [Frustated Users \uD83D\uDE21](#usersearchoverview;filtrfilterUXScore=1)"
    }, {
        "name": "Markdown",
        "tileType": "MARKDOWN",
        "configured": true,
        "bounds": {
            "top": 0,
            "left": 0,
            "width": 646,
            "height": 38
        },
        "tileFilter": {},
        "markdown": "[☁ Azure subscriptions](#azure) \n[\uD83D\uDD2C Diagnostic Tools](#diagnostictools;gf=all;gtf=l_2_HOURS) - [\uD83D\uDD78 Smartscape](#smartscape;gf=all) - [\uD83C\uDF10Technologies deployed](#newprocessessummary;)\n"
    }, {
        "name": "",
        "tileType": "DATABASES_OVERVIEW",
        "configured": true,
        "bounds": {
            "top": 342,
            "left": 0,
            "width": 152,
            "height": 152
        },
        "tileFilter": {},
        "filterConfig": {
            "type": "DATABASE",
            "customName": "Databases",
            "defaultName": "Databases",
            "chartConfig": {
                "legendShown": true,
                "type": "TIMESERIES",
                "series": [],
                "resultMetadata": {}
            },
            "filtersPerEntityType": {}
        },
        "chartVisible": true
    }, {
        "name": "Live user activity",
        "tileType": "UEM_ACTIVE_SESSIONS",
        "configured": true,
        "bounds": {
            "top": 38,
            "left": 988,
            "width": 304,
            "height": 304
        },
        "tileFilter": {}
    }, {
        "name": "World map",
        "tileType": "APPLICATION_WORLDMAP",
        "configured": true,
        "bounds": {
            "top": 38,
            "left": 0,
            "width": 304,
            "height": 304
        },
        "tileFilter": {},
        "assignedEntities": [],
        "metric": "APDEX"
    }, {
        "name": "Custom chart",
        "tileType": "CUSTOM_CHARTING",
        "configured": true,
        "bounds": {
            "top": 722,
            "left": 304,
            "width": 684,
            "height": 304
        },
        "tileFilter": {},
        "filterConfig": {
            "type": "MIXED",
            "customName": "HTTP [4|5XX] and failed transactions ",
            "defaultName": "Custom chart",
            "chartConfig": {
                "legendShown": true,
                "type": "TIMESERIES",
                "series": [{
                    "metric": "builtin:service.errors.fivexx.count",
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
                }, {
                    "metric": "builtin:service.errors.total.count",
                    "aggregation": "NONE",
                    "type": "AREA",
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
                }, {
                    "metric": "builtin:service.errors.fourxx.count",
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
            "filtersPerEntityType": {}
        }
    }, {
        "name": "Custom chart",
        "tileType": "CUSTOM_CHARTING",
        "configured": true,
        "bounds": {
            "top": 1064,
            "left": 304,
            "width": 684,
            "height": 266
        },
        "tileFilter": {},
        "filterConfig": {
            "type": "MIXED",
            "customName": "DB Calls vs Time in DB",
            "defaultName": "Custom chart",
            "chartConfig": {
                "legendShown": true,
                "type": "TIMESERIES",
                "series": [{
                    "metric": "builtin:service.dbChildCallCount",
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
                }, {
                    "metric": "builtin:service.dbChildCallTime",
                    "aggregation": "NONE",
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
            "filtersPerEntityType": {}
        }
    }, {
        "name": "Service health",
        "tileType": "SERVICES",
        "configured": true,
        "bounds": {
            "top": 342,
            "left": 152,
            "width": 152,
            "height": 152
        },
        "tileFilter": {},
        "chartVisible": true
    }, {
        "name": "Host health",
        "tileType": "HOSTS",
        "configured": true,
        "bounds": {
            "top": 494,
            "left": 0,
            "width": 152,
            "height": 152
        },
        "tileFilter": {},
        "chartVisible": true
    }, {
        "name": "Application health",
        "tileType": "APPLICATIONS",
        "configured": true,
        "bounds": {
            "top": 494,
            "left": 152,
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
            "top": 1026,
            "left": 342,
            "width": 608,
            "height": 38
        },
        "tileFilter": {},
        "markdown": "[\uD83D\uDDD1 Database SQL Statements](#topdbstatements;gtf=l_2_HOURS;gf=all) "
    }, {
        "name": "Markdown",
        "tileType": "MARKDOWN",
        "configured": true,
        "bounds": {
            "top": 684,
            "left": 342,
            "width": 646,
            "height": 38
        },
        "tileFilter": {},
        "markdown": "[\uD83E\uDDE8Process Crashes](#processcrashesglobal;) - [\uD83D\uDD25CPU Consumption](#codelevel;) - [\uD83D\uDCBEMemory Dumps](#memorydumpsglobal;) - [\uD83D\uDCD1Log Analytics](#loganalytics;)"
    }, {
        "name": "",
        "tileType": "CUSTOM_CHARTING",
        "configured": true,
        "bounds": {
            "top": 646,
            "left": 0,
            "width": 304,
            "height": 342
        },
        "tileFilter": {},
        "filterConfig": {
            "type": "MIXED",
            "customName": "Slowest services",
            "defaultName": "Custom chart",
            "chartConfig": {
                "legendShown": true,
                "type": "TOP_LIST",
                "series": [{
                    "metric": "builtin:service.response.time",
                    "aggregation": "PERCENTILE",
                    "percentile": 95,
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
            "filtersPerEntityType": {}
        }
    }, {
        "name": "",
        "tileType": "CUSTOM_CHARTING",
        "configured": true,
        "bounds": {
            "top": 988,
            "left": 0,
            "width": 304,
            "height": 342
        },
        "tileFilter": {},
        "filterConfig": {
            "type": "MIXED",
            "customName": "Most failing svcs",
            "defaultName": "Custom chart",
            "chartConfig": {
                "legendShown": true,
                "type": "TOP_LIST",
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
            "filtersPerEntityType": {}
        }
    }, {
        "name": "",
        "tileType": "CUSTOM_CHARTING",
        "configured": true,
        "bounds": {
            "top": 646,
            "left": 988,
            "width": 304,
            "height": 342
        },
        "tileFilter": {},
        "filterConfig": {
            "type": "MIXED",
            "customName": "Service Troughput",
            "defaultName": "Custom chart",
            "chartConfig": {
                "legendShown": true,
                "type": "TOP_LIST",
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
                }, {
                    "metric": "builtin:service.response.time",
                    "aggregation": "PERCENTILE",
                    "percentile": 95,
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
            "filtersPerEntityType": {}
        }
    }, {
        "name": "Markdown",
        "tileType": "MARKDOWN",
        "configured": true,
        "bounds": {
            "top": 0,
            "left": 1140,
            "width": 152,
            "height": 38
        },
        "tileFilter": {},
        "markdown": "[\uD83D\uDEA8Problems](#problems)"
    }, {
        "name": "Network status",
        "tileType": "NETWORK_MEDIUM",
        "configured": true,
        "bounds": {
            "top": 494,
            "left": 988,
            "width": 304,
            "height": 152
        },
        "tileFilter": {}
    }, {
        "name": "Smartscape",
        "tileType": "PURE_MODEL",
        "configured": true,
        "bounds": {
            "top": 342,
            "left": 988,
            "width": 304,
            "height": 152
        },
        "tileFilter": {}
    }, {
        "name": "Custom chart",
        "tileType": "CUSTOM_CHARTING",
        "configured": true,
        "bounds": {
            "top": 988,
            "left": 988,
            "width": 304,
            "height": 342
        },
        "tileFilter": {},
        "filterConfig": {
            "type": "MIXED",
            "customName": "\uD83D\uDD3CDB Calls per Svc",
            "defaultName": "Custom chart",
            "chartConfig": {
                "legendShown": true,
                "type": "TOP_LIST",
                "series": [{
                    "metric": "builtin:service.dbChildCallCount",
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
                }, {
                    "metric": "builtin:service.dbChildCallTime",
                    "aggregation": "NONE",
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
            "filtersPerEntityType": {}
        }
    }, {
        "name": "",
        "tileType": "CUSTOM_CHARTING",
        "configured": true,
        "bounds": {
            "top": 38,
            "left": 304,
            "width": 228,
            "height": 304
        },
        "tileFilter": {},
        "filterConfig": {
            "type": "MIXED",
            "customName": "Visually Complete (Load)",
            "defaultName": "Custom chart",
            "chartConfig": {
                "legendShown": true,
                "type": "TOP_LIST",
                "series": [{
                    "metric": "builtin:apps.web.visuallyComplete.load.browser",
                    "aggregation": "AVG",
                    "type": "BAR",
                    "entityType": "APPLICATION",
                    "dimensions": [{
                        "id": "0",
                        "name": "dt.entity.application",
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
        "name": "",
        "tileType": "CUSTOM_CHARTING",
        "configured": true,
        "bounds": {
            "top": 38,
            "left": 532,
            "width": 228,
            "height": 304
        },
        "tileFilter": {},
        "filterConfig": {
            "type": "MIXED",
            "customName": "Visually Complete (XHR)",
            "defaultName": "Custom chart",
            "chartConfig": {
                "legendShown": true,
                "type": "TOP_LIST",
                "series": [{
                    "metric": "builtin:apps.web.visuallyComplete.xhr.browser",
                    "aggregation": "AVG",
                    "type": "LINE",
                    "entityType": "APPLICATION",
                    "dimensions": [{
                        "id": "0",
                        "name": "dt.entity.application",
                        "values": [],
                        "entityDimension": true
                    }, {
                        "id": "1",
                        "name": "dt.entity.browser",
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
        "name": "",
        "tileType": "CUSTOM_CHARTING",
        "configured": true,
        "bounds": {
            "top": 38,
            "left": 760,
            "width": 228,
            "height": 304
        },
        "tileFilter": {},
        "filterConfig": {
            "type": "MIXED",
            "customName": "User Satisfaction",
            "defaultName": "Custom chart",
            "chartConfig": {
                "legendShown": true,
                "type": "TOP_LIST",
                "series": [{
                    "metric": "builtin:apps.web.apdex.userType",
                    "aggregation": "AVG",
                    "type": "LINE",
                    "entityType": "APPLICATION",
                    "dimensions": [{
                        "id": "0",
                        "name": "dt.entity.application",
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
        "name": "",
        "tileType": "CUSTOM_CHARTING",
        "configured": true,
        "bounds": {
            "top": 1330,
            "left": 0,
            "width": 304,
            "height": 304
        },
        "tileFilter": {},
        "filterConfig": {
            "type": "MIXED",
            "customName": "Sum CPU time per Service",
            "defaultName": "Custom chart",
            "chartConfig": {
                "legendShown": true,
                "type": "TIMESERIES",
                "series": [{
                    "metric": "builtin:service.cpu.perRequest",
                    "aggregation": "SUM",
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
            "filtersPerEntityType": {}
        }
    }, {
        "name": "",
        "tileType": "CUSTOM_CHARTING",
        "configured": true,
        "bounds": {
            "top": 1330,
            "left": 646,
            "width": 380,
            "height": 304
        },
        "tileFilter": {},
        "filterConfig": {
            "type": "MIXED",
            "customName": "CPU Usage %",
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
        "name": "",
        "tileType": "CUSTOM_CHARTING",
        "configured": true,
        "bounds": {
            "top": 1330,
            "left": 1026,
            "width": 266,
            "height": 304
        },
        "tileFilter": {},
        "filterConfig": {
            "type": "MIXED",
            "customName": "CPU Usage %",
            "defaultName": "Custom chart",
            "chartConfig": {
                "legendShown": true,
                "type": "TOP_LIST",
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
        "name": "",
        "tileType": "CUSTOM_CHARTING",
        "configured": true,
        "bounds": {
            "top": 1330,
            "left": 304,
            "width": 342,
            "height": 304
        },
        "tileFilter": {},
        "filterConfig": {
            "type": "MIXED",
            "customName": "Max CPU time per Transaction",
            "defaultName": "Custom chart",
            "chartConfig": {
                "legendShown": true,
                "type": "TIMESERIES",
                "series": [{
                    "metric": "builtin:service.cpu.perRequest",
                    "aggregation": "MAX",
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
            "filtersPerEntityType": {}
        }
    }]
}'