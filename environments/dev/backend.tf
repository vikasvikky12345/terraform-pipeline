terraform {
  backend "s3" {
    bucket       = "vikas-terraform-state-334044477067"
    key          = "static-website/dev/terraform.tfstate"
    region       = "ap-south-1"
    encrypt      = true
    use_lockfile = true
  }
}