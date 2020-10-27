# run as terraform plan -var-file onevariables.tfvars
# run as terraform apply -var-file onevariables.tfvars



#common
#cloud-provider = "aws"
#client-locale  = "en-us"
aws-account-id       = 644712362974
region               = "us-west-2"
env                  = "playbx"
cost-center          = "5100"
department           = "Engineering/Infra"
profile              = "Okta-Sandbox-Administrator" #please change this to match your AWS profile
amz-server-ami       = "ami-086b16d6badeb5716"
is-prod              = false
automation-user-name = "infra-automation-user"
consumer-tags        = { is_pbe = true, }


# VPC details

vpc-app-name = "vpc"
vpc-cidr     = "10.42.72.0/25"
subnet-name  = ["public", "private"]
#public-cidr  = "10.42.72.0/26"
public-cidr-map = {
  us-west-2a = "10.42.72.0/28"
  us-west-2b = "10.42.72.16/28"
  us-west-2c = "10.42.72.32/28"
}
#private-cidr = "10.42.72.64/26"
private-cidr-map = {
  us-west-2a = "10.42.72.64/28"
  us-west-2b = "10.42.72.80/28"
  us-west-2c = "10.42.72.96/28"
}

az-map = {
  us-east-1    = "us-east-1a,us-east-1b,us-east-1c"
  us-east-2    = "us-east-2a,us-east-2b,us-east-2c"
  us-west-2    = "us-west-2a,us-west-2b,us-west-2c"
  eu-central-1 = "eu-central-1a,eu-central-1b,eu-central-1c"
}
vpc-cloudwatch-retention-days     = "120"
vpc-resource-type                 = "vpc"
vpc-resource-name                 = "vpc-pbe"
igw-resource-name                 = "igw-pbe"
natgw-resource-name               = "natgateway-pbe"
does-natgateway-require-staticEIP = true # True for systems in production where EIP is shared with partners. please create EIP manaully and add thoes to eip-allocation-id like below
eip-allocation-id                 = ["eipalloc-072d5ab161229058e", "eipalloc-03c561bed002c38e0", "eipalloc-002aeab8a061d90d6"]

#S3
config-bucket-app-name              = "config"
centrallogs-bucket-app-name         = "central-logs"
loadbalancer-logs-bucket-app-name   = "loadbalancer-logs"
s3-os                               = "none"
s3-resource-type                    = "s3"
s3-resource-name                    = "object-store"
config-bucket-encryption            = "aes256"
centrallogs-bucket-encryption       = "aes256"
loadbalancer-logs-bucket-encryption = "aes256"
s3-security-application             = "none"

/*
# VPC peering connection requester
peer-region                   = "us-west-2"
peer-aws-account-id           = 644712362974
peer-vpc-id                   = "vpc-00706c39a50d8a6eb"
accepter-peer-vpc-subnet-cidr = ["10.11.74.64/28", "10.11.74.80/28", "10.11.74.96/28", "10.11.74.0/28", "10.11.74.16/28", "10.11.74.32/28", ]

# VPC peering connection accepter
accepter-aws-profile           = "neeraj"
accepter-region                = "us-west-2"
accepter-route-table-id        = [
  "rtb-0fdf2f7a4deb86eca",
  "rtb-0728e2312312f4122",
  "rtb-0b2770d24e58347ee",
]
requester-peer-vpc-subnet-cidr = ["10.42.72.64/28", "10.42.72.80/28", "10.42.72.96/28",]

*/

# Global security group name that is used for inter application/compute communication
sg-app-name-public  = "public-compute-sg"
sg-app-name-private = "private-compute-sg"


# generic-Compute
generic-compute-name-public       = "test-ec2-public"
generic-compute-name-private      = "test-ec2-private"
personal-ip-cidr                  = ["1.2.3.4/32", "5.6.7.8/32"]
generic-compute-vm-type           = "t2.micro"
generic-autoscale-cluster-max     = 1
generic-autoscale-cluster-min     = 1
generic-autoscale-cluster-desired = 1
generic-os                        = "amzLinux"
consumer-tags-compute             = { "key" = "pbe", "value" = true, "propagate_at_launch" = true }


#RDS
db-app-name          = "rds-postgres"
db-port              = "5432"
sql-engine-version   = "12.3"
db-vm-type           = "db.t2.micro"
db-storage-type      = "gp2"
db-allocated-storage = "10"
db-iops              = 0
db-username          = "dbadmin"
db-password-file     = "passwd.txt"
db-name              = "test123"


#SQS
sqs-app-name   = "sqs-role"
sqs-queue-name = "sqs-queue-name"

#SNS
sns-app-name   = "sns-role"
sns-topic-name = "sns-topic-name"

#S3
s3-bucket-name       = "s3-bucket-name"
s3-app-name          = "S3-full-access"
s3-readonly-app-name = "S3-readonly-access"
