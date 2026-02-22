# EFS Module - Development Environment

This module creates EFS shared storage for data persistence of N8N and Chatwoot applications.

## Created Resources

- **EFS File System** with encryption
- **Mount Targets** in multiple AZs
- **Access Points** separate for N8N and Chatwoot
- **Security Group** for access control
- **Lifecycle Policy** for cost optimization

## Configuration

### File System
- **Performance Mode**: General Purpose
- **Throughput Mode**: Bursting
- **Encryption**: Enabled in transit and at rest
- **Lifecycle**: Transition to IA after 30 days
- **Multi-AZ**: Always enabled (EFS default)

### Access Points
- **N8N**: `/n8n` - UID/GID 1000
- **Chatwoot**: `/chatwoot` - UID/GID 1000

## Dependencies

This module depends on the **1-vpc** module and automatically looks up:
- VPC ID via `Project` tag
- Private application subnets via tags

## Usage

```bash
cd dev/4-efs
terraform init -backend-config=../backend.hcl
terraform plan -var-file=../terraform.auto.tfvars
terraform apply -var-file=../terraform.auto.tfvars
```

## Main Variables

| Variable | Value | Description |
|----------|-------|-----------|
| performance_mode | generalPurpose | Performance mode |
| throughput_mode | bursting | Throughput mode |
| transition_to_ia | AFTER_30_DAYS | Transition to IA |

## Outputs

- `file_system_id` - EFS ID
- `n8n_access_point_id` - N8N access point
- `chatwoot_access_point_id` - Chatwoot access point

## High Availability (Multi-AZ)

EFS is **always Multi-AZ by design**. There is no Single-AZ option.

**Features**:
- ✅ Automatic high availability
- ✅ Data replicated across all AZs
- ✅ Mount targets in multiple AZs (2 in this project)
- ✅ Simultaneous access from any AZ
- ✅ Automatic failover without intervention
- ✅ No additional cost for replication

**Note**: Unlike RDS and Redis, EFS does not require additional configuration for Multi-AZ - it is the default and only behavior.