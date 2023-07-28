provider "boundary" {
  addr                   = data.terraform_remote_state.boundary.outputs.cluster_url
  auth_method_login_name = var.adm_username
  auth_method_password   = var.adm_password
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

resource "boundary_auth_method" "password" {
  scope_id = boundary_scope.org.id
  type     = "password"
}

resource "boundary_account_password" "user" {
  auth_method_id = boundary_auth_method.password.id
  type           = "password"
  login_name     = var.org_username
  password       = var.org_password
}

resource "boundary_user" "user" {
  name        = var.org_username
  description = "${var.org_username}'s user resource"
  account_ids = [boundary_account_password.user.id]
  scope_id    = boundary_scope.org.id
}