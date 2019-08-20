terragrunt = {
  include {
    path = "${find_in_parent_folders()}"
  }

  terraform {
    source = "git::https://github.com/lsst-sqre/terraform-efd-gke.git//?ref=4.1.0"
    # for development it is useful to use a local path
    # source = "../../../terraform-efd-kafka"
    extra_arguments "moar_faster" {
      commands = ["apply"]
      arguments = ["-parallelism=25"]
    }

    # set HELM_HOME to prevent sharing helm state between deployments
    extra_arguments "helm_vars" {
      commands = ["${get_terraform_commands_that_need_vars()}"]
      env_vars = {
        HELM_HOME = "${get_tfvars_dir()}/.helm"
      }
    }

    before_hook "tf_plugins" {
      commands = ["init", "init-from-module"]

      run_on_error = false

      execute = [
        "bash", "-c", "cd ${get_tfvars_dir()}; make"
      ]
    }


    # helm requires manual init
    before_hook "1_helm_init" {
      commands = ["${get_terraform_commands_that_need_locking()}"]
      execute = [
        "helm", "--home", "${get_tfvars_dir()}/.helm", "init", "--client-only",
      ]
      run_on_error = false
    }

    before_hook "2_helm_update" {
      commands = ["init"]
      execute = [
        "helm", "--home", "${get_tfvars_dir()}/.helm", "repo", "update",
      ]
      run_on_error = false
    }

    # the helm.helm_repository resource DOES NOT handle the repo existing in
    # the tf state but not existing in the local helm repo config.

    before_hook "3_helm_repo_add" {
      commands = ["${get_terraform_commands_that_need_locking()}"]
      execute = [
        "helm", "--home", "${get_tfvars_dir()}/.helm", "repo", "add", "confluentinc",
        "https://raw.githubusercontent.com/lsst-sqre/cp-helm-charts/0.1.1"
      ]
      run_on_error = false
    }

    before_hook "4_helm_repo_add" {
      commands = ["${get_terraform_commands_that_need_locking()}"]
      execute = [
        "helm", "--home", "${get_tfvars_dir()}/.helm", "repo", "add", "lsstsqre",
        "https://lsst-sqre.github.io/charts/"
      ]
      run_on_error = false
    }
  } # terraform
}

# keep `sort`d
dns_enable = true
env_name = "prod"
gke_version = "1.13.6-gke.13"
grafana_oauth_team_ids = "1936535,2003784" # lsst-sqre/friends == 2003784
initial_node_count = 4
machine_type = "n1-standard-4"
