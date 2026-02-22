# EFS Configuration
# Note: Subnets and security group access are managed automatically
# - Private App Subnets: discovered via Project tag
# - Security group access: managed by ECS module

performance_mode = "generalPurpose"
throughput_mode  = "bursting"
transition_to_ia = "AFTER_30_DAYS"