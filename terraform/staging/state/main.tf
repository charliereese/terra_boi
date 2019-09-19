# ---------------------------------------------------------------------------------------------------------------------
# 1. GENERAL
# ---------------------------------------------------------------------------------------------------------------------

terraform {
  required_version = ">= 0.12, < 0.13"
}

provider "aws" {
  region = var.region

  # Allow any 2.x version of the AWS provider
  version = "~> 2.0"
}

# ---------------------------------------------------------------------------------------------------------------------
# 2. STATE
# ---------------------------------------------------------------------------------------------------------------------

# Create s3 bucket for storing state
resource "aws_s3_bucket" "tf-state-storage" {
  bucket = "clientelify-terraform-state-storage"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = false
  }

  # Enable server-side encryption by default
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

# Create a dynamodb table for locking the state file
resource "aws_dynamodb_table" "dynamodb-terraform-state-lock" {
  name         = "terraform-state-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
