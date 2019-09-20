# ---------------------------------------------------------------------------------------------------------------------
# 1. STATE
# ---------------------------------------------------------------------------------------------------------------------

terraform {
  backend "s3" {
    bucket         = "clientelify-terraform-state-storage"
    key            = "terraform/staging-state/data"
    region         = "us-east-2"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# 2. DB + S3 MODULE
# ---------------------------------------------------------------------------------------------------------------------

variable "db_username" {}
variable "db_password" {}

module "db_and_s3" {
  source = "github.com/charliereese/terraform_modules//data?ref=v0.0.3"

  env               = "staging"
  app_name          = "clientelify"
  db_instance_class = "db.t2.micro"
  db_encrypted      = false
  db_username       = var.db_username
  db_password       = var.db_password
}
