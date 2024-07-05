terraform {
  backend "s3" {
    bucket = "my-backupbucket-test"
    key    = "/"
    region = "us-east-1"
  }
}
