# Auto Scaling Target para Chatwoot
resource "aws_appautoscaling_target" "chatwoot" {
  max_capacity       = 4
  min_capacity       = 1
  resource_id        = "service/${aws_ecs_cluster.main.name}/${aws_ecs_service.chatwoot.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

# Auto Scaling Policy - CPU
resource "aws_appautoscaling_policy" "chatwoot_cpu" {
  name               = "${var.name_prefix}-chatwoot-cpu-scaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.chatwoot.resource_id
  scalable_dimension = aws_appautoscaling_target.chatwoot.scalable_dimension
  service_namespace  = aws_appautoscaling_target.chatwoot.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    target_value       = 70.0
    scale_in_cooldown  = 300
    scale_out_cooldown = 60
  }
}

# Auto Scaling Policy - Memory
resource "aws_appautoscaling_policy" "chatwoot_memory" {
  name               = "${var.name_prefix}-chatwoot-memory-scaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.chatwoot.resource_id
  scalable_dimension = aws_appautoscaling_target.chatwoot.scalable_dimension
  service_namespace  = aws_appautoscaling_target.chatwoot.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }
    target_value       = 80.0
    scale_in_cooldown  = 300
    scale_out_cooldown = 60
  }
}

# Auto Scaling Target para N8N
resource "aws_appautoscaling_target" "n8n" {
  max_capacity       = 3
  min_capacity       = 1
  resource_id        = "service/${aws_ecs_cluster.main.name}/${aws_ecs_service.n8n.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "n8n_cpu" {
  name               = "${var.name_prefix}-n8n-cpu-scaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.n8n.resource_id
  scalable_dimension = aws_appautoscaling_target.n8n.scalable_dimension
  service_namespace  = aws_appautoscaling_target.n8n.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    target_value       = 70.0
    scale_in_cooldown  = 300
    scale_out_cooldown = 60
  }
}

resource "aws_appautoscaling_policy" "n8n_memory" {
  name               = "${var.name_prefix}-n8n-memory-scaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.n8n.resource_id
  scalable_dimension = aws_appautoscaling_target.n8n.scalable_dimension
  service_namespace  = aws_appautoscaling_target.n8n.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }
    target_value       = 80.0
    scale_in_cooldown  = 300
    scale_out_cooldown = 60
  }
}

# Auto Scaling Target para Sidekiq
resource "aws_appautoscaling_target" "sidekiq" {
  max_capacity       = 3
  min_capacity       = 1
  resource_id        = "service/${aws_ecs_cluster.main.name}/${aws_ecs_service.sidekiq.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "sidekiq_cpu" {
  name               = "${var.name_prefix}-sidekiq-cpu-scaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.sidekiq.resource_id
  scalable_dimension = aws_appautoscaling_target.sidekiq.scalable_dimension
  service_namespace  = aws_appautoscaling_target.sidekiq.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    target_value       = 70.0
    scale_in_cooldown  = 300
    scale_out_cooldown = 60
  }
}

resource "aws_appautoscaling_policy" "sidekiq_memory" {
  name               = "${var.name_prefix}-sidekiq-memory-scaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.sidekiq.resource_id
  scalable_dimension = aws_appautoscaling_target.sidekiq.scalable_dimension
  service_namespace  = aws_appautoscaling_target.sidekiq.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }
    target_value       = 80.0
    scale_in_cooldown  = 300
    scale_out_cooldown = 60
  }
}
