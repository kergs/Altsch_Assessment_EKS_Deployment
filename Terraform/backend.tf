terraform {
  backend "s3" {
    bucket         = "your-terraform-state-bucket"  # create this beforehand
    key            = "project-bedrock/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-lock"         # create for state locking
    encrypt        = true
  }
}
