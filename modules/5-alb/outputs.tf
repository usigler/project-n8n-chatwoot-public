output "alb_id" {
  description = "ALB ID"
  value       = aws_lb.main.id
}

output "alb_arn" {
  description = "ALB ARN"
  value       = aws_lb.main.arn
}

output "alb_dns_name" {
  description = "ALB DNS name"
  value       = aws_lb.main.dns_name
}

output "alb_zone_id" {
  description = "ALB zone ID"
  value       = aws_lb.main.zone_id
}

output "n8n_target_group_arn" {
  description = "N8N target group ARN"
  value       = aws_lb_target_group.n8n.arn
}

output "chatwoot_target_group_arn" {
  description = "Chatwoot target group ARN"
  value       = aws_lb_target_group.chatwoot.arn
}

output "security_group_id" {
  description = "Security group ID for ALB"
  value       = aws_security_group.alb.id
}