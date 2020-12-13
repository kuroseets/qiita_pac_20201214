resource "aws_instance" "web_servers" {
  count         = length(var.availability_zones)
  ami           = "ami-0053d11f74e9e7f52"
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.private_subnet[count.index].id
  tags = {
    Name = format("%s-%s-web-server-%s", var.application_name, var.environment, var.availability_zones[count.index])
  }
}
