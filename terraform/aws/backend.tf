terraform {
  backend "s3" {
    bucket = "mybucket"
    key    = "/"
    region = "us-east-1"
  }
}
