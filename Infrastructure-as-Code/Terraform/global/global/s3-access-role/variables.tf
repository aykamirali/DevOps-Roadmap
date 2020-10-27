variable "aws-account-id" {
  description = "The AWS Account ID"
}

variable "region" {
  description = "The AWS region like us-east-1/us-east-2"
}

variable "env" {
  description = "environment like tools/stg/prod/dev/sandbx"
}

variable "app-name" {
  description = "Application name or Its purpose example config, logs"
}

variable "cost-center" {
  description = "Cost center Code - for billing"
}

variable "department" {
  description = "Earnest various department Engineering/Infra"
}

variable "os" {
  description = "Operating system version like Ubuntu, AmazonLinux"
}


variable "encryption" {
  description = "Rescource encypted like SSE-S3, aes256, none or KMS "
}

variable "security-application" {
  description = "Security scanning tools installed on this resource like laceworks, Mcaffee etc"
}

variable "consumer-tags" {
  description = "Tags provided by consumer for their build"
  type        = map
  default     = {}
}

variable "read-only-access" {
  description = "Choose full access or readonly access policy to S3"
}


variable "role-resource-type" {
  description = "Type of resource like role"
}

variable "s3-bucket-name" {
  description = "S3 bucket name"
}
