module "upstream-cluster" {
  source = "../terraform-infra-aws"
  aws_access_key = var.aws_secret_key
  aws_secret_key = var.aws_secret_key
  prefix = var.prefix
  instance_count = 1
  instance_ssh_key_name = "leodotcloud"
  ssh_private_key_path = "~/.ssh/id_ed25519"
  #  should_create_security_group = false
}

module "rke" {
  source = "../terraform-rke-cluster"
  depends_on = [module.upstream-cluster]

  node_username = "ubuntu"
  ssh_private_key_pem = "~/.ssh/id_ed25519"

  rancher_nodes = [
    {
      public_ip = module.upstream-cluster.instances_public_ip[0],
      private_ip = module.upstream-cluster.instances_private_ip[0],
      roles = ["etcd", "controlplane", "worker"]
    }
  ]
}

module "rancher_install" {
  source = "../terraform-rancher-install"
  depends_on = [module.rke]

  rancher_hostname = join(".", ["rancher", module.upstream-cluster.instances_public_ip[0], "sslip.io"])
  rancher_replicas  = 1
  rancher_additional_helm_values = [
    "bootstrapPassword: changeme",
  ]
  kubeconfig_file = "./kube_config_cluster.yml"
}
