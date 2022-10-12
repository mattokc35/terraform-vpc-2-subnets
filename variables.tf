variable "ibmcloud_api_key" {
    type = string
    sensitive = true
}

variable "ibm_region" {
    type = string
    default = "us-south"
}

variable "vpc_name" {
    type = string 
}

output "ibmcloud_api_key" {
    value = var.ibmcloud_api_key
    sensitive = true
}

output "subnet" {
    value = ibm_is_subnet.testacc_vpc.id
}

output "vpc" {
    value = ibm_is_vpc.testacc_vpc.id
}

