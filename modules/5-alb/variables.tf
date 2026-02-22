variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "enable_deletion_protection" {
  description = "Enable deletion protection for ALB"
  type        = bool
  default     = false
}

variable "ssl_certificate_arn" {
  description = "SSL certificate ARN for HTTPS listener"
  type        = string
  default     = null
}

variable "ssl_policy" {
  description = "SSL policy for HTTPS listener"
  type        = string
  default     = "ELBSecurityPolicy-TLS-1-2-2017-01"
}

variable "n8n_domain" {
  description = "Domain name for N8N application"
  type        = string
}

variable "chatwoot_domain" {
  description = "Domain name for Chatwoot application"
  type        = string
}

variable "n8n_port" {
  description = "Port for N8N application"
  type        = number
  default     = 5678
}

variable "chatwoot_port" {
  description = "Port for Chatwoot application"
  type        = number
  default     = 3000
}

variable "n8n_health_check_path" {
  description = "Health check path for N8N"
  type        = string
  default     = "/healthz"
}

variable "chatwoot_health_check_path" {
  description = "Health check path for Chatwoot"
  type        = string
  default     = "/health"
}

variable "enable_http_listener" {
  description = "Enable HTTP listener with path-based routing (for development without SSL)"
  type        = bool
  default     = false
}

variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)
  default     = {}
}