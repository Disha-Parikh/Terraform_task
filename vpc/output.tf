output "az" {
  value = aws_subnet.private_subnet.*.availability_zone
}

output "subnet_id" {
  value = aws_subnet.private_subnet.*.id
}

output "sg" {
  value = aws_security_group.allow-http-tcp.id
}
output "subnet_id_public" {
  value = aws_subnet.public_subnet.id
}
output "eip" {
  value = aws_eip.eip.public_ip
}