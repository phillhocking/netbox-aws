# Get local machine's IP
data "http" "my-ip" {
  url = "http://icanhazip.com"
}

resource "aws_security_group" "netbox-prod" {
  name        = "netbox-prod"
  description = "Allow SSH inbound , all HTTP inbound, and all outbound traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${chomp(data.http.my-ip.body)}/32"]
  }

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