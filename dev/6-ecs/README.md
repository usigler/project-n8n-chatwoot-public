# ECS Module - Development Environment

This module deploys N8N and Chatwoot applications in ECS Fargate containers.

## Created Resources

- **ECS Cluster** with Container Insights
- **Task Definitions** for N8N and Chatwoot
- **ECS Services** with ALB integration
- **IAM Roles** for execution and tasks
- **CloudWatch Log Groups** for logs
- **Security Group** for containers

## Configuration

### N8N Container
- **Image**: n8nio/n8n:latest
- **CPU**: 512 units
- **Memory**: 1024 MB
- **Port**: 5678
- **Volume**: EFS mount at `/home/node/.n8n`

### Chatwoot Container
- **Image**: chatwoot/chatwoot:latest
- **CPU**: 512 units
- **Memory**: 1024 MB
- **Port**: 3000
- **Volume**: EFS mount at `/app/storage`

### Integration
- **Database**: PostgreSQL via RDS
- **Storage**: EFS for persistence
- **Load Balancer**: ALB for traffic distribution

## Dependencies

This module depends on all previous modules and automatically looks up:
- VPC and private subnets
- RDS endpoint and configurations
- EFS file system and access points
- ALB target groups and security group

## Usage

```bash
cd dev/6-ecs
terraform init -backend-config=../backend.hcl
terraform plan -var-file=../terraform.auto.tfvars
terraform apply -var-file=../terraform.auto.tfvars
```

## Main Variables

| Variable | Value | Description |
|----------|-------|-----------|
| n8n_image | n8nio/n8n:latest | N8N Docker image |
| chatwoot_image | chatwoot/chatwoot:latest | Chatwoot Docker image |
| log_retention_days | 7 | Log retention |

## Outputs

- `cluster_arn` - ECS cluster ARN
- `n8n_service_id` - N8N service ID
- `chatwoot_service_id` - Chatwoot service ID