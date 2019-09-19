# ---------------------------------------------------------------------------------------------------------------------
# 1. GENERAL
# ---------------------------------------------------------------------------------------------------------------------

terraform {
  required_version = ">= 0.12, < 0.13"
}

provider "aws" {
  region = var.db_region

  # Allow any 2.x version of the AWS provider
  version = "~> 2.0"
}

# ---------------------------------------------------------------------------------------------------------------------
# 2. STATE
# ---------------------------------------------------------------------------------------------------------------------

terraform {
  backend "s3" {
    bucket         = "clientelify-terraform-state-storage"
    key            = "terraform/staging-state"
    region         = "us-east-2"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# 3. DATABASE
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_db_instance" "primary" {
  identifier_prefix      = var.db_identifier
  engine                 = var.db_engine
  allocated_storage      = var.allocated_storage
  max_allocated_storage  = var.max_allocated_storage
  instance_class         = var.db_instance_class
  name                   = var.db_name
  username               = var.db_username
  password               = var.db_password
  storage_encrypted      = var.db_encrypted
  skip_final_snapshot    = var.skip_final_snapshot
  publicly_accessible    = true
  vpc_security_group_ids = [aws_security_group.instance.id]
}

# ---------------------------------------------------------------------------------------------------------------------
# 4. SECURITY GROUPS
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_security_group" "instance" {
  name = "${var.db_identifier}-db-instance"
}

resource "aws_security_group_rule" "allow_server_http_inbound" {
  type              = "ingress"
  security_group_id = aws_security_group.instance.id

  from_port   = local.db_port
  to_port     = local.db_port
  protocol    = local.tcp_protocol
  cidr_blocks = local.all_ips
}

locals {
  db_port      = 5432
  tcp_protocol = "tcp"
  all_ips      = ["0.0.0.0/0"]
}

