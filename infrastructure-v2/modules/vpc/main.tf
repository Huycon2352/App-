# ============================================================
# VPC Module: Tạo VPC + 1 Private Subnet
# ============================================================

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "${var.environment}-vpc"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# ============================================================
# Internet Gateway
# ============================================================
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.environment}-igw"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# ============================================================
# Public Subnet (cho NAT Gateway + ALB)
# ============================================================
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.environment}-public-subnet"
    Environment = var.environment
    Type        = "Public"
    ManagedBy   = "Terraform"
  }
}

# ============================================================
# Private Subnet (cho EKS Nodes)
# ============================================================
resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = var.availability_zone

  tags = {
    Name                            = "${var.environment}-private-subnet"
    Environment                     = var.environment
    Type                            = "Private"
    "kubernetes.io/cluster/${var.environment}-cluster" = "shared"
    ManagedBy                       = "Terraform"
  }
}

# ============================================================
# Elastic IP cho NAT Gateway
# ============================================================
resource "aws_eip" "nat" {
  domain = "vpc"

  depends_on = [aws_internet_gateway.main]

  tags = {
    Name        = "${var.environment}-nat-eip"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# ============================================================
# NAT Gateway (cho EKS nodes pull images từ Docker Hub)
# ============================================================
resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public.id

  depends_on = [aws_internet_gateway.main]

  tags = {
    Name        = "${var.environment}-nat"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# ============================================================
# Public Route Table (IGW routing)
# ============================================================
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block      = "0.0.0.0/0"
    gateway_id      = aws_internet_gateway.main.id
  }

  tags = {
    Name        = "${var.environment}-public-rt"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# ============================================================
# Private Route Table (NAT Gateway routing)
# ============================================================
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }

  tags = {
    Name        = "${var.environment}-private-rt"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}

# ============================================================
# VPC Endpoints cho ECR (optional nhưng khuyến nghị)
# ============================================================
resource "aws_security_group" "vpc_endpoints" {
  name_prefix = "${var.environment}-vpce-"
  description = "Security group for VPC Endpoints"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
    description = "HTTPS from VPC"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound"
  }

  tags = {
    Name        = "${var.environment}-vpce-sg"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

resource "aws_vpc_endpoint" "ecr_api" {
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.${var.aws_region}.ecr.api"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = [aws_subnet.private.id]
  security_group_ids  = [aws_security_group.vpc_endpoints.id]
  private_dns_enabled = true

  tags = {
    Name        = "${var.environment}-ecr-api-endpoint"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

resource "aws_vpc_endpoint" "ecr_dkr" {
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.${var.aws_region}.ecr.dkr"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = [aws_subnet.private.id]
  security_group_ids  = [aws_security_group.vpc_endpoints.id]
  private_dns_enabled = true

  tags = {
    Name        = "${var.environment}-ecr-dkr-endpoint"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${var.aws_region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [
    aws_route_table.public.id,
    aws_route_table.private.id
  ]

  tags = {
    Name        = "${var.environment}-s3-endpoint"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}
