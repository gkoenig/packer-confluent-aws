{
    "widgets": [
        {
            "type": "metric",
            "x": 0,
            "y": 0,
            "width": 6,
            "height": 3,
            "properties": {
                "metrics": [
                    [ { "expression": "SUM(METRICS())", "label": "total offline partitions", "id": "e1", "color": "#d62728" } ],
                    [ "InfluxData/Telegraf", "kafka.controller_offlinepartitions_Value", "host", "kafka1.scigility.net", "jolokia_agent_url", "http://localhost:7777/jolokia", "dc", var.aws_region, { "id": "m1", "color": "#aec7e8" } ],
                    [ "...", "kafka2.scigility.net", ".", ".", ".", ".", { "id": "m2", "color": "#9edae5" } ],
                    [ "...", "kafka3.scigility.net", ".", ".", ".", ".", { "id": "m3", "color": "#c7c7c7" } ]
                ],
                "view": "singleValue",
                "region": "eu-central-1",
                "title": "Offline partitions",
                "period": 300
            }
        },
        {
            "type": "metric",
            "x": 12,
            "y": 0,
            "width": 6,
            "height": 3,
            "properties": {
                "metrics": [
                    [ { "expression": "SUM(METRICS())", "label": "total underreplicated", "id": "e1" } ],
                    [ "InfluxData/Telegraf", "kafka.server_replicamanager_underreplicated_Value", "host", "kafka1.scigility.net", "jolokia_agent_url", "http://localhost:7777/jolokia", "dc", var.aws_region, { "id": "m1", "stat": "Maximum" } ],
                    [ "...", "kafka2.scigility.net", ".", ".", ".", ".", { "id": "m2", "stat": "Maximum" } ],
                    [ "...", "kafka3.scigility.net", ".", ".", ".", ".", { "id": "m3", "stat": "Maximum" } ]
                ],
                "view": "singleValue",
                "region": var.aws_region,
                "title": "Underreplicated partitions",
                "period": 300
            }
        },
        {
            "type": "metric",
            "x": 0,
            "y": 12,
            "width": 15,
            "height": 3,
            "properties": {
                "metrics": [
                    [ "InfluxData/Telegraf", "kafka.server_replicamanager_partitioncount_Value", "host", "kafka1.scigility.net", "jolokia_agent_url", "http://localhost:7777/jolokia", "dc", var.aws_region, { "id": "m1" } ],
                    [ "...", "kafka2.scigility.net", ".", ".", ".", ".", { "id": "m2" } ],
                    [ "...", "kafka3.scigility.net", ".", ".", ".", ".", { "id": "m3" } ],
                    [ { "expression": "SUM(METRICS())", "label": "Total #partitions", "id": "e1" } ]
                ],
                "view": "singleValue",
                "region": var.aws_region,
                "title": "Partition count (total and per broker)",
                "period": 300
            }
        },
        {
            "type": "metric",
            "x": 0,
            "y": 9,
            "width": 12,
            "height": 3,
            "properties": {
                "metrics": [
                    [ "InfluxData/Telegraf", "kafka.server_replicamanager_leadercount_Value", "host", "kafka1.scigility.net", "jolokia_agent_url", "http://localhost:7777/jolokia", "dc", var.aws_region, { "id": "m1", "stat": "Maximum", "period": 30 } ],
                    [ "...", "kafka2.scigility.net", ".", ".", ".", ".", { "id": "m2", "stat": "Maximum", "period": 30 } ],
                    [ "...", "kafka3.scigility.net", ".", ".", ".", ".", { "id": "m3", "stat": "Maximum", "period": 30 } ]
                ],
                "view": "singleValue",
                "region": var.aws_region,
                "title": "Partition leader per broker",
                "period": 300
            }
        },
        {
            "type": "metric",
            "x": 0,
            "y": 3,
            "width": 12,
            "height": 6,
            "properties": {
                "metrics": [
                    [ { "expression": "SUM(METRICS())", "label": "Sum", "id": "e1", "color": "#d62728" } ],
                    [ "InfluxData/Telegraf", "kafka.server_brokertopics_bytesinpersec_OneMinuteRate", "host", "kafka1.scigility.net", "jolokia_agent_url", "http://localhost:7777/jolokia", "dc", var.aws_region, { "period": 60, "id": "m1", "color": "#98df8a" } ],
                    [ "...", "kafka2.scigility.net", ".", ".", ".", ".", { "period": 60, "id": "m2", "color": "#bcbd22" } ],
                    [ "...", "kafka3.scigility.net", ".", ".", ".", ".", { "period": 60, "id": "m3", "color": "#9edae5" } ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": var.aws_region,
                "title": "Bytes IN -1 min rate-",
                "yAxis": {
                    "right": {
                        "showUnits": false
                    }
                },
                "legend": {
                    "position": "right"
                },
                "period": 300
            }
        },
        {
            "type": "metric",
            "x": 12,
            "y": 3,
            "width": 12,
            "height": 6,
            "properties": {
                "metrics": [
                    [ { "expression": "SUM(METRICS())", "label": "Sum Messages In / sec", "id": "e1", "color": "#d62728" } ],
                    [ "InfluxData/Telegraf", "kafka.server_brokertopics_messagesinpersec_Count", "host", "kafka1.scigility.net", "jolokia_agent_url", "http://localhost:7777/jolokia", "dc", var.aws_region, { "id": "m1", "color": "#98df8a" } ],
                    [ "...", "kafka2.scigility.net", ".", ".", ".", ".", { "id": "m2", "color": "#bcbd22" } ],
                    [ "...", "kafka3.scigility.net", ".", ".", ".", ".", { "id": "m3", "color": "#9edae5" } ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": var.aws_region,
                "title": "Messages IN per sec",
                "period": 300,
                "legend": {
                    "position": "right"
                }
            }
        }
    ]
}