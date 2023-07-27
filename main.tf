provider "boundary" {
  addr                   = data.terraform_remote_state.boundary.outputs.cluster_url
  auth_method_login_name = var.username
  auth_method_password   = var.password
}


resource "boundary_scope" "global" {
  global_scope = true
  scope_id     = "global"
}

resource "boundary_scope" "org" {
  name                     = "organization_one"
  description              = "My first scope!"
  scope_id                 = boundary_scope.global.id
  auto_create_admin_role   = true
  auto_create_default_role = true
}