# ============================================================
# EKS Node Group Module
# ============================================================

resource "aws_eks_node_group" "main" {
  cluster_name    = var.cluster_name
  node_group_name = "${var.environment}-node-group"
  node_role_arn   = var.node_role_arn
  subnet_ids      = var.subnet_ids
  version         = var.kubernetes_version

  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }

  instance_types = var.instance_types

  # Use On-Demand (default)
  capacity_type = var.capacity_type

  disk_size = var.disk_size
/*
  # Enable SSM Session Manager
  remote_access {
    ec2_ssh_key = var.ec2_ssh_key
  }
*/
dynamic "remote_access" {
  for_each = var.ec2_ssh_key != null ? [1] : []

  content {
    ec2_ssh_key = var.ec2_ssh_key
  }
}
  tags = {
    Name        = "${var.environment}-node-group"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }

/*
  depends_on = {
    var.node_role_arn
  }
*/

  lifecycle {
    create_before_destroy = true
  }
}