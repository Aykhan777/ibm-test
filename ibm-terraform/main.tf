terraform {
  required_providers {
    ibm = {
      source  = "IBM-Cloud/ibm"
      version = "~> 1.60"
    }
  }
  required_version = ">= 1.5.0"
}

provider "ibm" {
  ibmcloud_api_key = var.ibmcloud_api_key
  region           = var.region
}

variable "ibmcloud_api_key" {}
variable "region" {
  default = "us-south"
}

# Default resource group
data "ibm_resource_group" "default" {
  name = "Default"
}

# Create a VPC
resource "ibm_is_vpc" "vpc" {
  name = "tf-vpc"
}

# Create a public subnet
resource "ibm_is_subnet" "public_subnet" {
  name                     = "tf-public-subnet"
  vpc                      = ibm_is_vpc.vpc.id
  zone                     = "${var.region}-1"
  total_ipv4_address_count = 256
}

# VPC Kubernetes cluster
resource "ibm_container_vpc_cluster" "cluster" {
  name              = "cheap-k8s"
  vpc_id            = ibm_is_vpc.vpc.id
  resource_group_id = data.ibm_resource_group.default.id
  flavor            = "bx2.2x8"
  worker_count      = 1

  zones {
    name      = "${var.region}-1"
    subnet_id = ibm_is_subnet.public_subnet.id
  }
}

output "cluster_name" {
  value = ibm_container_vpc_cluster.cluster.name
}

output "cluster_id" {
  value = ibm_container_vpc_cluster.cluster.id
}

