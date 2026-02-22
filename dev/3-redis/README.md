# Redis Module - Development Environment

This module creates an ElastiCache Redis cluster for cache and sessions of N8N and Chatwoot applications.

## Created Resources

- **ElastiCache Redis Cluster** with encryption
- **Security Group** for access control
- **Subnet Group** in private application subnets
- **Parameter Group** optimized for Redis
- **Automatic snapshots** configured

## Configuration

### Redis Cluster
- **Engine**: Redis 7.0
- **Node Type**: cache.t3.micro (development)
- **Nodes**: 1 (single node for dev)
- **Multi-AZ**: Disabled (development) - Enable in production
- **Encryption**: Enabled in transit and at rest

### Security
- Access only via specific security groups
- Isolated private subnets
- Optional auth token

## Dependencies

This module depends on the **1-vpc** module and automatically looks up:
- VPC ID via `Project` tag
- Private application subnets via tags

## Usage

```bash
cd dev/3-redis
terraform init -backend-config=../backend.hcl
terraform plan -var-file=../terraform.auto.tfvars
terraform apply -var-file=../terraform.auto.tfvars
```

## Main Variables

| Variable | Value | Description |
|----------|-------|-----------|
| node_type | cache.t3.micro | Redis node type |
| num_cache_nodes | 1 | Number of nodes (2+ for Multi-AZ) |
| redis_version | 7.0 | Redis version |
| auth_token | null | Authentication token |
| multi_az | false | Multi-AZ (false=dev, true=prod) |

## High Availability (Multi-AZ)

**Development**: `multi_az = false` (Single-AZ)
- Lower cost
- Single node
- Suitable for testing and development
- Downtime during maintenance

**Production**: `multi_az = true` (Multi-AZ)
- Automatic high availability
- Automatic failover in case of failure
- No downtime during maintenance
- Requires `num_cache_nodes >= 2`
- Cost proportional to number of nodes

**Note**: To enable Multi-AZ, configure:
```hcl
num_cache_nodes = 2  # Minimum for Multi-AZ
multi_az        = true
```

## Outputs

- `redis_endpoint` - Redis primary endpoint
- `redis_port` - Redis port (6379)
- `security_group_id` - Security group ID