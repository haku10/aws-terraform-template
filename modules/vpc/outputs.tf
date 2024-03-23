output "vpc_id" {
  description = "The ID of the vpc"
  value       = aws_vpc.vpc.id
}

output "public_subnet_ids" {
  description = "The IDs of the public subnets"
  value       = aws_subnet.public.*.id
}

output "private_subnet_ids" {
  description = "The IDs of the private subnets"
  value       = aws_subnet.private.*.id
}
