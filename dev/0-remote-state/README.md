# Remote State Module - Development Environment

This module creates the necessary infrastructure to store Terraform remote state securely with locking.

## Created Resources

- **S3 Bucket** for state storage with unique name
- **DynamoDB Table** for state locking
- **Bucket Versioning** enabled
- **Encryption** AES256 on bucket
- **Public Access Block** for security
- **Random Suffix** to ensure unique bucket name

## Configuration

### S3 Bucket
- **Name**: `{project_name}-terraform-state-{random_suffix}`
- **Random Suffix**: 8 alphanumeric characters (lowercase)
- **Versioning**: Enabled
- **Encryption**: AES256
- **Public Access**: Blocked

### DynamoDB Table
- **Name**: `{project_name}-terraform-locks`
- **Billing Mode**: Pay per request
- **Hash Key**: LockID

## Usage

**IMPORTANT**: This module must be executed FIRST, before all others.

```bash
cd dev/0-remote-state
terraform init
terraform plan -var-file=../terraform.auto.tfvars
terraform apply -var-file=../terraform.auto.tfvars
```

## Outputs

- `s3_bucket_id` - S3 bucket ID (with random suffix)
- `dynamodb_table_name` - DynamoDB table name
- `backend_config` - Structured backend configuration
- `backend_hcl_content` - Ready content for backend.hcl file

## Backend Configuration

After executing this module, copy the `backend_hcl_content` output to the `../backend.hcl` file:

```bash
# After terraform apply, execute:
terraform output -raw backend_hcl_content > ../backend.hcl
```

Or manually copy the content displayed in the output.

## Next Steps

1. Execute this module first
2. Copy the `backend_hcl_content` output to `../backend.hcl`
3. Execute other modules using `terraform init -backend-config=../backend.hcl`