source "amazon-ebs" "abc-image"{
  ami_name      = "vault-in-ubuntu-{{timestamp}}"
  region        = "ap-southeast-1"
  profile       = "admin-account"
  instance_type = "t2.micro"
  tags          = {
    Name = "my-vault"
  }
  source_ami_filter {
    filters = {
       virtualization-type = "hvm"
       name = "ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"
       root-device-type = "ebs"
    }
    owners = ["099720109477"]
    most_recent = true
  }
  ssh_username  =  "ubuntu"
}

build {
  sources = [
    "source.amazon-ebs.abc-image"
  ]    
  provisioner "shell" {
    inline = [
      "sudo apt update",
      "curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -",
      "sudo apt-add-repository \"deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main\"", 
      "sudo apt install unzip -y",
      "sudo apt install wget -y",
      "sudo apt install net-tools -y",
      "sudo apt install jq -y",
      "sudo apt list -a vault",
      "sudo apt show vault",
      "sudo apt install -y vault"
    ]
  }
  
}

