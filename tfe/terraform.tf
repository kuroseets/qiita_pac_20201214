terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "kuroseets"

    workspaces {
      name = "qiita_pac_tfe"
    }
  }
}
