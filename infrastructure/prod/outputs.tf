output "eks_cluster_name" {
  description = "The name of the EKS cluster."
  value       = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  description = "The endpoint for your EKS Kubernetes API server."
  value       = module.eks.cluster_endpoint
}

output "ecr_repository_url" {
  description = "The URL of the ECR repository to push images to."
  value       = module.eks.ecr_repository_url
}