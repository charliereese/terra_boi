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

module "db_s3" {
  source = "github.com/charliereese/terraform_modules//data?ref=v0.0.2"

  db_identifier     = "clientelify-staging"
  db_encrypted      = false
  db_instance_class = "db.t2.micro"
  s3_bucket_name    = "clientelify-staging-web-assets"
}
