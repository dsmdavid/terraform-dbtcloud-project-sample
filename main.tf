terraform {
  required_providers {
    dbtcloud = {
      source  = "dbt-labs/dbtcloud"
      version = "0.2"
    }
  }
}

provider "dbtcloud" {

}

# first provider
# get data
# data "external" "env" {
#     program = ["${path.module}/envs/env.sh"]
# }


# create project before being able to create connections, etc. 

resource "dbtcloud_project" "dvd_terraform_project_test" {
  name = "${var.base_name}_project"
}


# generic groups can be created at any time,
# groups that are attached to specific projects need to be created after 
# the project is created
resource "dbtcloud_group" "dvd_terraform_test" {
  name = "${var.base_name}_group_analyst"
  group_permissions {
    permission_set = "analyst"
    all_projects   = true
  }
}

resource "dbtcloud_group" "dvd_terraform_test_second_group" {
  name = "${var.base_name}_git_admin"
  group_permissions {
    permission_set = "git_admin"
    all_projects   = true
  }
}

resource "dbtcloud_group" "dvd_terraform_test_third" {
  name = "dvd_test_terraform_third_group"
  group_permissions {
    permission_set = "analyst"
    all_projects   = false
    project_id     = dbtcloud_project.dvd_terraform_project_test.id
  }
}

# repo needs a project
resource "dbtcloud_repository" "dvd_terraform_github_repo" {
  project_id = dbtcloud_project.dvd_terraform_project_test.id
  remote_url = "git://github.com/dsmdavid/dbt_cloud_starter.git"
  # to get the github_installation_id:
  # a) go to github > settings > Applications > dbt cloud > configure
  # the url would be https://github.com/settings/installations/<github_installation_id>
  # b) go to https://cloud.getdbt.com/api/v2/integrations/github/installations/
  # and retrieve the "id" value (where "cloud.getdbt.com" is the "dbt_cloud_url")
  # of the relevant integration / org (there could be multiple, e.g. single user
  # in mulitple organitsations!)

  github_installation_id = var.github_installation_id
  git_clone_strategy     = "github_app"
}

# project repository links repo with project, needs to be
# created after both

resource "dbtcloud_project_repository" "dvd_terraform_project_repository_test" {
  project_id    = dbtcloud_project.dvd_terraform_project_test.id
  repository_id = dbtcloud_repository.dvd_terraform_github_repo.repository_id
}

# connection is created after project
resource "dbtcloud_connection" "dvd_terraform_snowflake_connection" {
  project_id = dbtcloud_project.dvd_terraform_project_test.id
  type       = "snowflake"
  name       = "dvd Terraform Snowflake"
  # alternatively, this could be set up to environmental variables 
  # defined in the dbt cloud project, e.g.:
  # account          = "{{ env_var('DBT_ENV_ACCOUNT_ID') }}"
  # or it could be set directly with the variables available for Terraform. 
  # account    = var.SNOWFLAKE_ACCOUNT
  account    = "{{ env_var('DBT_ENV_ACCOUNT_ID') }}"
  database   = var.SNOWFLAKE_DATABASE
  warehouse  = var.SNOWFLAKE_WAREHOUSE
  role       = var.SNOWFLAKE_ROLE
}

# the project_connection bridges project and connection and
# needs to be created after both.
resource "dbtcloud_project_connection" "dvd_terraform_connection_test" {
  project_id    = dbtcloud_project.dvd_terraform_project_test.id
  connection_id = dbtcloud_connection.dvd_terraform_snowflake_connection.connection_id

}


# environment
resource "dbtcloud_environment" "dvd_terraform_env_development" {
  # dbt_versions: [1.0.1, 1.4.0-latest, 1.6.0-pre,...]
  dbt_version   = "1.4.0-latest"
  name          = "dvd_terraform_env_development"
  project_id    = dbtcloud_project.dvd_terraform_project_test.id
  type          = "deployment"
  credential_id = dbtcloud_snowflake_credential.dvd_terraform_snowflake_credential.credential_id
}
resource "dbtcloud_snowflake_credential" "dvd_terraform_snowflake_credential" {
  project_id  = dbtcloud_project.dvd_terraform_project_test.id
  auth_type   = "password"
  user        = var.SNOWFLAKE_USERNAME
  password    = var.SNOWFLAKE_PASSWORD
  schema      = var.SNOWFLAKE_SCHEMA
  num_threads = 4
}
data "dbtcloud_user" "user_david" {
  email = var.USER_EMAIL
}



# output "env" {
#     value = data.external.env.result
# }
