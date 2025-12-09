terraform {
  backend "s3" {
    bucket         = "jenkins-lab-tf-state-zubeq"
    key            = "app-lab/terraform.tfstate"
    region         = "eu-central-1"
    encrypt        = true
    dynamodb_table = "jenkins-lab-tf-lock"
  }
}