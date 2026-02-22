# VPC Module

This module creates a complete VPC infrastructure on AWS with the following features:

## Created Resources

- **VPC** with DNS enabled
- **2 Availability Zones**
- **2 Public Subnets** (1 per AZ)
- **4 Private Subnets** (2 per AZ - application and database)
- **1 Regional NAT Gateway**
- **Internet Gateway**
- **Route Tables** (public and private)
- **Network ACLs** (public and private)

## Network Architecture

```
VPC (10.0.0.0/16)
├── AZ-1
│   ├── Public Subnet (10.0.0.0/24)
│   ├── Private App Subnet (10.0.10.0/24)
│   └── Private DB Subnet (10.0.20.0/24)
└── AZ-2
    ├── Public Subnet (10.0.30.0/24)
    ├── Private App Subnet (10.0.40.0/24)
    └── Private DB Subnet (10.0.50.0/24)
```

## Usage

```bash
cd dev/1-vpc
terraform init -backend-config=../backend.hcl
terraform plan -var-file=../terraform.auto.tfvars
terraform apply -var-file=../terraform.auto.tfvars
```

## Configuration Example

```hcl
module "vpc" {
  source = "./modules/vpc"

  name_prefix = "my-project"
  vpc_cidr    = "10.0.0.0/16"
  
  public_subnet_cidrs     = ["10.0.0.0/24", "10.0.30.0/24"]
  private_app_subnet_cidrs = ["10.0.10.0/24", "10.0.40.0/24"]
  private_db_subnet_cidrs  = ["10.0.20.0/24", "10.0.50.0/24"]
  
  tags = {
    Environment = "dev"
    Project     = "my-project"
  }
}
```

## Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| name_prefix | Prefix for resource names | string | - | yes |
| vpc_cidr | VPC CIDR block | string | 10.0.0.0/16 | no |
| public_subnet_cidrs | Public subnet CIDRs | list(string) | ["10.0.0.0/24", "10.0.1.0/24"] | no |
| private_app_subnet_cidrs | Private application subnet CIDRs | list(string) | ["10.0.10.0/24", "10.0.11.0/24"] | no |
| private_db_subnet_cidrs | Private database subnet CIDRs | list(string) | ["10.0.20.0/24", "10.0.21.0/24"] | no |
| tags | Resource tags | map(string) | {} | no |

## Outputs

| Name | Description |
|------|-------------|
| vpc_id | VPC ID |
| public_subnet_ids | Public subnet IDs |
| private_app_subnet_ids | Private application subnet IDs |
| private_db_subnet_ids | Private database subnet IDs |
| nat_gateway_id | NAT Gateway ID |
