provider "snowflake" {
  role     = "SYSADMIN"
  account  = var.snowflake_account
  user     = var.snowflake_user
  password = var.snowflake_password
}
resource "snowflake_database" "database" {
  name = "example_data_lakehouse"
}

resource "snowflake_warehouse" "warehouse" {
  name           = "example_data_lakehouse"
  warehouse_size = "xsmall"
  auto_suspend   = 60
}