# output "cluster_id" {
#   description = "EKS cluster ID"
#   value       = module.eks.cluster_id
# }

# output "cluster_endpoint" {
#   description = "Endpoint for EKS control plane"
#   value       = module.eks.cluster_endpoint
# }

# output "cluster_security_group_id" {
#   description = "Security group ids attached to the cluster control plane"
#   value       = module.eks.cluster_security_group_id
# }

# output "region" {
#   description = "AWS region"
#   value       = var.region
# }

# output "cluster_name" {
#   description = "Kubernetes Cluster Name"
#   value       = local.cluster_name
# }

# output "db_instance_name" {
#   description = "The database name"
#   value       = module.db.db_instance_name
# }

# output "db_instance_address" {
#   description = "The address of the RDS instance"
#   value       = module.db.db_instance_address
# }

# output "db_instance_username" {
#   description = "The master username for the database"
#   value       = module.db.db_instance_username
#   sensitive   = true
# }

# output "db_instance_password" {
#   description = "The database password (this password may be old, because Terraform doesn't track it after initial creation)"
#   value       = module.db.db_instance_password
#   sensitive   = true
# }

# output "db_instance_cloudwatch_log_groups" {
#   description = "Map of CloudWatch log groups created and their attributes"
#   value       = module.db.db_instance_cloudwatch_log_groups
# }