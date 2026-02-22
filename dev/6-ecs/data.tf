# Data source to get EFS outputs from remote state
data "terraform_remote_state" "efs" {
  backend = "s3"
  
  config = {
    bucket = "n8n-chatwoot-terraform-state-p4p534mh"
    key    = "efs/terraform.tfstate"
    region = "us-east-2"
  }
}
