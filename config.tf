variable "base_name" {
  type        = string
  description = "The root name for all the objects"
}
variable "GITHUB_INSTALLATION_ID" {
  type        = number
  description = "The github app installation id for the relevant repo"
}
variable "SNOWFLAKE_ACCOUNT" {
  type = string
}
variable "SNOWFLAKE_DATABASE" {
  type = string
}
variable "SNOWFLAKE_SCHEMA" {
  type = string
}
variable "SNOWFLAKE_WAREHOUSE" {
  type = string
}
variable "SNOWFLAKE_ROLE" {
  type = string
}
variable "SNOWFLAKE_USERNAME" {
  type = string
}
variable "SNOWFLAKE_PASSWORD" {
  type      = string
  sensitive = true
}
variable "USER_EMAIL" {
  type      = string
  sensitive = true
}
variable "dummy_variable" {
  type = string
}