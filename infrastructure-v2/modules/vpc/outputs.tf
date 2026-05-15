/*
output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "vpc_cidr" {
  description = "VPC CIDR block"
  value       = aws_vpc.main.cidr_block
}

output "private_subnet_id" {
  description = "Private subnet ID"
  value       = aws_subnet.private.id
}

output "private_subnet_cidr" {
  description = "Private subnet CIDR"
  value       = aws_subnet.private.cidr_block
}

output "public_subnet_id" {
  description = "Public subnet ID"
  value       = aws_subnet.public.id
}

output "public_subnet_cidr" {
  description = "Public subnet CIDR"
  value       = aws_subnet.public.cidr_block
}
*/
output "vpc_id" {
  value       = aws_vpc.main.id
  description = "VPC ID"
}

output "vpc_cidr" {
  value       = aws_vpc.main.cidr_block
  description = "VPC CIDR block"
}

output "private_subnet_ids" {
  value       = aws_subnet.private[*].id
  description = "List of private subnet IDs (multi-AZ)"
}

output "public_subnet_ids" {
  value       = aws_subnet.public[*].id
  description = "List of public subnet IDs (multi-AZ)"
}

output "private_subnet_id" {
  value       = aws_subnet.private[0].id
  description = "First private subnet ID (backward compatibility)"
}

output "nat_gateway_id" {
  value       = aws_nat_gateway.main.id
  description = "NAT Gateway ID"
}
