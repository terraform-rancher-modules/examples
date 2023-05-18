variable "aws_access_key" {
  type        = string
  description = "AWS access key used to create infrastructure"
}

variable "aws_secret_key" {
  type        = string
  description = "AWS secret key used to create AWS infrastructure"
}

variable "aws_region" {
  type        = string
  description = "AWS region used for all resources"
}

# Required
variable "prefix" {
  type        = string
  description = "Prefix added to names of all resources"
}

#variable "kubeconfig_file" {
#  description = "The kubeconfig to use to interact with the cluster"
#  default     = "~/.kube/config"
#  type        = string
#}

variable "instance_count" {
  type    = number
  description = "Number of EC2 instances to create"
  default = 3
}

