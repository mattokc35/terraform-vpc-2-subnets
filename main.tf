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
  region = "us-south"
  ibmcloud_api_key = var.ibmcloud_api_key
}

# Create a VPC
resource "ibm_is_vpc" "testacc_vpc" {
  name = "test-vpc"
}

resource "ibm_is_vpc_routing_table" "testacc_vpc" {
  name = "example-routing-table"
  vpc  =  ibm_is_vpc.testacc_vpc.id
}


resource "ibm_is_subnet" "testacc_vpc" {
  name            = "example-subnet"
  vpc             = ibm_is_vpc.testacc_vpc.id
  zone            = "us-south-1"
  ipv4_cidr_block = "10.240.0.0/24"
  routing_table   = ibm_is_vpc_routing_table.testacc_vpc.routing_table

  //User can configure timeouts
  timeouts {
    create = "90m"
    delete = "30m"
  }
}


resource "ibm_is_public_gateway" "testacc_vpc" {
  name = "example-public-gateway"
  vpc  = ibm_is_vpc.testacc_vpc.id
  zone = "us-south-1"
}

resource "ibm_is_subnet_public_gateway_attachment" "testacc_vpc" {
  subnet                = ibm_is_subnet.testacc_vpc.id
  public_gateway         = ibm_is_public_gateway.testacc_vpc.id
}