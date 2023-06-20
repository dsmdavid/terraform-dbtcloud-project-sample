## Sample config file for dbtcloud terraform provider
This repo uses the terraform provider to interact with [dbt Cloud](https://github.com/dbt-labs/terraform-provider-dbtcloud/tree/main)

# Steps:
1. This requires some environmental variables defined and accessible to the TF plan / apply.
2. It also requires an existing dbt Cloud account, alongside with an `Account Admin` token.
3. Sample env file:
```
export TF_VAR_SNOWFLAKE_ACCOUNT="account_identifier.eu-west-1"
export TF_VAR_SNOWFLAKE_DATABASE="database_name"
export TF_VAR_SNOWFLAKE_WAREHOUSE="warehouse_name"
export TF_VAR_SNOWFLAKE_ROLE="role_name"
export TF_VAR_SNOWFLAKE_USERNAME="user_name"
export TF_VAR_SNOWFLAKE_PASSWORD="user_password"
export TF_VAR_SNOWFLAKE_SCHEMA="schema_name"
export TF_VAR_USER_EMAIL="dbtcloud email"
export DBT_CLOUD_ACCOUNT_ID=<numeric account_id>
export DBT_CLOUD_TOKEN="dbts_TOKEN"
export TF_VAR_GITHUB_INSTALLATION_ID=<numeric github installation id>
export TF_VAR_base_name="base_name_to_use",
```
These can be provided as environmental variables or the .tfvars / .tfvars.json files can be used for non-sensitive ones.

4. Terraform plan / apply