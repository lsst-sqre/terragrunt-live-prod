terragrunt = {
  include {
    path = "${find_in_parent_folders()}"
  }

  terraform {
    source = "git::https://github.com/lsst-sqre/terraform-lfa.git?ref=1.0.0"
  } # terraform
}

aws_profile = "terragrunt-ts"
aws_region  = "us-west-2"
bucket_name = "lfa-tu-prod"
user = "lfa-tu-prod"
