variable "project_id" {
  description = "The GCP project ID where resources will be created."
  type        = string
}

variable "region" {
  description = "The GCP region for regional resources like spokes."
  type        = string
  default     = "us-central1" # You can change this default region
}
