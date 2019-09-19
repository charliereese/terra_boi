# ---------------------------------------------------------------------------------------------------------------------
# 1. GENERAL
# ---------------------------------------------------------------------------------------------------------------------

# 1.1 REQUIRED

variable "cluster_name" {
  description = "The name to use for all the cluster resources"
  type        = string
}

variable "domain_name" {
  description = "Your domain name (e.g. example.com)"
  type        = string
}

# 1.2 OPTIONAL

variable "region" {
  description = "Region for database"
  type        = string
  default     = "us-east-2"
}

# ---------------------------------------------------------------------------------------------------------------------
# 2. WEB SERVERS
# ---------------------------------------------------------------------------------------------------------------------

# 2.1 REQUIRED

variable "ami" {
  description = "The AMI for the web servers"
  type        = string
}

variable "min_size" {
  description = "The minimum number of EC2 Instances in the ASG"
  type        = number
}

variable "max_size" {
  description = "The maximum number of EC2 Instances in the ASG"
  type        = number
}

variable "business_hours_size" {
  description = "Amount of default instances during business hours (9am - 9pm)"
  type        = number
}

variable "night_hours_size" {
  description = "Amount of default instances during night hours (9pm - 9am)"
  type        = number
}

# 2.2 OPTIONAL

variable "enable_autoscaling" {
  description = "Turn on / off autoscaling"
  type        = bool
  default     = true
}

variable "instance_type" {
  description = "The type of EC2 Instances to run (e.g. t2.micro)"
  type        = string
  default     = "t2.micro"
}

variable "server_port" {
  description = "The port the server will use for HTTP requests"
  type        = number
  default     = 3000
}

variable "server_text" {
  description = "The text the web server should return"
  default     = "Hello, World"
  type        = string
}

