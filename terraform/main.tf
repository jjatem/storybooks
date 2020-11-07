terraform {
  backend "gcs" {
    bucket = "storybooks-devops-jj-terraform"
    prefix = "/state/storybooks"
  }
}
