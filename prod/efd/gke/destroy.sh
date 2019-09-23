#!/bin/bash

# get as far as we can, will eventually fail on k8s resources
terragrunt destroy --refresh=false --auto-approve
# rm all k8s resource related state
terragrunt state list | grep -E 'kubernetes_|helm_' | xargs terragrunt state rm
# should remove the gke cluster...
terragrunt destroy --refresh=false --auto-approve

rm -rf .helm .terragrunt-cache
