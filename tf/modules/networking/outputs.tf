
output "ecomm_vpc_id" {
    value = aws_vpc.ecomm_vpc.id
}

output "ecomm_public_subnet_1_id" {
    value = aws_subnet.ecomm_public_subnet_1.id
}

output "ecomm_public_subnet_2_id" {
    value = aws_subnet.ecomm_public_subnet_2.id
}

output "ecomm_private_subnet_1_id" {
    value = aws_subnet.ecomm_private_subnet_1.id
}

output "ecomm_private_subnet_2_id" {
    value = aws_subnet.ecomm_private_subnet_2.id
}
