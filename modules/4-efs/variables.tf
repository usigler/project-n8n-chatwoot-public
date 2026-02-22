variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "performance_mode" {
  description = "EFS performance mode"
  type        = string
  default     = "generalPurpose"

  validation {
    condition     = contains(["generalPurpose", "maxIO"], var.performance_mode)
    error_message = "Performance mode must be either 'generalPurpose' or 'maxIO'."
  }
}

variable "throughput_mode" {
  description = "EFS throughput mode"
  type        = string
  default     = "bursting"

  validation {
    condition     = contains(["bursting", "provisioned"], var.throughput_mode)
    error_message = "Throughput mode must be either 'bursting' or 'provisioned'."
  }
}

variable "transition_to_ia" {
  description = "Transition to Infrequent Access storage class"
  type        = string
  default     = "AFTER_30_DAYS"

  validation {
    condition = contains([
      "AFTER_7_DAYS", "AFTER_14_DAYS", "AFTER_30_DAYS", 
      "AFTER_60_DAYS", "AFTER_90_DAYS"
    ], var.transition_to_ia)
    error_message = "Invalid transition_to_ia value."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)
  default     = {}
}