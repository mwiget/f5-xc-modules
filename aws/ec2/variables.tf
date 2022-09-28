variable "ssh_private_key_file" {
  type = string
}

variable "ssh_public_key_file" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "aws_az_name" {
  type = string
}

variable "aws_ec2_instance_script" {}

variable "aws_ec2_instance_script_template" {
  type = string
}

variable "aws_ec2_instance_cloud_init_template" {
  type    = string
  default = ""
}

variable "rendered_template_output_path" {
  type    = string
}

variable "aws_ec2_instance_script_file" {
  type = string
}

variable "aws_ec2_instance_name" {
  type = string
}

variable "aws_ec2_instance_type" {
  type = string
}

variable "aws_ec2_private_interface_ips" {
  type = list(string)
}

variable "aws_ec2_public_interface_ips" {
  type = list(string)
}

variable "aws_ec2_instance_custom_data_dirs" {
  type = list(object({
    name        = string
    source      = string
    destination = string
  }))
}

variable "aws_subnet_public_id" {
  type = string
}

variable "aws_subnet_private_id" {
  type = string
}

variable "amis" {
  type        = map(string)
  description = "The amis instances will use - ubuntu 20.04 LTS"

  default = {
    "us-east-1"    = "ami-0708edb40a885c6ee"
    "us-east-2"    = "ami-072e87c1b25ab0a8b"
    "us-west-1"    = "ami-0282af5c116b38803"
    "us-west-2"    = "ami-0e623c4c77b6afcd1"
    "eu-central-1" = "ami-06acd502731e7718e"
    "eu-west-1"    = "ami-0076b212fad243d9e"
    "eu-west-2"    = "ami-0d0f12c129e9acd4f"
    "eu-west-3"    = "ami-06c781daa01c5c4d9"
    "eu-north-1"   = "ami-0d86b044a70ecfc6e"
  }
}

variable "aws_vpc_id" {
  type = string
}

variable "custom_tags" {
  description = "Custom tags to set on resources"
  type        = map(string)
  default     = {}
}

variable "provisioner_connection_type" {
  type    = string
  default = "ssh"
}

variable "provisioner_connection_user" {
  type    = string
  default = "ubuntu"
}