
variable "vpc-app-name" {
  description = "Name of the application"
}

variable "db-app-name" {
  description = "Name of the application"
}

variable "automation-user-name" {
  description = "Infra Automation user"
}

variable "sqs-app-name" {
  description = "Name of the application"
}
variable "sqs-queue-name" {
  description = "SQS queue name"
}

variable "sns-app-name" {
  description = "Name of the application"
}
variable "sns-topic-name" {
  description = "SNS topic name"
}
variable "s3-app-name" {
  description = "Name of the S3 application"
  default     = ""
}
variable "s3-readonly-app-name" {
  description = "Name of the S3 application"
  default     = ""
}

variable "s3-bucket-name" {
  description = "S3 bucket name"
}
variable "read-only-access" {
  description = "Define full access or readonly access policy to S3"
  default     = false
}
