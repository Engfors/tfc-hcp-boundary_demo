locals {
  boundary_cluster_addr = data.terraform_remote_state.boundary.outputs.cluster_url
  #boundary_worker_token = boundary_worker.controller_led.controller_generated_activation_token
}

provider "boundary" {
  #addr                   = data.terraform_remote_state.boundary.outputs.cluster_url
  addr                   = local.boundary_cluster_addr
  auth_method_login_name = var.adm_username
  auth_method_password   = var.adm_password
}


resource "boundary_scope" "global" {
  global_scope = true
  scope_id     = "global"
}

resource "boundary_scope" "org" {
  name                     = "Demo organization_one"
  description              = "Dedicated scope for demonstration purpose"
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
  #type           = "password"
  login_name     = var.org_username
  password       = var.org_password
}

resource "boundary_user" "user" {
  name        = var.org_username
  description = "${var.org_username}'s user resource"
  account_ids = [boundary_account_password.user.id]
  scope_id    = boundary_scope.org.id
}

resource "boundary_role" "org_admin" {
  name          = "org_admin"
  description   = "Admin role within Demo Org"
  principal_ids = [boundary_user.user.id]
  grant_strings = ["id=*;type=*;actions=*"]
  scope_id      = boundary_scope.org.id
}

resource "boundary_scope" "project" {
  name                   = "Demo Project_one"
  description            = "First Project within Demo's Org scope!"
  scope_id               = boundary_scope.org.id
  auto_create_admin_role = true
}

resource "boundary_worker" "controller_led" {
  depends_on = [ 
    boundary_scope.project,
    boundary_role.org_admin,
    boundary_user.user
    ]
  scope_id    = boundary_scope.org.id
  name        = "worker 1"
  description = "self managed worker with controller led auth"
}