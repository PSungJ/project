# S3 버켓 생성
resource "aws_s3_bucket" "tbz" {
  bucket = format("%s.%s", "home", var.domain)
}

resource "aws_s3_bucket_policy" "tbzpy" {
  bucket = aws_s3_bucket.tbz.id
  policy = <<EOF
{
  "Id": "example",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "example",
      "Action": [
        "s3:GetObject"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::${aws_s3_bucket.tbz.id}/*",
      "Principal": "*"
    }
  ]
}
EOF
}

# S3 버켓 ACL 권한 설정
resource "aws_s3_bucket_acl" "tbz_bucket_acl" {
  bucket = aws_s3_bucket.tbz.id
  acl    = "public-read"
}

resource "aws_s3_bucket_versioning" "versioning_tbz" {
  bucket = aws_s3_bucket.tbz.id
  versioning_configuration {
    status = "Enabled"
  }
}

# S3 정적 웹 호스팅 설정
resource "aws_s3_bucket_website_configuration" "tbzweb" {
  bucket = aws_s3_bucket.tbz.bucket

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}


#s3 버켓에 파일 업로드, 형식마다 따로 content_type 설정해야 동작
resource "aws_s3_object" "html" {
  for_each     = fileset("./documents/", "*.html")
  bucket       = aws_s3_bucket.tbz.bucket
  acl          = "public-read"
  key          = each.value
  source       = "./documents/${each.value}"
  etag         = filemd5("./documents/${each.value}")
  content_type = "text/html"
}

resource "aws_s3_object" "svg" {
  for_each     = fileset("./documents/", "assets/css/images/*.svg")
  bucket       = aws_s3_bucket.tbz.bucket
  acl          = "public-read"
  key          = each.value
  source       = "./documents/${each.value}"
  etag         = filemd5("./documents/${each.value}")
  content_type = "image/svg+xml"
}

resource "aws_s3_object" "css" {
  for_each     = fileset("./documents/", "assets/css/*.css")
  bucket       = aws_s3_bucket.tbz.bucket
  acl          = "public-read"
  key          = each.value
  source       = "./documents/${each.value}"
  etag         = filemd5("./documents/${each.value}")
  content_type = "text/css"
}

resource "aws_s3_object" "js" {
  for_each     = fileset("./documents/", "assets/js/*.js")
  bucket       = aws_s3_bucket.tbz.bucket
  acl          = "public-read"
  key          = each.value
  source       = "./documents/${each.value}"
  etag         = filemd5("./documents/${each.value}")
  content_type = "text/javascript"
}

resource "aws_s3_object" "webfontssvg" {
  for_each     = fileset("./documents/", "assets/webfonts/*.svg")
  bucket       = aws_s3_bucket.tbz.bucket
  acl          = "public-read"
  key          = each.value
  source       = "./documents/${each.value}"
  etag         = filemd5("./documents/${each.value}")
  content_type = "image/svg+xml"
}

resource "aws_s3_object" "webfontswoff" {
  for_each     = fileset("./documents/", "assets/webfonts/*.woff")
  bucket       = aws_s3_bucket.tbz.bucket
  acl          = "public-read"
  key          = each.value
  source       = "./documents/${each.value}"
  etag         = filemd5("./documents/${each.value}")
  content_type = "application/font-woff"
}

resource "aws_s3_object" "imagesjpg" {
  for_each     = fileset("./documents/", "images/*.jpg")
  bucket       = aws_s3_bucket.tbz.bucket
  acl          = "public-read"
  key          = each.value
  source       = "./documents/${each.value}"
  etag         = filemd5("./documents/${each.value}")
  content_type = "image/jpeg"
}
