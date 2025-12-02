terraform {
  backend "s3" {
    bucket  = "<YOUR-UNIQUE-S3-BUCKET-NAME-HERE>"
    key     = "prod/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}