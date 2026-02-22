# Security Group Rules for ECS to access other services
resource "aws_security_group_rule" "ecs_to_rds" {
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.ecs_tasks.id
  security_group_id        = data.aws_security_group.rds.id
  description              = "Allow ECS tasks to access RDS PostgreSQL"
}

resource "aws_security_group_rule" "ecs_to_redis" {
  type                     = "ingress"
  from_port                = 6379
  to_port                  = 6379
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.ecs_tasks.id
  security_group_id        = data.aws_security_group.redis.id
  description              = "Allow ECS tasks to access Redis"
}

resource "aws_security_group_rule" "ecs_to_efs" {
  type                     = "ingress"
  from_port                = 2049
  to_port                  = 2049
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.ecs_tasks.id
  security_group_id        = data.aws_security_group.efs.id
  description              = "Allow ECS tasks to access EFS"
}
