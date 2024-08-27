terraform {
    cloud {
      organization = "signalroom"

        workspaces {
            name = "snowflake-resources-workspace"
        }
  }

  required_providers {
        snowflake = {
            source  = "Snowflake-Labs/snowflake"
            version = "~> 0.94.1"
        }
    }
}
