resource "azurerm_mssql_server" "main" {
  name                         = "${var.group}-sqlserver"
  resource_group_name          = azurerm_resource_group.main.name
  location                     = azurerm_resource_group.main.location
  version                      = "12.0"
  administrator_login          = "el-adm1n"
  administrator_login_password = "dT-Dog01@-bla"
}

resource "azurerm_mssql_database" "main" {
  name           = "db01"
  server_id      = azurerm_mssql_server.main.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
  max_size_gb    = 2
  read_scale     = false
  sku_name       = "S0"
  zone_redundant = false

}

resource "azurerm_mssql_firewall_rule" "main" {
  name             = "Access From Internet"
  server_id        = azurerm_mssql_server.main.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}


resource "random_integer" "ri" {
  min = 10000
  max = 99999
}

resource "azurerm_cosmosdb_account" "main" {
  name                = "tfex-cosmos-db-${random_integer.ri.result}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  offer_type          = "Standard"
  enable_free_tier = true 
  enable_automatic_failover = true


  consistency_policy {
    consistency_level       = "BoundedStaleness"
    max_interval_in_seconds = 300
    max_staleness_prefix    = 100000
  }

  capabilities {
    name = "EnableCassandra"
  }




  geo_location {
    location          = "eastus"
    failover_priority = 1
  }

  geo_location {
    location          = "westus"
    failover_priority = 0
  }

  ip_range_filter = "0.0.0.0"
}

resource "azurerm_cosmosdb_cassandra_keyspace" "main" {
  name                = "tfex-cosmos-cassandra-keyspace"
  resource_group_name = azurerm_cosmosdb_account.main.resource_group_name
  account_name        = azurerm_cosmosdb_account.main.name
  throughput          = 400
}


resource "azurerm_cosmosdb_cassandra_table" "main" {
  name                  = "userlogs"
  cassandra_keyspace_id = azurerm_cosmosdb_cassandra_keyspace.main.id

  schema {
    column {
      name = "logline"
      type = "varchar"
    }

    column {
      name = "user_id"
      type = "varchar"
    }

    partition_key {
      name = "user_id"
    }
  }
}
