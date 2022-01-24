resource "oci_core_instance" "vm" {
  availability_domain = var.oci_ad
  compartment_id = var.oci_compartment_id
  display_name = var.oci_inst_name
  preserve_boot_volume = false
  shape = var.oci_inst_shape

  source_details {
    source_type = var.oci_inst_src_type
    source_id = oci_inst_src_id
  }

  create_vnic_details {
    assign_public_ip = true
    display_name = var.oci_inst_name
    subnet_id = oci_core_subnet.subnet.id
  }

  metadata = {
    ssh_authorized_keys = file(var.oci_ssh_public_key) 
  } 

}
