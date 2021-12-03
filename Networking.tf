data "aci_vrf" "inb" {
  tenant_dn = "uni/tn-mgmt/ctx-inb"
  name      = "inb"
}

resource "aci_bridge_domain" "bd_data" {
        tenant_dn                   = data.aci_tenant.common.id
        relation_fv_rs_ctx       = aci_vrf.vrf1.id
        name                        = "bd_data"
        arp_flood                   = "yes"
        host_based_routing          = "yes"
    }

resource "aci_bridge_domain" "bd_mgmt" {
        tenant_dn                   = data.aci_tenant.common.id
        relation_fv_rs_ctx       = aci_vrf.inb.id
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
