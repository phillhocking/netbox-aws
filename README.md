# netbox-aws
## This repository is intended to facilitate installation of the popular NetBox DCIM/IPAM on an AWS EC2 instance using Terraform. 


This repo is pinned to Ubuntu 18.04-amd64-server-20201211.1 and verified to work with Terraform 0.14.6. The [netbox-docker](https://github.com/netbox-community/netbox-docker) image is pinned to [1.0.2](https://github.com/netbox-community/netbox-docker/releases/tag/1.0.2) which was the latest release as of this writing. 

To summarize, this instantiates the Ubuntu EC2 instance, installs all the Docker dependencies (which all are pinned), pulls the [netbox-docker](https://github.com/netbox-community/netbox-docker) release via git, creates a `docker-compose.override.yml` file which exposes the Docker internal port `8080` on the worker container to port `80` to the internet, and then execute `docker-compose` resulting in a functioning NetBox IPAM  after several minutes of fetching the depends and setting up the various images called by `docker-compose`.


Variables to define in your Terraform workspace are: 

```hcl 
variable "access_key" {}
variable "secret_key" {}
variable "management_cidr_block" {}
variable "key_name" {
  default = "terraform"
}

variable "aws_region" {
  default = "us-west-2"
}
```
The `management_cidr_block` is just an IP address range to allow SSH connections from either your premise location, bastion host, VPC subnet, etc. Obviously you would want to be utilizing SSL and have a Security Group and/or NACL and probably have it behind an ALB or CloudFront deployment to provide more limited access, however, that is beyond the scope of this project.

The default login is `admin/admin`, and the default API key is:

`0123456789abcdef0123456789abcdef01234567`

Please, dear God, don't just run this public on the internet without SSL/firewall and change these defaults!

Pull requests are welcome, shoot me a message with any questions, complaints, or thanks! 