output "alb_dns_name" {
  value       = module.webserver_cluster.alb_dns_name
  description = "The domain name of the application load balancer"
}

output "asg_name" {
  value       = module.webserver_cluster.asg_name
  description = "autoscaling group name"
}

output "alb_security_group_id" {
  value       = module.webserver_cluster.alb_security_group_id
  description = "ID of Security Group attached to ALB"
}
