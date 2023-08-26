provider "aws" {
  region = "us-west-2"
}

resource "aws_s3_bucket" "terraform-bucket" {
  bucket = "terraform-series-bucket-update-1"

  tags = {
    Name        = "Terraform Series"
  }
}
