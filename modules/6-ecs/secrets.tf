# Generate SECRET_KEY_BASE for Chatwoot
resource "random_password" "chatwoot_secret_key_base" {
  length  = 64
  special = false
}

# Random suffix for secret names
resource "random_id" "secret_suffix" {
  byte_length = 4
}

# Store SECRET_KEY_BASE in Secrets Manager
resource "aws_secretsmanager_secret" "chatwoot_secret_key_base" {
  name                    = "${var.name_prefix}-chatwoot-secret-key-base-${random_id.secret_suffix.hex}"
  description             = "Chatwoot SECRET_KEY_BASE"
  recovery_window_in_days = 0

  tags = merge(var.tags, {
    Name        = "${var.name_prefix}-chatwoot-secret-key-base"
    Application = "chatwoot"
  })
}

resource "aws_secretsmanager_secret_version" "chatwoot_secret_key_base" {
  secret_id     = aws_secretsmanager_secret.chatwoot_secret_key_base.id
  secret_string = random_password.chatwoot_secret_key_base.result
}
