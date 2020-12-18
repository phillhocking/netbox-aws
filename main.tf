
provider "aws" {
  region     = var.aws_region
  access_key = var.access_key
  secret_key = var.secret_key
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "netbox" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name      = var.key_name
  vpc_security_group_ids = [aws_security_group.netbox-prod.id]
  tags = {
    Name = "netbox-dev"
  }
}

resource "null_resource" "saltmaster_config" {
 depends_on = [aws_instance.netbox]
 connection {
    type		= "ssh"
    private_key         = var.terraform_ssh_key
    host                = aws_instance.netbox.public_ip
    user              	= "ubuntu"
    timeout             = "4m"
  }

  triggers = {
    always_run = "${timestamp()}"
  }
 provisioner "remote-exec" {
   inline = [ "sudo apt update",
              "sudo apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common -y",
              "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -",
              "sudo add-apt-repository \"deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable\" ",
              "sudo apt update && sudo apt install docker-ce docker-ce-cli containerd.io -y",
              "git clone -b release https://github.com/netbox-community/netbox-docker.git",
              "cd netbox-docker",
              "tee docker-compose.override.yml <<EOF",
              "version: '3.4'",
              "services:",
              "  nginx:",
              "    ports:",
              "      - 80:8080",
              "EOF",
              "sudo docker-compose pull",
              "sudo docker-compose up",              
     ]
   connection {
      type                = "ssh"
      private_key         = var.terraform_ssh_key
      host                = aws_instance.netbox.public_ip
      user                = "ubuntu"
      timeout             = "4m"
   }
 }
}