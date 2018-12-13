terragrunt = {
  remote_state {
    backend = "s3"

    config {
      bucket         = "lsstsqre-tf-state-prod"
      key            = "${path_relative_to_include()}/terraform.tfstate"
      region         = "us-west-2"
      encrypt        = true
      dynamodb_table = "lsstsqre-tf-lock-prod"

      s3_bucket_tags {
        owner = "terragrunt integration prod"
        name  = "Terraform state storage"
      }

      dynamodb_table_tags {
        owner = "terragrunt integration prod"
        name  = "Terraform lock table"
      }
    }
  }

  terraform {
    # do not prompt for confirmation when running apply
    extra_arguments "auto_apply" {
      commands  = ["apply"]
      arguments = ["-auto-approve"]
    }
  }
}

google_project = "plasma-geode-127520"
aws_zone_id = "Z3TH0HRSNU67AM"
domain_name = "lsst.codes"
