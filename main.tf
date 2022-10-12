terraform {
  required_providers {
    ibm = {
      source = "IBM-Cloud/ibm"
      version = ">= 1.12.0"
    }
  }
}

# Configure the IBM Provider
provider "ibm" {
  region = "${var.ibm_region}"
  ibmcloud_api_key = var.ibmcloud_api_key
}

# Create a VPC
resource "ibm_is_vpc" "testacc_vpc" {
  name = "${vpc_name}"
}

resource "ibm_is_vpc_routing_table" "testacc_vpc" {
  name = "testacc-vpc-routing-table"
  vpc  =  ibm_is_vpc.testacc_vpc.id


}

resource "ibm_is_vpc_address_prefix" "testacc_vpc" {
  cidr = "10.0.1.0/24"
  name = "testacc-vpc-add-prefix"
  vpc  = ibm_is_vpc.testacc_vpc.id
  zone = "${var.ibm_region}-1"
}

resource "ibm_is_subnet" "testacc_vpc" {
  depends_on = [
    ibm_is_vpc_address_prefix.testacc_vpc
  ]
  ipv4_cidr_block = "10.0.1.0/24"
  name            = "testacc-vpc-subnet"
  vpc             = ibm_is_vpc.testacc_vpc.id
  zone            = "${var.ibm_region}-1"
  

  //User can configure timeouts
  timeouts {
    create = "90m"
    delete = "30m"
  }
}


//public gateway

resource "ibm_is_public_gateway" "testacc_vpc" {
  name = "testacc-vpc-public-gateway"
  vpc  = ibm_is_vpc.testacc_vpc.id
  zone = "${var.ibm_region}-1"
}

resource "ibm_is_subnet_public_gateway_attachment" "testacc_vpc" {
  subnet                = ibm_is_subnet.testacc_vpc.id
  public_gateway         = ibm_is_public_gateway.testacc_vpc.id
}

