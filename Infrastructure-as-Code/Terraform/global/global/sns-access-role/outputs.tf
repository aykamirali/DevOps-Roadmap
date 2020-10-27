output "sns-access-arn" {
  description = "ARN sns-access IAM role"
  value       = "${aws_iam_role.sns-access.arn}"
}


output "sns-access-id" {
  description = "ID of sns-access IAM role"
  value       = "${aws_iam_role.sns-access.id}"
}
