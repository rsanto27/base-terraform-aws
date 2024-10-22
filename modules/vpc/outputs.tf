output "vpc_id" {
  value = aws_vpc.base-vpc.id
}

output "subnet_ids" {
  value = aws_subnet.base-subnets.*.id
}