resource "shoreline_notebook" "mongodb_connection_pool_memory_leaks" {
  name       = "mongodb_connection_pool_memory_leaks"
  data       = file("${path.module}/data/mongodb_connection_pool_memory_leaks.json")
  depends_on = [shoreline_action.invoke_mongo_config_update]
}

resource "shoreline_file" "mongo_config_update" {
  name             = "mongo_config_update"
  input_file       = "${path.module}/data/mongo_config_update.sh"
  md5              = filemd5("${path.module}/data/mongo_config_update.sh")
  description      = "Adjust the configuration settings of the MongoDB connection pool to more efficiently manage database connections and prevent memory leaks. This may involve adjusting connection timeouts, max pool size, and other settings."
  destination_path = "/tmp/mongo_config_update.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_mongo_config_update" {
  name        = "invoke_mongo_config_update"
  description = "Adjust the configuration settings of the MongoDB connection pool to more efficiently manage database connections and prevent memory leaks. This may involve adjusting connection timeouts, max pool size, and other settings."
  command     = "`chmod +x /tmp/mongo_config_update.sh && /tmp/mongo_config_update.sh`"
  params      = ["NEW_MAX_POOL_SIZE","NEW_CONNECTION_TIMEOUT","PATH_TO_MONGO_CONFIG_FILE"]
  file_deps   = ["mongo_config_update"]
  enabled     = true
  depends_on  = [shoreline_file.mongo_config_update]
}

