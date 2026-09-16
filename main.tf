resource "aws_s3_bucket" "website_bucket" {
  bucket = "${var.bucket_name}-${data.aws_caller_identity.current.account_id}"
  tags   = var.tags
}
resource "aws_s3_bucket_public_access_block" "website_bucket_public_access_block" {
  bucket                  = aws_s3_bucket.website_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

}

resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.website_bucket.id
  key          = "index.html"
  source       = "${path.module}/www/index.html"
  etag         = filemd5("${path.module}/www/index.html")
  content_type = "text/html"
}

resource "aws_s3_object" "css" {
  bucket       = aws_s3_bucket.website_bucket.id
  key          = "style.css"
  source       = "${path.module}/www/style.css"
  etag         = filemd5("${path.module}/www/style.css")
  content_type = "text/css"
}

resource "aws_s3_object" "js" {
  bucket       = aws_s3_bucket.website_bucket.id
  key          = "script.js"
  source       = "${path.module}/www/script.js"
  etag         = filemd5("${path.module}/www/script.js")
  content_type = "application/javascript"
}
resource "aws_cloudfront_origin_access_control" "website" {
  name                              = "${aws_s3_bucket.website_bucket.bucket}-oac"
  description                       = "OAC for ${aws_s3_bucket.website_bucket.bucket}"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "website" {
  enabled             = true
  is_ipv6_enabled     = true
  comment             = var.bucket_name
  default_root_object = "index.html"
  price_class         = "PriceClass_200"
  tags                = var.tags

  origin {
    domain_name              = aws_s3_bucket.website_bucket.bucket_regional_domain_name
    origin_id                = "s3-website"
    origin_access_control_id = aws_cloudfront_origin_access_control.website.id
  }

  default_cache_behavior {
    target_origin_id       = "s3-website"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

resource "aws_s3_bucket_policy" "website" {
  bucket = aws_s3_bucket.website_bucket.id
  policy = data.aws_iam_policy_document.cloudfront_oac.json

  depends_on = [aws_s3_bucket_public_access_block.website_bucket_public_access_block]
}
