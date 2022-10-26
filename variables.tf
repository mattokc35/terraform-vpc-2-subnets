variable "ibmcloud_api_key" {
    type = string
    sensitive = true
}

variable "ibm_region" {
    type = string
}

variable "vpc_name" {
    type = string 
}

output "subnet_zone_1" {
    value = ibm_is_subnet.subnet_zone_1.id
}

output "subnet_zone_2" {
    value = ibm_is_subnet.subnet_zone_2.id
}

output "vpc" {
    value = ibm_is_vpc.testacc_vpc.id
}

