output "sqs-access-arn" {
  description = "ARN of sqs-access IAM role"
  value       = "${aws_iam_role.sqs-access.arn}"
}


output "sqs-access-id" {
  description = "ID of sqs-access IAM role"
  value       = "${aws_iam_role.sqs-access.id}"
}
