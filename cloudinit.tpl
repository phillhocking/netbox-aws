#cloud-config
runcmd:
  - apt-get update
  - sleep 30
  - apt-get install -y  awscli
