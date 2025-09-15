provider "aws" {
  region = "eu-north-1"
}


resource "aws_s3_bucket" "tf_bucket" {
  bucket = var.bucket_name
   
}

resource "aws_s3_bucket_website_configuration" "static_website" {
  bucket = aws_s3_bucket.tf_bucket.id

  index_document {
    suffix = "index.html"
  }

}

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.tf_bucket.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}


resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.tf_bucket.id
  policy = data.aws_iam_policy_document.public_read_policy.json
  depends_on = [ aws_s3_bucket_public_access_block.public_access ]
}

resource "aws_s3_object" "object" {
  bucket = aws_s3_bucket.tf_bucket.id
  key    = "index.html"
  source = "../index.html"
 # etag   = filemd5("../website/index.html")
  content_type = "text/html"
}


# =======================================================
# IAM Policy to allow public read access to the bucket
# =======================================================
# This policy is to allow public read access to the S3 bucket
data "aws_iam_policy_document" "public_read_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.tf_bucket.arn}/*"]
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    effect = "Allow"
  }

}

output "name" {
  value = aws_s3_bucket.tf_bucket.bucket
}

output "website_endpoint" {
  value = aws_s3_bucket.tf_bucket.website_endpoint
  
}