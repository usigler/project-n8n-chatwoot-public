# ACM Module with Let's Encrypt

This module creates SSL/TLS certificates using Let's Encrypt and imports them into AWS Certificate Manager (ACM).

## Prerequisites

1. **Domain configured in Route53**: The domain must be hosted in Route53 for automatic DNS validation
2. **IAM Permissions**: The user/role must have permissions to:
   - Manage DNS records in Route53
   - Import certificates into ACM

## Configuration

### 1. Configure email in terraform.tfvars

```hcl
email_address = "your-email@example.com"
```

### 2. Run Terraform

```bash
cd dev/0-acm
terraform init -backend-config=../backend.hcl
terraform plan -var-file=../terraform.auto.tfvars
terraform apply -var-file=../terraform.auto.tfvars
```

## How it works

1. **ACME Registration**: Creates an account on Let's Encrypt using the provided email
2. **DNS Validation**: Uses Route53 for automatic domain validation
3. **Certificate Generation**: Let's Encrypt generates the certificate after validation
4. **Import to ACM**: The certificate is imported into AWS Certificate Manager

## Let's Encrypt Advantages

- **Free**: SSL/TLS certificates at no cost
- **Automatic**: Automatic renewal (valid for 90 days)
- **Trusted**: Recognized by all browsers
- **Fast**: Issued in minutes vs hours/days with ACM

## Supported domains

- Primary domain: `*.example.com` (wildcard)
- Alternative domain: `example.com` (apex)

## Outputs

- `certificate_arn`: Certificate ARN in ACM
- `certificate_domain_name`: Certificate domain name
- `certificate_status`: Certificate status

## Troubleshooting

### DNS validation error
- Verify the domain is in Route53
- Confirm IAM permissions for Route53

### Rate limit error
- Let's Encrypt has rate limits
- Wait before trying again

### Certificate not renewing
- Verify the domain is still in Route53
- Confirm AWS credentials are still valid