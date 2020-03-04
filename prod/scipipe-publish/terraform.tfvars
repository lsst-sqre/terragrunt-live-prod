terragrunt = {
  include {
    path = "${find_in_parent_folders()}"
  }

  terraform {
    source = "git::https://github.com/lsst-sqre/terraform-scipipe-publish.git//tf/?ref=3.4.1"

    # set HELM_HOME to prevent sharing helm state between deployments
    extra_arguments "helm_vars" {
      commands = ["${get_terraform_commands_that_need_vars()}"]
      env_vars = {
        HELM_HOME = "${get_tfvars_dir()}/.helm"
      }
    }

    # helm requires manual init
    before_hook "1_helm_init" {
      commands = ["${get_terraform_commands_that_need_locking()}"]
      execute = [
        "helm", "init", "--home", "${get_tfvars_dir()}/.helm", "--client-only",
      ]
      run_on_error = false
    }

    before_hook "2_helm_update" {
      commands = ["init"]
      execute = [
        "helm", "repo", "--home", "${get_tfvars_dir()}/.helm", "update"
      ]
      run_on_error = false
    }
  } # terraform
}

# keep `sort -u`d
aws_zone_id = "Z3TH0HRSNU67AM"
dns_enable = true
domain_name = "lsst.codes"
env_name = "prod"
gke_version = "1.14.10-gke.24"
google_project = "plasma-geode-127520"
google_region =  "us-central1"
google_zone = "us-central1-b"
grafana_oauth_team_ids = "1936535"
pkgroot_storage_size = "2Ti"
prometheus_oauth_github_org = "lsst-sqre"
