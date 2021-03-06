data "aci_vrf" "inb" {
  tenant_dn = "uni/tn-mgmt"
  name      = "inb"
}

resource "aci_bridge_domain" "bd_data" {
        tenant_dn                   = data.aci_tenant.mgmt.id
        relation_fv_rs_ctx       = data.aci_vrf.inb.id
        name                        = "bd_data"
        arp_flood                   = "yes"
        host_based_routing          = "yes"
    }

resource "aci_bridge_domain" "bd_mgmt" {
        tenant_dn                   = data.aci_tenant.mgmt.id
        relation_fv_rs_ctx       = data.aci_vrf.inb.id
        name                        = "bd_mgmt"
        arp_flood                   = "yes"
        host_based_routing          = "yes"

    }

resource "aci_subnet" "bd_data_subnet" {
  parent_dn = "${aci_bridge_domain.bd_data.id}"
  ip        = var.bd_data_subnet
  scope     = ["public"]
}

resource "aci_subnet" "bd_mgmt_subnet" {
  parent_dn = "${aci_bridge_domain.bd_mgmt.id}"
  ip        = var.bd_mgmt_subnet
  scope     = ["public"]
}

data "aci_vmm_domain" "vds" {
  provider_profile_dn = var.provider_profile_dn
  name                = var.vmmDomain
}
