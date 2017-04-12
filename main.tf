#
# DO NOT DELETE THESE LINES!
#
# Your AMI ID is:
#
#     ami-eea9f38e
#
# Your subnet ID is:
#
#     subnet-b30f9ceb
#
# Your security group ID is:
#
#     sg-834d35e4
#
# Your Identity is:
#
#     autodesk-dragonfly
#

terraform {
  backend "atlas" {
    name = "sct10876/training"
  }
}

variable "aws_access_key" {
  type = "string"
}

variable "aws_secret_key" {
  type = "string"
}

variable "aws_region" {
  type    = "string"
  default = "us-west-1"
}

variable "num_webs" {
  default = "3"
}

provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.aws_region}"
}

resource "aws_instance" "web" {
  count                  = "2"
  ami                    = "ami-eea9f38e"
  instance_type          = "t2.micro"
  subnet_id              = "subnet-b30f9ceb"
  vpc_security_group_ids = ["sg-834d35e41"]

  tags {
    Identity = "autodesk-dragonfly"
    Org      = "CI-Network"
    Name     = "Web ${count.index+1}/${var.num_webs}"
  }
}

output "public_ip" {
  value = ["${aws_instance.web.*.public_ip}"]
}

output "public_dns" {
  value = ["${aws_instance.web.*.public_dns}"]
}
