# centos.tf
variable "AWS_ACCESS_KEY" {}
variable "AWS_SECRET_KEY" {}
variable "vm_key" {}
variable "pkey" {}

provider "aws" {
  access_key = "${var.AWS_ACCESS_KEY}"
  secret_key = "${var.AWS_SECRET_KEY}"
  region     = "eu-central-1"
}

resource "aws_key_pair" "asagan-key" {
  key_name = "${vm_key}"
  public_key = "${pkey}""
}

resource "aws_instance" "test" {
  ami           = "ami-0e258161"
  instance_type = "t2.micro"
  key_name = "${aws_key_pair.asagan-key.key_name}"
  tags {
      Name = "puppet-master"
  }
}
