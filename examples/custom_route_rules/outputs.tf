output "module_vcn" {
  description = "vcn and gateways information"
  value = {
    drg_id              = module.vcn.drg_id
    internet_gateway_id = module.vcn.internet_gateway_id
    nat_gateway_id      = module.vcn.nat_gateway_id
    service_gateway_id  = module.vcn.service_gateway_id
    vcn_id              = module.vcn.vcn_id
  }
}

output "local_peering_gateway" {
  description = "local peering gateways information"
  value       = oci_core_local_peering_gateway.lpg.id
}