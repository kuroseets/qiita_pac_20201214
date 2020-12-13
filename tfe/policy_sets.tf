resource "tfe_policy_set" "s3_policy_set" {
  name          = "s3_policy_set"
  organization  = var.tfe_organization
  policies_path = "/policy_sets/s3_policy_set"
  workspace_ids = [
    tfe_workspace.qiita_pac_aws.id
  ]

  vcs_repo {
    oauth_token_id     = var.tfe_oauth_id
    branch             = "main"
    identifier         = "kuroseets/qiita_pac_20201214"
    ingress_submodules = false
  }
}

resource "tfe_policy_set" "cost_estimate" {
  name          = "cost_estimate"
  organization  = var.tfe_organization
  policies_path = "/policy_sets/cost_estimate"
  workspace_ids = [
  ]

  vcs_repo {
    oauth_token_id     = var.tfe_oauth_id
    branch             = "main"
    identifier         = "kuroseets/qiita_pac_20201214"
    ingress_submodules = false
  }
}

resource "tfe_policy_set" "cost_estimate_test" {
  name          = "cost_estimate_test"
  organization  = var.tfe_organization
  policies_path = "/policy_sets/cost_estimate"
  workspace_ids = [
    tfe_workspace.qiita_pac_aws.id
  ]

  vcs_repo {
    oauth_token_id     = var.tfe_oauth_id
    branch             = "main"
    identifier         = "kuroseets/qiita_pac_20201214"
    ingress_submodules = false
  }
}

resource "tfe_policy_set_parameter" "cost_estimate_test_limit" {
  key           = "limit"
  value         = "50"
  policy_set_id = tfe_policy_set.cost_estimate_test
}
