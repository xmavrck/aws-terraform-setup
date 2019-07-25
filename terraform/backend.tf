terraform {
  backend "s3" {
    bucket = "okd-cluster-state"
    key    = "okd_cluster.tfstate"
    region = "us-west-2"
  }
}
