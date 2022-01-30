terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "crankysysadmin"

    workspaces {
      name = "tf-eks-learning-cluster"
    }
  }
}
