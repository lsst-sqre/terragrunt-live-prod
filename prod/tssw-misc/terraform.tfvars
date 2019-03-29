terragrunt = {
  include {
    path = "${find_in_parent_folders()}"
  }

  terraform {
    source = "git::https://github.com/lsst-sqre/terraform-tssw-misc.git//tf/?ref=master"
  } # terraform
}

aws_profile = "terragrunt-ts"
aws_region  = "us-west-2"
