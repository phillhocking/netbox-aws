resource "aws_security_group" "netbox-dev" {
  name        = "netbox-dev"
  description = "Allow SSH inbound , all HTTP inbound, and all outbound traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.management_cidr_block, "75.2.98.97/32", "99.83.150.238/32"]
  }

  # These hardcoded values come from the Terraform Cloud API described at https://www.terraform.io/docs/cloud/api/ip-ranges.html so the provisioner blocks can run
  # These may be subject to change

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}