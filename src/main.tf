# Configure the Google Cloud provider
# It is recommended to use the 'google-beta' provider for Network Connectivity Center
# resources, as features might be in beta or require the beta provider.
provider "google-beta" {
  project = var.project_id
  region  = var.region # Spokes are regional, Hubs are global
}

# Define the Network Connectivity Center Hub
# The hub acts as the central point for network connectivity.
resource "google_network_connectivity_hub" "main_hub" {
  name        = "my-ncc-hub"
  description = "Main NCC Hub for connecting multiple spokes"

  # Optional: Add labels for organization and filtering
  labels = {
    environment = "development"
    owner       = "terraform-user"
  }
}

# Define a map of configurations for each spoke
# This allows for easy creation of multiple spokes with distinct properties.
locals {
  spoke_configs = {
    "spoke-1" = {
      location    = var.region
      vpc_network = "vpc-network-1" # Replace with your actual VPC network name
    },
    "spoke-2" = {
      location    = var.region
      vpc_network = "vpc-network-2"
    },
    "spoke-3" = {
      location    = var.region
      vpc_network = "vpc-network-3"
    },
    "spoke-4" = {
      location    = var.region
      vpc_network = "vpc-network-4"
    },
    "spoke-5" = {
      location    = var.region
      vpc_network = "vpc-network-5"
    },
    "spoke-6" = {
      location    = var.region
      vpc_network = "vpc-network-6"
    },
    "spoke-7" = {
      location    = var.region
      vpc_network = "vpc-network-7"
    }
  }
}

# Create 7 Network Connectivity Center Spokes using a for_each loop
# Each spoke links a specific VPC network to the central hub.
resource "google_network_connectivity_spoke" "spokes" {
  for_each = local.spoke_configs

  name        = "my-${each.key}"
  location    = each.value.location
  description = "Spoke for ${each.value.vpc_network} connected to NCC Hub"
  hub         = google_network_connectivity_hub.main_hub.id # Reference the hub by its ID

  # The 'linked_vpc_network' block is used to specify the VPC network
  # that this spoke connects to the hub. The 'uri' field typically
  # requires the full resource path of the VPC network.
  linked_vpc_network {
    uri = "projects/${var.project_id}/global/networks/${each.value.vpc_network}"
  }

  # Optional: Add labels for organization and filtering
  labels = {
    environment = "development"
    network     = each.value.vpc_network
  }
}
