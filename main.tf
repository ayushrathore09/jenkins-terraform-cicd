resource "aws_instance" "server1" {
    ami = "ami-0360c520857e3138f"
    instance_type = "t2.micro"
    key_name = aws_key_pair.test-key.id
    vpc_security_group_ids = [aws_security_group.test-sg.id]
    tags = {
      Name = "test-server"
    }
    user_data = <<-EOF
                #!/bin/bash
                sudo apt update -y
                sudo apt install -y nginx
                EOF


    # provisioner "remote-exec" {
    #   on_failure = continue
    #   inline = [
    #     "sudo apt update -y",
    #     "sudo apt install -y nginx",
    #     "sudo systemctl start nginx",
    #     "sudo systemctl enable nginx"
    #   ]
    #   // remote_exec requires authentication mechanism:
    #   connection {
    #     type        = "ssh"
    #     host       = self.public_ip
    #     user       = "ubuntu"
    #     private_key = file("c:\\Users\\user\\.ssh\\id_ed25519")
    #   }

    # }
    # provisioner "local-exec" {
    #   command = "echo 'Provisioning complete!'"
    # }
}

resource "aws_key_pair" "test-key" {
  key_name   = "test-key"
  public_key = file("/home/ubuntu/.ssh/id_ed25519.pub")
}

resource "aws_security_group" "test-sg" {
  name        = "test-sg"
  ingress {
    from_port   = 22
    to_port     = 22
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
