resource "tfe_workspace" "qiita_pac_tfe" {
  name              = "qiita_pac_tfe"
  organization      = var.tfe_organization
  terraform_version = "0.13.5"
  queue_all_runs    = false
  working_directory = "tfe"
  vcs_repo {
    oauth_token_id     = var.tfe_oauth_id
    branch             = "main"
    identifier         = "kuroseets/qiita_pac_20201214"
    ingress_submodules = false
  }
}

resource "tfe_workspace" "qiita_pac_aws" {
  name              = "qiita_pac_aws"
  organization      = var.tfe_organization
  terraform_version = "0.13.5"
  queue_all_runs    = false
  working_directory = "aws"
  vcs_repo {
    oauth_token_id     = var.tfe_oauth_id
    branch             = "main"
    identifier         = "kuroseets/qiita_pac_20201214"
    ingress_submodules = false
  }
}
