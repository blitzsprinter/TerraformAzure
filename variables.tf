#################### VARIABLES ####################
########## SECRETS VARIABLES 
#####  Declare confidential variables here
#####  Store secret values in *.tfvars file
#####  Check .gitingnore in repo for details
########## SECRETS VARIABLES 

variable "arm_tenant_id" {
  type        = string
  description = "azure tenant id"
  sensitive   = true
}

variable "arm_subscription_id" {
  type        = string
  description = "azure subscription id"
  sensitive   = true
}

variable "arm_client_id" {
  type        = string
  description = "azure service principle id"
  sensitive   = true
}

variable "arm_client_secret" {
  type        = string
  description = "azure service principle secret"
  sensitive   = true
}

variable "vm_localadmin_user" {
  type        = string
  default     = "localadmin"
  description = "vm local admin username"
  sensitive   = true
}

variable "vm_localadmin_pswd" {
  type        = string
  default     = "P@ssw0rd!"
  description = "vm local admin password"
  sensitive   = true
}

##### RESOURCE VARIABLES
variable "lab_name" {
  type        = string
  default     = "mylab"
  description = "lab name (suggest 'lab', 'dev', 'qa', 'test', etc)"
}

variable "rg_location" {
  type        = string
  default     = "westus"
  description = "azure region for lab"
}

variable "tags" {
  type = map(string)
  default = {
    "source"      = "terraform"
    "project"     = "learning"
    "environment" = "lab"
  }
}

########## vm-jumpBox
# vm-jumpWin Hostname
variable "vm_jumpwin_hostname" {
  type        = string
  default     = "jumpwin007" // fail if not unique in public DNS
  description = "Computername for the windows-vm jumpbox"
}
# vm-jumpLin Hostname
variable "vm_jumplin_hostname" {
  type        = string
  default     = "jumplin008" // fail if not unique in public DNS
  description = "Computername for the linux-vm jumpbox"
}

# vm common Variables
variable "vm_size" {
  type        = string
  default     = "Standard_D2s_v3" // 2 x vCPU + 8gb RAM
  description = "The size of the Virtual Machine(s) type."
}

variable "vm_shutdown_hhmm" {
  type        = string
  default     = "0000" // midnight ;-)
  description = "Time for VM Shutdown HHMM"
}

variable "vm_shutdown_tz" {
  type        = string
  default     = "Pacific Standard Time"
  description = "Time Zone for VM Shutdown"
}
