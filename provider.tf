provider "oci" {
  region              = var.oci_region
  auth                = var.auth_mode
  config_file_profile = var.oci_profile
}
