output "website_bucket_name" {
  value = aws_s3_bucket.website_bucket.bucket
}
output "website_bucket_arn" {
  value = aws_s3_bucket.website_bucket.arn
}
output "website_bucket_id" {
  value = aws_s3_bucket.website_bucket.id
}
output "website_bucket_region" {
  value = data.aws_region.current.name
}

output "cloudfront_url" {
  value = "https://${aws_cloudfront_distribution.website.domain_name}"
}

