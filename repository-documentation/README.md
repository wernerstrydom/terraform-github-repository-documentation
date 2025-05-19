# Terraform GitHub Repository Documentation Module

This Terraform module creates documentation for GitHub repositories in Confluence using the Confluence Storage Format (XHTML).

## Features

- Creates Confluence documentation for a GitHub repository
- Includes repository details, settings, and contacts
- Automatically updates when repository details change
- Customizable page title prefix

## Usage

```hcl
module "github_repo_doc" {
  source = "path/to/repository-documentation"
  
  repository_owner = "your-github-org"
  repository_name  = "your-repo-name"
  
  confluence_parent_id = "1234567"  # ID of parent page in Confluence
  confluence_space = "SPACE"  # Confluence space key
  title_prefix     = "GitHub Repository: "  # Optional, defaults to "Repository: "
  
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
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0.0 |
| github | >= 5.0.0 |
| confluence | >= 0.0.3 |

## Providers

| Name | Version |
|------|---------|
| github | >= 5.0.0 |
| confluence | >= 0.0.3 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| repository_owner | The owner of the GitHub repository | `string` | n/a | yes |
| repository_name | The name of the GitHub repository | `string` | n/a | yes |
| confluence_parent_id | The ID of the parent Confluence page where documentation should be created | `string` | n/a | yes |
| confluence_space | The Confluence space key where the documentation should be created | `string` | n/a | yes |
| title_prefix | Prefix to add to the Confluence page title | `string` | `"Repository: "` | no |
| contacts | List of contacts for the repository | `list(object({ name = string, email = string, role = string }))` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| confluence_page_id | The ID of the created Confluence page |
| confluence_page_title | The title of the created Confluence page |
| confluence_page_space_key | The space key of the created Confluence page |
| confluence_page_url | The URL of the created Confluence page |

## Notes

- This module assumes that the GitHub and Confluence providers are already configured in the root module.
- The Confluence parent page must already exist and be specified by its ID.
- The template uses Confluence Storage Format (XHTML) to format the content.