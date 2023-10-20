terraform {
  required_version = ">= 0.13.1"

  required_providers {
    shoreline = {
      source  = "shorelinesoftware/shoreline"
      version = ">= 1.11.0"
    }
  }
}

provider "shoreline" {
  retries = 2
  debug = true
}

module "kafka_leader_election_failures_incident" {
  source    = "./modules/kafka_leader_election_failures_incident"

  providers = {
    shoreline = shoreline
  }
}