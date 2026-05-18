output "connection_id" {
  description = "VPC peering connection ID"
  value       = aws_vpc_peering_connection.this.id
}

output "connection_status" {
  description = "VPC peering connection status"
  value       = aws_vpc_peering_connection.this.accept_status
}

output "requester_route_ids" {
  description = "Requester-side peering route IDs"
  value       = [for route in aws_route.requester_to_accepter : route.id]
}

output "accepter_route_ids" {
  description = "Accepter-side peering route IDs"
  value       = [for route in aws_route.accepter_to_requester : route.id]
}
