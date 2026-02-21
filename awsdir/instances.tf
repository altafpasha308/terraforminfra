data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical's AWS Account ID

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "web_server" {
  count         = 2
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro" # Free tier eligible

  # Cycle through your 2 public subnets
  subnet_id = count.index == 0 ? aws_subnet.public_1.id : aws_subnet.public_2.id

  # Attach the securi:ty group and key pair we created earlier
  vpc_security_group_ids = [aws_security_group.web_access.id]
  key_name               = aws_key_pair.deployer.key_name

  # Enable a public IP so you can actually SSH in
  associate_public_ip_address = true

  tags = {
    Name = "ubuntu-web-server-${count.index + 1}"
  }
}
