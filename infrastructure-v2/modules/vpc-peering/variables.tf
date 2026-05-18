variable "name" {
  description = "Friendly name for the peering connection"
  type        = string
}

variable "requester_vpc_id" {
  description = "Requester VPC ID"
  type        = string
}

variable "requester_vpc_cidr" {
  description = "Requester VPC CIDR"
  type        = string
}

variable "requester_route_table_ids" {
  description = "Route tables in the requester VPC that need routes to the accepter VPC"
  type        = list(string)
}

variable "accepter_vpc_id" {
  description = "Accepter VPC ID"
  type        = string
}

variable "accepter_vpc_cidr" {
  description = "Accepter VPC CIDR"
  type        = string
}

variable "accepter_route_table_ids" {
  description = "Route tables in the accepter VPC that need routes to the requester VPC"
  type        = list(string)
}

variable "auto_accept" {
  description = "Automatically accept the peering request when both VPCs are in the same account/region"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Common tags applied to peering resources"
  type        = map(string)
  default     = {}
}
