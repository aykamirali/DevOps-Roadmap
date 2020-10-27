output "s3-access-arn" {
  description = "ARN s3-access IAM role"
  value       = "${aws_iam_role.s3-access.arn}"
}


output "s3-access-id" {
  description = "ID of s3-access IAM role"
  value       = "${aws_iam_role.s3-access.id}"
}
