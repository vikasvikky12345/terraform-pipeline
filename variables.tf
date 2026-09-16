variable "region" {
  description = "The region to deploy the website to"
  type        = string
  default     = "ap-south-1"
}
variable "bucket_name" {
  description = "The name of the S3 bucket to deploy the website to"
  type        = string
  default     = "animated-gsap-website"
}
variable "tags" {
  description = "The tags to apply to the S3 bucket"
  type        = map(string)
  default = {
    Name = "animated-gsap-website"
  }
}