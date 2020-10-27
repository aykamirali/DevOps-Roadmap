provider "aws" {
  region  = var.region
  profile = var.profile
}

module "dummy-role" {
  source = "../modules/init/dummy-role"
}

module "automation-user" {
  source         = "../modules/init/automation-user"
  region         = var.region
  env            = var.env
  aws-account-id = var.aws-account-id
  user-name      = var.automation-user-name
}

module "automation-role" {
  source                 = "../modules/init/automation-service-role"
  region                 = var.region
  env                    = var.env
  aws-account-id         = var.aws-account-id
  is-automation-user-iam = false
}

module "automation-iam-role" {
  source                 = "../modules/init/automation-service-role"
  region                 = var.region
  env                    = var.env
  aws-account-id         = var.aws-account-id
  is-automation-user-iam = true
}

module "flow-log-iam-role" {
  source               = "../modules/foundations/vpc/flow-logs-role"
  region               = var.region
  env                  = var.env
  cost-center          = var.cost-center
  department           = var.department
  consumer-tags        = var.consumer-tags
  encryption           = var.encryption
  os                   = var.os
  role-resource-type   = var.role-resource-type
  security-application = var.security-application
  aws-account-id       = var.aws-account-id
  app-name             = var.vpc-app-name
  log-group-name       = "${var.vpc-app-name}-${var.env}-${var.region}" #replace this with data from statefile when available
}

module "enhanced-monitoring-role" {
  source               = "../modules/databases/enhanced-monitoring-role"
  region               = var.region
  env                  = var.env
  cost-center          = var.cost-center
  department           = var.department
  consumer-tags        = var.consumer-tags
  encryption           = var.encryption
  os                   = var.os
  role-resource-type   = var.role-resource-type
  security-application = var.security-application
  aws-account-id       = var.aws-account-id
  app-name             = var.db-app-name

}

module "sqs-access-role" {
  source               = "../modules/global/sqs-access-role"
  region               = var.region
  env                  = var.env
  cost-center          = var.cost-center
  department           = var.department
  consumer-tags        = var.consumer-tags
  encryption           = var.encryption
  os                   = var.os
  role-resource-type   = var.role-resource-type
  security-application = var.security-application
  aws-account-id       = var.aws-account-id
  app-name             = var.sqs-app-name
  sqs-queue-name       = var.sqs-queue-name

}
module "sns-access-role" {
  source               = "../modules/global/sns-access-role"
  region               = var.region
  env                  = var.env
  cost-center          = var.cost-center
  department           = var.department
  consumer-tags        = var.consumer-tags
  encryption           = var.encryption
  os                   = var.os
  role-resource-type   = var.role-resource-type
  security-application = var.security-application
  aws-account-id       = var.aws-account-id
  app-name             = var.sns-app-name
  sns-topic-name       = var.sns-topic-name

}
module "s3-full-access-role" {
  source               = "../modules/global/s3-access-role"
  region               = var.region
  env                  = var.env
  cost-center          = var.cost-center
  department           = var.department
  consumer-tags        = var.consumer-tags
  encryption           = var.encryption
  os                   = var.os
  role-resource-type   = var.role-resource-type
  security-application = var.security-application
  aws-account-id       = var.aws-account-id
  app-name             = var.s3-app-name
  s3-bucket-name       = var.s3-bucket-name
  read-only-access     = false

}

module "s3-readonly-access-role" {
  source               = "../modules/global/s3-access-role"
  region               = var.region
  env                  = var.env
  cost-center          = var.cost-center
  department           = var.department
  consumer-tags        = var.consumer-tags
  encryption           = var.encryption
  os                   = var.os
  role-resource-type   = var.role-resource-type
  security-application = var.security-application
  aws-account-id       = var.aws-account-id
  app-name             = var.s3-readonly-app-name
  s3-bucket-name       = var.s3-bucket-name
  read-only-access     = true

}
