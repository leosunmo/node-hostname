# Set the required Terraform provider
terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }
  required_version = ">= 1.0.0"
}

# Provider configuration
provider "google" {
  project     = var.project_id
  region      = var.region
}

# Variables
variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The GCP region"
  type        = string
  default     = "us-central1"
}

# Enable GKE API
resource "google_project_service" "enable_gke_api" {
  project = var.project_id
  service = "container.googleapis.com"
}
