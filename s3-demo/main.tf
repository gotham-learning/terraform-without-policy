provider "aws" {
  region = "ap-southeast-1"
}

resource "aws_s3_bucket" "public-bucket" {
  bucket = "public-images-demo"
  acl    = "public-read"
}