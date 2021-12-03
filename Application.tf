resource "aci_application_profile" "vND_APP" {
  tenant_dn = data.aci_tenant.mgmt.id
  name      = "vND_APP"
}

resource "aci_application_epg" "mgmt_EPG" {
  application_profile_dn = aci_application_profile.vND_APP.id
  name                   = "Mgmt_EPG"
  relation_fv_rs_bd      = aci_bridge_domain.bd_mgmt.id
  #relation_fv_rs_cons    = [aci_contract.contract_epg1_epg2.id, data.aci_contract.default.id]
}

resource "aci_application_epg" "data_EPG" {
  application_profile_dn = aci_application_profile.vND_APP.id
  name                   = "Data_EPG"
  relation_fv_rs_bd      = aci_bridge_domain.bd_data.id
  #relation_fv_rs_cons    = [aci_contract.contract_epg1_epg2.id, data.aci_contract.default.id]
}

resource "aci_epg_to_domain" "vmm_data_EPG" {

  application_epg_dn    = aci_application_epg.data_EPG.id
  tdn                   = data.aci_vmm_domain.vds.id
  vmm_allow_promiscuous = "accept"
  vmm_forged_transmits  = "accept"
  vmm_mac_changes       = "accept"
  instr_imedcy          = "immediate"
  res_imedcy            = "pre-provision"
}

resource "aci_epg_to_domain" "vmm_mgmt_EPG" {

  application_epg_dn    = aci_application_epg.mgmt_EPG.id
  tdn                   = data.aci_vmm_domain.vds.id
  vmm_allow_promiscuous = "accept"
  vmm_forged_transmits  = "accept"
  vmm_mac_changes       = "accept"
  instr_imedcy          = "immediate"
  res_imedcy            = "pre-provision"
}
