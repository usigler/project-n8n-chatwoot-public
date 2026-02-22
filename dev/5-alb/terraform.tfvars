# ALB Configuration
enable_deletion_protection = false  # Set to true in production
ssl_certificate_arn       = "arn:aws:acm:us-east-2:588738578296:certificate/51169037-4469-4f7d-a898-57dfaae491e5"    # Add ACM certificate ARN for HTTPS
ssl_policy                = "ELBSecurityPolicy-TLS-1-2-2017-01"
enable_http_listener      = true    # Enable HTTP routing for development (disable in production with SSL)

# Domain Configuration
n8n_domain      = "n8n-dev.example.com"
chatwoot_domain = "chatwoot-dev.example.com"

# Port Configuration
n8n_port      = 5678
chatwoot_port = 3000

# Health Check Configuration
n8n_health_check_path      = "/healthz"
chatwoot_health_check_path = "/"