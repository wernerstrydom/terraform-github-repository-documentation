provider "github" {
  # Configuration options come from environment variables or .tfvars file
  # GITHUB_TOKEN or token
  owner = "wernerstrydom-examples"
}

provider "confluence" {
  # Configuration options come from environment variables or .tfvars file
  # CONFLUENCE_URL or url
  # CONFLUENCE_USERNAME or username 
  # CONFLUENCE_PASSWORD or password
  site = "bloudraak.atlassian.net"
}

# Example parent page in Confluence must already exist
# You would need to have the actual page ID for your Confluence instance
locals {
  confluence_parent_page_id = "123456" # Replace with actual page ID
}

module "github_repo_doc" {
  source = "../../repository-documentation"
  
  repository_owner = "wernerstrydom-examples"
  repository_name  = "github-compliance-test-repo"
  
  confluence_parent_id = "1037107201"
  confluence_space = "Demo"
  title_prefix              = "GitHub Repository: "
  
  contacts = [
    {
      name  = "Jane Doe"
      email = "jane.doe@example.com"
      role  = "Repository Owner"
    },
    {
      name  = "John Smith"
      email = "john.smith@example.com"
      role  = "Maintainer"
    }
  ]
}