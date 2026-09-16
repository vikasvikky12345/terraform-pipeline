terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

module "website" {
  source = "../../modules/static-website"

  bucket_name = "animated-gsap-website"
  environment = "dev"
  website_dir = "${path.root}/../../www"

  tags = {
    Name        = "animated-gsap-website-dev"
    Environment = "dev"
  }
}

output "cloudfront_url" {
  value = module.website.cloudfront_url
}