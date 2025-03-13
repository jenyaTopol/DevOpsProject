terraform {
  backend "s3" {
    bucket = "my-backupbucket-test-1"
    key    = "terrraform"
    region = "us-west-2"
  }
}