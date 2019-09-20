output "address" {
  value       = module.db_and_s3.address
  description = "Connect to the database at this endpoint"
}

output "port" {
  value       = module.db_and_s3.port
  description = "The port the database is listening on"
}

output "endpoint" {
  value       = module.db_and_s3.endpoint
  description = "The endpoint of the databse"
}

output "db_name" {
  value       = module.db_and_s3.db_name
  description = "The name of the database"
}
