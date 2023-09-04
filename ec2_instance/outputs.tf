output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.app_server.id
}

output "instance_arn" {
  description = "ID of the EC2 instance"
  value       = aws_instance.app_server.arn
}

output "instance_state" {
  description   = "The state of the instance"
   value        = aws_instance.app_server.instance_state

}