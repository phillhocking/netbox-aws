
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

resource "aws_instance" "netbox_dev" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.netbox_dev.id]
  tags = {
    Name = "netbox-dev"
  }
  connection {
    type        = "ssh"
    private_key = var.terraform_ssh_key
    host        = aws_instance.netbox_dev.public_ip
    user        = "ubuntu"
    timeout     = "5m"
  }
  provisioner "file" {
    source      = "netbox.sh"
    destination = "/tmp/netbox.sh"

  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/netbox.sh",
      "/tmp/netbox.sh",
    ]

  }
}

resource "null_resource" "netbox_config" {
  depends_on = [aws_instance.netbox_dev]
  connection {
    type        = "ssh"
    private_key = var.terraform_ssh_key
    host        = aws_instance.netbox.public_ip
    user        = "ubuntu"
    timeout     = "4m"
  }

  triggers = {
    always_run = timestamp()
  }
}