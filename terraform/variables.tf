
variable "aws_region" {
    type    = string
    default = "eu-central-1"
    description = "Default region"
}

variable "instance_count" {
    type    = number
    default = 2
    description = "Instances count"
}

variable "template_script_path" {
    type    = string
    default = "template/WebServersInit.sh"
    description = "Path for deploy template"
}

variable "environment" {
    type    = string
    default = "dev"
    description = "Environment"
}

variable "build_number" {
    type    = number
    default = 0
    description = "Jenkins build number"
}

variable "imageName" {
    type    = string
    default = "kromelky/application"
    description = "Image file"
}

variable "docker_login" {
    type    = string
    default = "jenkins"
    description = "Image file"
}

variable "docker_pass" {
    type    = string
    description = "Image file"
}

variable "docker_image_name" {
    type    = string
    default = "kromelky/application1"
    description = "Image file"
}

variable "instance_label" {
    type    = string
    default = "2"
    description = "Instance label"
}

variable "ami_key_pair_name" {
    type    = string
    default = "dev2_key"
    description = "Pem key file name"
}

variable "vpc_cidr" {
  type        = string
  default     = "192.168.0.0/16"
  description = "CIDR for VPC"
}

variable "tenancy" {
  type        = string
  default     = "default"
  description = ""
}

variable "enable_dns_support" {
    default = true
}

variable "enable_dns_hostnames" {
    default = true
}

variable "vpc_name" {
  type        = string
  default     = "mainvpc"
  description = ""
}

variable "public_cidr" {
  type        = string
  default     = "192.168.1.0/24"
  description = "CIDR for VPC"
}