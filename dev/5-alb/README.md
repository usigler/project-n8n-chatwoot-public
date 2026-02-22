# ALB Module - Development Environment

This module creates a shared Application Load Balancer for N8N and Chatwoot applications.

## Created Resources

- **Application Load Balancer** public
- **Target Groups** separate for N8N and Chatwoot
- **Listeners** HTTP (redirect) and HTTPS
- **Listener Rules** for domain-based routing
- **Security Group** for access control

## Configuration

### Load Balancer
- **Type**: Application Load Balancer
- **Scheme**: Internet-facing
- **Subnets**: Public in multiple AZs

### Routing

**Production Mode (HTTPS with SSL)**:
- **N8N**: `n8n-dev.example.com` → Port 5678
- **Chatwoot**: `chatwoot-dev.example.com` → Port 3000
- **HTTP**: Automatic redirection to HTTPS

**Development Mode (HTTP without SSL)**:
- **N8N**: `http://<alb-dns>/n8n` → Port 5678
- **Chatwoot**: `http://<alb-dns>/` or `http://<alb-dns>/chatwoot` → Port 3000
- **Routing**: By path (no domain needed)

### Health Checks
- **N8N**: `/healthz`
- **Chatwoot**: `/health`

## Dependencies

This module depends on the **1-vpc** module and automatically looks up:
- VPC ID via `Project` tag
- Public subnets via tags

## Usage

```bash
cd dev/5-alb
terraform init -backend-config=../backend.hcl
terraform plan -var-file=../terraform.auto.tfvars
terraform apply -var-file=../terraform.auto.tfvars
```

## Main Variables

| Variable | Value | Description |
|----------|-------|-----------|
| n8n_domain | n8n-dev.example.com | N8N domain (used with SSL) |
| chatwoot_domain | chatwoot-dev.example.com | Chatwoot domain (used with SSL) |
| ssl_certificate_arn | null | SSL certificate ARN |
| enable_http_listener | true | Enable HTTP routing by path |

## Operation Modes

### Development (HTTP without SSL)

Current configuration for testing:
```hcl
enable_http_listener = true
ssl_certificate_arn  = null
```

**Access**:
- N8N: `http://<alb-dns>/n8n`
- Chatwoot: `http://<alb-dns>/`

**Advantages**:
- ✅ No domain needed
- ✅ No certificate cost
- ✅ Works immediately
- ⚠️ Development only

### Production (HTTPS with SSL)

Configuration for production:
```hcl
enable_http_listener = false
ssl_certificate_arn  = "arn:aws:acm:..."
```

**Access**:
- N8N: `https://n8n.yourdomain.com`
- Chatwoot: `https://chatwoot.yourdomain.com`

**Requirements**:
1. Register domain in Route 53
2. Create SSL certificate in ACM
3. Configure DNS records

## Outputs

- `alb_dns_name` - ALB DNS name
- `n8n_target_group_arn` - N8N target group
- `chatwoot_target_group_arn` - Chatwoot target group