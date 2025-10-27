resource "aws_instance" "server1" {
    ami = "ami-0360c520857e3138f"
    instance_type = "t2.micro"
    key_name = aws_key_pair.test-key.id
    vpc_security_group_ids = [aws_security_group.test-sg.id]
    tags = {
      Name = "test-server"
    }
}

resource "aws_key_pair" "test-key" {
  key_name   = "test-key"
  public_key = file("mykey.pub")
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

output "test_server_ip" {
  value = aws_instance.server1.public_ip
}