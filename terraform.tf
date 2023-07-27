data "terraform_remote_state" "boundary" {
  backend = "remote"

  config = {
    #organization = "joestack"
    organization = var.tfc_access_organization
    workspaces = {
      #name = "tfc-hcp-vault_cluster"
      name = var.tfc_access_workspace
    }
  }
}