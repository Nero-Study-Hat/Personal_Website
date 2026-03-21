output "server_eip_id" {
    description = "EIP used by the public server."
    value       = module.network.server_eip_address
}