provider "snowflake" {
  role = "SYSADMIN"
}
resource "snowflake_database" "database" {
  name = "example_data_lakehouse"
}

resource "snowflake_warehouse" "warehouse" {
  name           = "example_data_lakehouse"
  warehouse_size = "xsmall"
  auto_suspend   = 60
}