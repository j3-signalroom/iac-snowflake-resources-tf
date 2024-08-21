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

variable "snowflake_account_id" {
    description = "Specifies the Snowflake Account ID."
    type        = string
    default     = ""
}

variable "snowflake_login_url" {
    description = "Specifies the Snowflake login URL."
    type        = string
    default     = ""
}

variable "snowflake_username" {
    description = "Specifies the Snowflake user name."
    type        = string
    default     = ""
}

variable "snowflake_password" {
    description = "Specifies the Snowflake password."
    type        = string
    default     = ""
}
