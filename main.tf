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
  name = "${var.vpc_name}"
}

resource "ibm_is_vpc_routing_table" "testacc_vpc" {
  name = "testacc-vpc-routing-table"
  vpc  =  ibm_is_vpc.testacc_vpc.id


}

resource "ibm_is_vpc_address_prefix" "prefix1" {
  cidr = "10.0.1.0/24"
  name = "testacc-vpc-add-prefix-1"
  vpc  = ibm_is_vpc.testacc_vpc.id
  zone = "${var.ibm_region}-1"
}

resource "ibm_is_vpc_address_prefix" "prefix2" {
  cidr = "172.21.8.0/21"
  name = "testacc-vpc-add-prefix-2"
  vpc  = ibm_is_vpc.testacc_vpc.id
  zone = "${var.ibm_region}-2"
}

resource "ibm_is_subnet" "subnet_zone_1" {
  depends_on = [
    ibm_is_vpc_address_prefix.prefix1
  ]
  ipv4_cidr_block = "10.0.1.0/24"
  name            = "testacc-vpc-subnet-zone-1"
  vpc             = ibm_is_vpc.testacc_vpc.id
  zone            = "${var.ibm_region}-1"
  

  //User can configure timeouts
  timeouts {
    create = "90m"
    delete = "30m"
  }
}

resource "ibm_is_subnet" "subnet_zone_2" {
  depends_on = [
    ibm_is_vpc_address_prefix.prefix2
  ]
  ipv4_cidr_block = "172.21.8.0/21"
  name            = "testacc-vpc-subnet-zone-2"
  vpc             = ibm_is_vpc.testacc_vpc.id
  zone            = "${var.ibm_region}-2"
  

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
  subnet                = ibm_is_subnet.subnet_zone_1.id
  public_gateway         = ibm_is_public_gateway.testacc_vpc.id
}

