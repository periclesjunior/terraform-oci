resource "oci_core_instance" "vm" {
  availability_domain = var.oci_ad
  compartment_id = var.oci_compartment_id
  display_name = var.oci_inst_name
  shape = var.oci_inst_shape
  preserve_boot_volume = false

  source_details {
    source_type = var.oci_inst_src_type
    source_id = var.oci_inst_src_id
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
