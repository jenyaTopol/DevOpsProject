terraform {
  backend "s3" {
    bucket = "my-backupbucket-test"
    key    = "terrraform"
    region = "us-east-1"
  }
}
