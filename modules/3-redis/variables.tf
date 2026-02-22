variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "node_type" {
  description = "ElastiCache node type"
  type        = string
  default     = "cache.t3.micro"
}

variable "num_cache_nodes" {
  description = "Number of cache nodes"
  type        = number
  default     = 1
}

variable "redis_version" {
  description = "Redis engine version"
  type        = string
  default     = "7.0"
}

variable "auth_token" {
  description = "Auth token for Redis"
  type        = string
  sensitive   = true
  default     = null
}

variable "maintenance_window" {
  description = "Maintenance window"
  type        = string
  default     = "sun:05:00-sun:06:00"
}

variable "snapshot_retention_limit" {
  description = "Number of days to retain snapshots"
  type        = number
  default     = 5
}

variable "snapshot_window" {
  description = "Daily time range for snapshots"
  type        = string
  default     = "03:00-05:00"
}

variable "multi_az" {
  description = "Enable Multi-AZ deployment for high availability (requires num_cache_nodes >= 2)"
  type        = bool
  default     = false
}

variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)
  default     = {}
}