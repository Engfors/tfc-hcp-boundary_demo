data "terraform_remote_state" "boundary" {
  backend = "remote"

  config = {
    #organization = "joestack"
    organization = var.tfc_state_org
    workspaces = {
      #name = "tfc-hcp-vault_cluster"
      name = var.tfc_state_ws
    }
  }
}