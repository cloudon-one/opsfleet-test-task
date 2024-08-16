data "aws_availability_zones" "available" {}
data "aws_ecrpublic_authorization_token" "token" {
  provider = aws.virginia
}

locals {
  name         = "demo-${basename(path.cwd)}"
  region       = "eu-north-1"
  cluster_name = var.cluster_name
  vpc_cidr = "10.0.0.0/16"
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)

  tags = {
    purpose = "demo"
    owner   = "yaar"
  }
}

