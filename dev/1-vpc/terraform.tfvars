# Network Configuration
vpc_cidr = "10.0.0.0/16"

# Subnet CIDRs
public_subnet_cidrs     = ["10.0.0.0/24", "10.0.30.0/24"]
private_app_subnet_cidrs = ["10.0.10.0/24", "10.0.40.0/24"]
private_db_subnet_cidrs  = ["10.0.20.0/24", "10.0.50.0/24"]