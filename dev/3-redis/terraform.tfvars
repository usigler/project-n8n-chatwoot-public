# Redis Configuration
# Note: Subnets and security group access are managed automatically
# - Private App Subnets: discovered via Project tag
# - Security group access: managed by ECS module

node_type               = "cache.t3.small"
num_cache_nodes         = 1  # Set to 2+ for Multi-AZ
redis_version           = "7.0"
auth_token              = null  # Set a secure token in production
multi_az                = false  # Set to true in production for high availability

maintenance_window      = "sun:05:00-sun:06:00"
snapshot_retention_limit = 5
snapshot_window         = "03:00-05:00"