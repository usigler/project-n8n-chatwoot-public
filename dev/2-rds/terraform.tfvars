# RDS Configuration
# Note: Subnets are automatically discovered via tags from VPC module
# - Private DB Subnets: 10.0.20.0/24, 10.0.21.0/24 (discovered via Project tag)
# Note: Security group access is managed by ECS module

postgres_version         = "17.7"
parameter_group_family   = "postgres17"
instance_class           = "db.t3.micro"
allocated_storage        = 20
max_allocated_storage    = 100

database_name    = "n8n_chatwoot"
master_username  = "postgres"

backup_retention_period = 7
skip_final_snapshot    = false   # Set to false in production
deletion_protection    = false  # Set to true in production
multi_az               = false  # Set to true in production for high availability