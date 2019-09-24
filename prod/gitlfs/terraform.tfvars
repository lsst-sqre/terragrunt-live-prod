terragrunt = {
  include {
    path = "${find_in_parent_folders()}"
  }

  terraform {
    source = "git::https://github.com/lsst-sqre/terraform-gitlfs.git//tf/?ref=2.0.0"

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
    before_hook "helm_init_1" {
      commands = ["init", "init-from-module"]

      run_on_error = false

      execute = [
        "helm", "init", "--home", "${get_tfvars_dir()}/.helm", "--client-only"
      ]
    }

    before_hook "helm_init_2" {
      commands = ["init"]

      run_on_error = false

      execute = [
        "helm", "repo", "--home", "${get_tfvars_dir()}/.helm", "update"
      ]
    }

    after_hook "helm_deinit" {
      commands = ["destroy"]

      run_on_error = false

      execute = [
        "rm", "-rf", "${get_tfvars_dir()}/.helm"
      ]
    }

    extra_arguments "tls" {
      commands = ["${get_terraform_commands_that_need_vars()}"]

      env_vars = {
        # get_parent_tfvars_dir() is broken when used from a child .tfvars and
        # returns the child path instead of the parent
        # https://github.com/gruntwork-io/terragrunt/issues/332
        TF_VAR_tls_crt_path = "${get_parent_tfvars_dir()}/../../lsst-certs/lsst.codes/2019/lsst.codes_chain.pem"
        TF_VAR_tls_key_path = "${get_parent_tfvars_dir()}/../../lsst-certs/lsst.codes/2019/lsst.codes.key"
      }
    }
  } # terraform
}

# keep `sort -u`d
deploy_name = "gitlfs"
dns_enable = true
env_name = "prod"
github_org = "lsst"
gitlfs_image = "docker.io/lsstsqre/gitlfs-server:gf8df52a"
gke_version = "1.12.7-gke.25"
google_project = "plasma-geode-127520"
google_region = "us-central1"
google_zone = "us-central1-b"
s3_force_destroy = false
