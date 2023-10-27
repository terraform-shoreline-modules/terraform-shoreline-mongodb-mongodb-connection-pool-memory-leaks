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

module "mongodb_connection_pool_memory_leaks" {
  source    = "./modules/mongodb_connection_pool_memory_leaks"

  providers = {
    shoreline = shoreline
  }
}