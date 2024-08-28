variable "aws_profile" {
    description = "The AWS Landing Zone Profile."
    type        = string
}

variable "aws_region" {
    description = "The AWS Region."
    type        = string
}

variable "aws_account_id" {
    description = "The AWS Account ID."
    type        = string
}

variable "aws_access_key_id" {
    description = "The AWS Access Key ID."
    type        = string
    default     = ""
}

variable "aws_secret_access_key" {
    description = "The AWS Secret Access Key."
    type        = string
    default     = ""
}

variable "aws_session_token" {
    description = "The AWS Session Token."
    type        = string
    default     = ""
}

variable "snowflake_account" {
    description = "The Snowflake Account identifer issued to your organization."
    type        = string
    default     = ""
}
variable "snowflake_user" {
    description = "The Snowflake User who is to be assigned the RSA key pairs for its authentication."
    type        = string
    default     = ""
}

variable "snowflake_password" {
    description = "Specifies the Snowflake password."
    type        = string
    default     = ""
}
