output "activation_token" {
  value = boundary_worker.controller_led.controller_generated_activation_token
}

output "boundary_cluster" {
  value = local.boundary_cluster_addr
}

output "demo_org_id" {
  value = boundary_scope.org.id
}

output "demo_project_id" {
  value = boundary_scope.project.id
}