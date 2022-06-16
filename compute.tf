data "oci_core_images" "image" {
  compartment_id           = var.oci_compartment_id
  shape                    = var.oci_inst_shape
  operating_system         = var.oci_shape_os
  operating_system_version = var.oci_shape_os_version
}

resource "oci_core_instance" "vm" {
  count = var.oci_inst_count
  display_name = "vm-00${count.index + 1}"
  availability_domain = var.oci_ad
  compartment_id = var.oci_compartment_id
  shape = var.oci_inst_shape
  preserve_boot_volume = false

  shape_config {
    memory_in_gbs = "6"
    ocpus         = "1"
  }

  source_details {
    source_type = var.oci_inst_src_type
    source_id = data.oci_core_images.image.images[0].id
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
