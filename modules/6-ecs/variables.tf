variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "project_name" {
  description = "Project name for tagging"
  type        = string
}

variable "environment" {
  description = "Environment name for tagging"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "db_password" {
  description = "Domain name for N8N"
  type        = string
  default     = null
}

variable "n8n_domain" {
  description = "Domain name for N8N"
  type        = string
}

variable "n8n_efs_access_point_id" {
  description = "EFS access point ID for N8N"
  type        = string
}

variable "chatwoot_efs_access_point_id" {
  description = "EFS access point ID for Chatwoot"
  type        = string
}

variable "chatwoot_domain" {
  description = "Domain name for Chatwoot"
  type        = string
}

variable "n8n_port" {
  description = "Port for N8N container"
  type        = number
  default     = 5678
}

variable "chatwoot_port" {
  description = "Port for Chatwoot container"
  type        = number
  default     = 3000
}

variable "n8n_image" {
  description = "Docker image for N8N"
  type        = string
  default     = "n8nio/n8n:latest"
}

variable "n8n_cpu" {
  description = "CPU units for N8N task"
  type        = number
  default     = 512
}

variable "n8n_memory" {
  description = "Memory for N8N task"
  type        = number
  default     = 1024
}

variable "chatwoot_cpu" {
  description = "CPU units for Chatwoot task"
  type        = number
  default     = 512
}

variable "chatwoot_memory" {
  description = "Memory for Chatwoot task"
  type        = number
  default     = 1024
}

variable "n8n_desired_count" {
  description = "Desired count for N8N service"
  type        = number
  default     = 1
}

variable "chatwoot_desired_count" {
  description = "Desired count for Chatwoot service"
  type        = number
  default     = 1
}

variable "log_retention_days" {
  description = "CloudWatch log retention in days"
  type        = number
  default     = 7
}

variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)
  default     = {}
}