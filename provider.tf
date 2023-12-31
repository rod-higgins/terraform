
terraform {
  required_version = ">= 1.5.7"
}

provider "aws" {
  region = var.region
  profile = "ttn"
}

# Not required: currently used in conjunction with using
# icanhazip.com to determine local workstation external IP
# to open EC2 Security Group access to the Kubernetes cluster.
# See workstation-external-ip.tf for additional information.
provider "http" {}