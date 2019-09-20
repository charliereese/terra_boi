# ---------------------------------------------------------------------------------------------------------------------
# 1. STATE MODULE
# ---------------------------------------------------------------------------------------------------------------------

module "remote_state_locking" {
  source = "github.com/charliereese/terraform_modules//state?ref=v0.0.3"

  app_name = "clientelify"
  region   = "us-east-2"
}
