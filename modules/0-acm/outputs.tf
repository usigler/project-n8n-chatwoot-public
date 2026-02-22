output "certificate_arn" {
  description = "ARN of the imported ACM certificate"
  value       = aws_acm_certificate.imported.arn
}

output "certificate_domain_name" {
  description = "Domain name of the certificate"
  value       = aws_acm_certificate.imported.domain_name
}

output "certificate_status" {
  description = "Status of the certificate"
  value       = aws_acm_certificate.imported.status
}