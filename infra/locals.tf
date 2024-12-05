locals {
  cluster_name           = "kent-us-c1"
  network_name           = "kent-us-c1-private-network"
  subnet_name            = "kent-us-c1-private-subnet"
  master_auth_subnetwork = "kent-us-c1-private-master-subnet"
  pods_range_name        = "ip-range-pods-kent-us-c1-private"
  svc_range_name         = "ip-range-svc-kent-us-c1-private"
  subnet_names           = [for subnet_self_link in module.gcp-network.subnets_self_links : split("/", subnet_self_link)[length(split("/", subnet_self_link)) - 1]]
}
