# Random password for RDS
resource "random_password" "db_password" {
  length           = 32
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

# Random suffix for secret names
resource "random_id" "secret_suffix" {
  byte_length = 4
}

# Store password in Secrets Manager
resource "aws_secretsmanager_secret" "db_password" {
  name        = "${var.name_prefix}-rds-password-${random_id.secret_suffix.hex}"
  description = "RDS PostgreSQL master password for ${var.name_prefix}"

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-rds-password"
  })
}

resource "aws_secretsmanager_secret_version" "db_password" {
  secret_id     = aws_secretsmanager_secret.db_password.id
  secret_string = random_password.db_password.result
}
