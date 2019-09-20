# ---------------------------------------------------------------------------------------------------------------------
# 1. STATE
# ---------------------------------------------------------------------------------------------------------------------

terraform {
  backend "s3" {
    bucket         = "clientelify-terraform-state-storage"
    key            = "terraform/staging-state/web-servers"
    region         = "us-east-2"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# 2. WEB SERVERS MODULE
# ---------------------------------------------------------------------------------------------------------------------

module "webserver_cluster" {
  source = "github.com/charliereese/terraform_modules//web_servers?ref=v0.0.3"

  ami                 = "ami-0c55b159cbfafe1f0"
  instance_type       = "t2.micro"
  env                 = "staging"
  app_name            = "clientelify"
  domain_name         = "clientelify.com"
  min_size            = 1
  max_size            = 1
  business_hours_size = 1
  night_hours_size    = 1
}
