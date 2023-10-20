resource "shoreline_notebook" "kafka_leader_election_failures_incident" {
  name       = "kafka_leader_election_failures_incident"
  data       = file("${path.module}/data/kafka_leader_election_failures_incident.json")
  depends_on = [shoreline_action.invoke_zk_health_check,shoreline_action.invoke_kafka_service_restarter]
}

resource "shoreline_file" "zk_health_check" {
  name             = "zk_health_check"
  input_file       = "${path.module}/data/zk_health_check.sh"
  md5              = filemd5("${path.module}/data/zk_health_check.sh")
  description      = "Check if the issue is with the Zookeeper ensemble and fix any issues."
  destination_path = "/tmp/zk_health_check.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "kafka_service_restarter" {
  name             = "kafka_service_restarter"
  input_file       = "${path.module}/data/kafka_service_restarter.sh"
  md5              = filemd5("${path.module}/data/kafka_service_restarter.sh")
  description      = "Restart the affected brokers to ensure that they are communicating properly with the Zookeeper."
  destination_path = "/tmp/kafka_service_restarter.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_zk_health_check" {
  name        = "invoke_zk_health_check"
  description = "Check if the issue is with the Zookeeper ensemble and fix any issues."
  command     = "`chmod +x /tmp/zk_health_check.sh && /tmp/zk_health_check.sh`"
  params      = ["ZOOKEEPER_PORT","ZOOKEEPER_HOSTNAME"]
  file_deps   = ["zk_health_check"]
  enabled     = true
  depends_on  = [shoreline_file.zk_health_check]
}

resource "shoreline_action" "invoke_kafka_service_restarter" {
  name        = "invoke_kafka_service_restarter"
  description = "Restart the affected brokers to ensure that they are communicating properly with the Zookeeper."
  command     = "`chmod +x /tmp/kafka_service_restarter.sh && /tmp/kafka_service_restarter.sh`"
  params      = []
  file_deps   = ["kafka_service_restarter"]
  enabled     = true
  depends_on  = [shoreline_file.kafka_service_restarter]
}

