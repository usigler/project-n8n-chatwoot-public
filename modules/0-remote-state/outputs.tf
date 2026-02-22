output "s3_bucket_id" {
  description = "S3 bucket ID for Terraform state"
  value       = aws_s3_bucket.terraform_state.id
}

output "s3_bucket_arn" {
  description = "S3 bucket ARN for Terraform state"
  value       = aws_s3_bucket.terraform_state.arn
}

output "dynamodb_table_name" {
  description = "DynamoDB table name for state locking"
  value       = aws_dynamodb_table.terraform_locks.name
}

output "dynamodb_table_arn" {
  description = "DynamoDB table ARN for state locking"
  value       = aws_dynamodb_table.terraform_locks.arn
}

# Outputs for backend.hcl configuration
output "backend_config" {
  description = "Backend configuration for backend.hcl file"
  value = {
    bucket         = aws_s3_bucket.terraform_state.id
    region         = var.aws_region
    dynamodb_table = aws_dynamodb_table.terraform_locks.name
    encrypt        = true
  }
}

output "backend_hcl_content" {
  description = "Content for backend.hcl file"
  value = <<-EOT
bucket         = "${aws_s3_bucket.terraform_state.id}"
region         = "${var.aws_region}"
dynamodb_table = "${aws_dynamodb_table.terraform_locks.name}"
encrypt        = true
EOT
}