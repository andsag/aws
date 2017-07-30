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

resource "aws_instance" "puppet_vm" {
  ami           = "ami-0e258161"
  instance_type = "t2.micro"
  key_name = "${aws_key_pair.deployer.key_name}"
  tags {
      Name = "puppet-master"
  }


provisioner "remote-exec" {
    inline = [
      # install software
      "sudo rpm -ivh https://yum.puppetlabs.com/puppetlabs-release-el-7.noarch.rpm",
      "sudo yum -y install puppetserver",
      "sudo /bin/sed -i 's/2g/512m/g' /etc/sysconfig/puppetserver",
      "sudo systemctl start puppetserver",
      "sudo systemctl enable puppetserver",
      "sudo yum -y install epel-release",
      "sudo yum -y install vim ",
      "sudo yum -y install git",	
      "/bin/git clone https://github.com/andsag/puppet.git",
      "sudo /bin/rsync -avz /home/ec2-user/puppet/ /etc/puppet/",
      "sudo systemctl restart puppetserver",
      "sudo yum -y install mc"
    ]

      connection {
   	type     = "ssh"
    	user     = "ec2-user"
 	private_key = "${file("/Users/asagan/aws/amazon/redhat/aws_key")}"
	}

}


}

resource "aws_ebs_volume" "puppet_disk" {
  availability_zone = "eu-central-1b"
  size              = 1
}

resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdh"
  volume_id   = "${aws_ebs_volume.puppet_disk.id}"
  instance_id = "${aws_instance.puppet_vm.id}"
}

