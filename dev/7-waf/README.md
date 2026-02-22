# WAF Module - Development Environment

This module implements Web Application Firewall for protection of N8N and Chatwoot applications.

## Created Resources

- **WAF Web ACL** with security rules
- **Managed Rule Groups** from AWS
- **Rate Limiting** for DDoS prevention
- **Geo Blocking** (optional)
- **CloudWatch Logs** for monitoring
- **Association with ALB**

## Protection Rules

### AWS Managed Rules
- **Common Rule Set**: Basic protections
- **Known Bad Inputs**: Known malicious inputs
- **SQL Injection**: SQLi protection

### Custom Rules
- **Rate Limiting**: 2000 requests per 5 minutes per IP
- **Geo Blocking**: Country blocking (optional)

## Configuration

### Rate Limiting
- **Limit**: 2000 requests/5min per IP
- **Action**: Block when exceeded

### Logging
- **Destination**: CloudWatch Logs
- **Retention**: 7 days
- **Redacted Fields**: Authorization, Cookie

## Dependencies

This module depends on the **4-alb** module and automatically looks up:
- ALB ARN via `Project` tag

## Usage

```bash
cd dev/7-waf
terraform init -backend-config=../backend.hcl
terraform plan -var-file=../terraform.auto.tfvars
terraform apply -var-file=../terraform.auto.tfvars
```

## Main Variables

| Variable | Value | Description |
|----------|-------|-----------|
| rate_limit | 2000 | Requests per 5 minutes |
| blocked_countries | null | Blocked countries |
| log_retention_days | 7 | Log retention |

## Outputs

- `web_acl_arn` - Web ACL ARN
- `web_acl_capacity` - WAF capacity used