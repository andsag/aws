variable "AWS_ACCESS_KEY" {}
variable "AWS_SECRET_KEY" {}
variable "kname" {}
variable "pkey" {}

provider "aws" {
  access_key = "${var.AWS_ACCESS_KEY}"
  secret_key = "${var.AWS_SECRET_KEY}"
  region     = "eu-central-1"
}

resource "aws_key_pair" "deployer" {
  key_name   = "${var.kname}"
  public_key = "${var.pkey}"
}

resource "aws_instance" "example" {
  ami           = "ami-0e258161"
  instance_type = "t2.micro"
  key_name = "${aws_key_pair.deployer.key_name}"
  tags {
      Name = "puppet-master"
  }
}
