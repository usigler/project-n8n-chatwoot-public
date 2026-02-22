# ECS Configuration
# Note: VPC, subnets, ALB, RDS, Redis, and EFS resources are discovered via tags
# Note: Database password is stored in AWS Secrets Manager (created by RDS module)

# Domain Configuration
n8n_domain      = "n8n-dev.example.com"
chatwoot_domain = "chatwoot-dev.example.com"

# Port Configuration
n8n_port      = 5678
chatwoot_port = 3000

# Docker Images
n8n_image      = "n8nio/n8n:2.3.4"

# Resource Allocation
n8n_cpu      = 512
n8n_memory   = 1024
chatwoot_cpu = 512
chatwoot_memory = 1024

# Service Configuration
n8n_desired_count      = 1
chatwoot_desired_count = 1

# Logging
log_retention_days = 1
