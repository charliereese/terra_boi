output "address" {
  value       = aws_db_instance.primary.address
  description = "Connect to the database at this endpoint"
}

output "port" {
  value       = aws_db_instance.primary.port
  description = "The port the database is listening on"
}

output "endpoint" {
  value       = aws_db_instance.primary.endpoint
  description = "The endpoint of the databse"
}

output "db_name" {
  value       = aws_db_instance.primary.name
  description = "The name of the database"
}
