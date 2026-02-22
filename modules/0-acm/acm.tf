# Import existing Let's Encrypt certificate to ACM
resource "aws_acm_certificate" "imported" {
  private_key       = file(var.private_key_path)
  certificate_body  = file(var.certificate_path)
  certificate_chain = file(var.certificate_chain_path)

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-letsencrypt-certificate"
  })
}