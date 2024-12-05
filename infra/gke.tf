# google_client_config and kubernetes provider must be explicitly specified like the following.

data "google_client_config" "default" {}

provider "kubernetes" {
  host                   = "https://${module.gke.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
}

module "gke" {
  source                          = "terraform-google-modules/kubernetes-engine/google//modules/beta-autopilot-public-cluster/"
  version                         = "~> 34.0"
  project_id                      = var.project_id
  name                            = local.cluster_name
  regional                        = true
  region                          = var.region
  network                         = module.gcp-network.network_name
  subnetwork                      = local.subnet_names[index(module.gcp-network.subnets_names, local.subnet_name)]
  ip_range_pods                   = local.pods_range_name
  ip_range_services               = local.svc_range_name
  release_channel                 = "REGULAR"
  enable_vertical_pod_autoscaling = true # Required for autopilot clusters.
  network_tags                    = [local.cluster_name]
  deletion_protection             = false # Enable in production.
  enable_l4_ilb_subsetting        = true
  stateful_ha                     = false

  # Addons
  horizontal_pod_autoscaling = true
  http_load_balancing        = true
}
