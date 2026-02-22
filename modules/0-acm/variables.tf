variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "private_key_path" {
  description = "Path to the private key file"
  type        = string
}

variable "certificate_path" {
  description = "Path to the certificate file"
  type        = string
}

variable "certificate_chain_path" {
  description = "Path to the certificate chain file"
  type        = string
}

variable "tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default     = {}
}