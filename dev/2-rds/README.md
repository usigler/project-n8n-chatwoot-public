# RDS Module - Development Environment

This module deploys PostgreSQL for N8N and Chatwoot applications in the development environment.

## Created Resources

- **PostgreSQL RDS** with encryption enabled
- **Security Group** restrictive for database access
- **DB Subnet Group** in private database subnets
- **Parameter Group** optimized for PostgreSQL
- **Automatic backup** configured

## Configuration

### Database
- **Engine**: PostgreSQL 17.7
- **Instance Class**: db.t3.micro (development)
- **Storage**: 20GB initial, up to 100GB (auto-scaling)
- **Backup**: 7 days retention
- **Multi-AZ**: Disabled (development) - Enable in production

### Security
- Encryption at rest enabled
- Access only via specific security groups
- Isolated private subnets

## Dependencies

This module depends on the **1-vpc** module and automatically looks up:
- VPC ID via `Project` tag
- Private database subnets via tags

## Usage

```bash
cd dev/2-rds
terraform init -backend-config=../backend.hcl
terraform plan -var-file=../terraform.auto.tfvars
terraform apply -var-file=../terraform.auto.tfvars
```

## Main Variables

| Variable | Value | Description |
|----------|-------|-----------|
| postgres_version | 17.7 | PostgreSQL version |
| parameter_group_family | postgres17 | Parameter group family |
| instance_class | db.t3.micro | Instance class |
| database_name | n8n_chatwoot | Database name |
| master_username | postgres | Master username |
| multi_az | false | Multi-AZ (false=dev, true=prod) |
| deletion_protection | false | Deletion protection |

## High Availability (Multi-AZ)

**Development**: `multi_az = false` (Single-AZ)
- Lower cost
- Suitable for testing and development
- Downtime during maintenance

**Production**: `multi_az = true` (Multi-AZ)
- Automatic high availability
- Automatic failover in case of failure
- No downtime during maintenance
- Approximately 2x higher cost

## Outputs

- `db_instance_endpoint` - Database endpoint
- `db_instance_port` - Database port (5432)
- `security_group_id` - Security group ID