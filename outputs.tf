output "activation_toke" {
  value = boundary_worker.controller_led.controller_generated_activation_token
}

output "boundary_cluster" {
  value = local.boundary_cluster_addr
}