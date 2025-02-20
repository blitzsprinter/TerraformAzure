#################### MAIN ####################
##### RESOURCES
# Create Lab Resource Group
resource "azurerm_resource_group" "mylab" {
  name     = "rg-${var.lab_name}-${var.rg_location}"
  location = var.rg_location
  tags     = var.tags
  lifecycle {
    ignore_changes = [tags, ]
  }
}

##### MODULE vm-jumpbox
module "vm_jumpbox" {
  # Module for deploying jumpbox vm's in their own subnet
  count               = var.enable_module_vm_jumpbox ? 1 : 0
  source              = "./modules/vm-jumpbox"
  lab_name            = var.lab_name
  rg_name             = azurerm_resource_group.mylab.name
  rg_location         = azurerm_resource_group.mylab.location
  vm_snet_id          = azurerm_subnet.snet_0000_jumpbox.id
  vm_jumpwin_hostname = var.vm_jumpwin_hostname
  vm_jumplin_hostname = var.vm_jumplin_hostname
  vm_size             = var.vm_size
  vm_localadmin_user  = var.vm_localadmin_user
  vm_localadmin_pswd  = var.vm_localadmin_pswd
  vm_shutdown_hhmm    = var.vm_shutdown_hhmm
  vm_shutdown_tz      = var.vm_shutdown_tz
  tags                = var.tags
  depends_on = [
    data.azurerm_subnet.snet_0000_jumpbox
  ]
}

##### MODULE sql-ha
module "sql_ha" {
  # Module for deploying SQL High Availability VMs (requires vm-addc AD Domain Controller)
  count                    = var.enable_module_sql_ha ? 1 : 0
  source                   = "./modules/sql-ha"
  lab_name                 = var.lab_name
  rg_name                  = azurerm_resource_group.mylab.name
  rg_location              = azurerm_resource_group.mylab.location
  snet_0128_server_id      = data.azurerm_subnet.snet_0128_server.id
  snet_0064_db1_id         = data.azurerm_subnet.snet_0064_db1.id
  snet_0096_db2_id         = data.azurerm_subnet.snet_0096_db2.id
  snet_0064_db1_prefixes   = data.azurerm_subnet.snet_0064_db1.address_prefixes
  snet_0096_db2_prefixes   = data.azurerm_subnet.snet_0096_db2.address_prefixes
  domain_name              = var.domain_name
  domain_netbios_name      = var.domain_netbios_name
  safemode_admin_pswd      = var.safemode_admin_pswd
  vm_shutdown_tz           = var.vm_shutdown_tz
  vm_addc_hostname         = var.vm_addc_hostname
  vm_addc_localadmin_user  = var.domain_admin_user //NOTE: becomes domain admin after dcpromo
  vm_addc_localadmin_pswd  = var.domain_admin_pswd //NOTE: becomes domain admin after dcpromo
  vm_addc_size             = var.vm_addc_size
  vm_addc_public_ip        = module.sql_ha[0].vm_addc_public_ip
  vm_addc_private_ip       = module.sql_ha[0].vm_addc_private_ip
  vm_sqlha_hostname        = var.vm_sqlha_hostname
  vm_sqlha_size            = var.vm_sqlha_size
  vm_sqlha_localadmin_user = var.vm_localadmin_user
  vm_sqlha_localadmin_pswd = var.vm_localadmin_pswd
  sqlaag_name              = var.sqlaag_name
  sqlcluster_name          = var.sqlcluster_name
  sql_sysadmin_user        = var.sql_sysadmin_user
  sql_sysadmin_pswd        = var.sql_sysadmin_pswd
  sql_svc_acct_user        = var.sql_svc_acct_user
  sql_svc_acct_pswd        = var.sql_svc_acct_pswd
  tags                     = var.tags
  depends_on = [
    azurerm_subnet.snet_0128_server,
    azurerm_subnet.snet_0064_db1,
    azurerm_subnet.snet_0096_db2,
  ]
}

##### MODULE vm-dc1
module "vm_dc1" {
  # Module for deploying first Active Directory Domain Controller in Forest (stand-alone)
  count                   = var.enable_module_dc1 ? 1 : 0
  source                  = "./modules/vm-dc1"
  lab_name                = var.lab_name
  rg_name                 = azurerm_resource_group.mylab.name
  rg_location             = azurerm_resource_group.mylab.location
  vm_server_snet_id       = azurerm_subnet.snet_0128_server.id
  vm_shutdown_tz          = var.vm_shutdown_tz
  vm_localadmin_user      = var.domain_admin_user //NOTE: becomes domain admin after dcpromo
  vm_localadmin_pswd      = var.domain_admin_pswd //NOTE: becomes domain admin after dcpromo
  vm_dc1_hostname         = var.vm_dc1_hostname
  vm_dc1_size             = var.vm_dc1_size
  vm_dc1_shutdown_hhmm    = var.vm_dc1_shutdown_hhmm
  dc1_domain_name         = var.dc1_domain_name
  dc1_domain_netbios_name = var.dc1_domain_netbios_name
  dc1_safemode_admin_pswd = var.safemode_admin_pswd
  tags                    = var.tags
  depends_on = [
    data.azurerm_subnet.snet_0128_server
  ]
}
