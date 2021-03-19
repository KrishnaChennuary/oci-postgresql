data "oci_core_vnic_attachments" "postgresql_master_vnics" {
  compartment_id      = var.compartment_ocid
  availability_domain = var.availablity_domain_name
  instance_id         = oci_core_instance.postgresql_master.id
}


data "oci_core_vnic_attachments" "postgresql_master_primaryvnic_attach" {
  availability_domain = var.availablity_domain_name
  compartment_id      = var.compartment_ocid
  instance_id         = oci_core_instance.postgresql_master.id
}

data "oci_core_vnic" "postgresql_master_primaryvnic" {
  vnic_id = data.oci_core_vnic_attachments.postgresql_master_primaryvnic_attach.vnic_attachments.0.vnic_id
}

data "oci_core_vnic_attachments" "postgresql_hotstandby1_primaryvnic_attach" {
  count               = var.postgresql_deploy_hotstandby1 ? 1 : 0
  availability_domain = var.availablity_domain_name
  compartment_id      = var.compartment_ocid
  instance_id         = oci_core_instance.postgresql_hotstandby1[count.index].id
}

data "oci_core_vnic" "postgresql_hotstandby1_primaryvnic" {
  count   = var.postgresql_deploy_hotstandby1 ? 1 : 0
  vnic_id = data.oci_core_vnic_attachments.postgresql_hotstandby1_primaryvnic_attach[count.index].vnic_attachments.0.vnic_id
}

data "oci_core_vnic_attachments" "postgresql_hotstandby2_primaryvnic_attach" {
  count               = var.postgresql_deploy_hotstandby2 ? 1 : 0
  availability_domain = var.availablity_domain_name
  compartment_id      = var.compartment_ocid
  instance_id         = oci_core_instance.postgresql_hotstandby2[count.index].id
}

data "oci_core_vnic" "postgresql_hotstandby2_primaryvnic" {
  count   = var.postgresql_deploy_hotstandby2 ? 1 : 0
  vnic_id = data.oci_core_vnic_attachments.postgresql_hotstandby2_primaryvnic_attach[count.index].vnic_attachments.0.vnic_id
}


# Get the latest Oracle Linux image
data "oci_core_images" "InstanceImageOCID" {
  compartment_id           = var.compartment_ocid
  operating_system         = var.instance_os
  operating_system_version = var.linux_os_version

  filter {
    name   = "display_name"
    values = ["^.*Oracle[^G]*$"]
    regex  = true
  }
}