terraform {
  required_version = ">= 1.0.0"
  
  required_providers {
    github = {
      source  = "integrations/github"
      version = ">= 5.0.0"
    }
    
    confluence = {
      source  = "DrFaust92/confluence"
      version = ">= 0.0.3"
    }
  }
}