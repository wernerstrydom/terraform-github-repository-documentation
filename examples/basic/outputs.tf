output "confluence_page_url" {
  description = "The URL of the created Confluence page"
  value       = module.github_repo_doc.confluence_page_url
}

output "confluence_page_id" {
  description = "The ID of the created Confluence page"
  value       = module.github_repo_doc.confluence_page_id
}

output "repository" {
    description = "The GitHub repository object"
    value       = module.github_repo_doc
}

output "repository_full_name" {
  description = "The full name of the GitHub repository"
  value       = "${var.repository_owner}/${var.repository_name}"
}