locals {

  common-tags = {
    cost-center          = var.cost-center
    department           = var.department
    environment          = var.env
    region               = var.region
    operating-system     = var.os
    encryption           = var.encryption
    security-application = var.security-application

  }
}

data "template_file" "trust-policy-file" {
  template = "${file("${path.module}/trust-policy.json")}"

}

data "template_file" "access-policy-file" {
  template = "${file("${path.module}/access-policy.json")}"
  vars = {
    region         = "${var.region}"
    aws-account-id = "${var.aws-account-id}"
    sns-topic-name = "${var.sns-topic-name}"
  }
}

resource "aws_iam_role" "sns-access" {
  name               = "${var.app-name}-${var.env}-${var.region}"
  assume_role_policy = data.template_file.trust-policy-file.rendered

  tags = merge({
    Name             = "${var.app-name}-${var.env}-${var.region}"
    application-name = var.app-name
    resource-name    = "${var.app-name}-${var.role-resource-type}"
    resource-type    = var.role-resource-type

  }, local.common-tags, var.consumer-tags)

}

resource "aws_iam_policy" "access-policy" {
  name   = "${var.app-name}-${var.env}-${var.region}"
  policy = data.template_file.access-policy-file.rendered
}

resource "aws_iam_role_policy_attachment" "access-policy-role-attach" {
  role       = aws_iam_role.sns-access.name
  policy_arn = aws_iam_policy.access-policy.arn
}
