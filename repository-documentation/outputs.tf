output "confluence_page_id" {
  description = "The ID of the created Confluence page"
  value       = confluence_content.this.id
}

output "confluence_page_title" {
  description = "The title of the created Confluence page"
  value       = confluence_content.this.title
}

output "confluence_page_space_key" {
  description = "The space key of the created Confluence page"
  value       = confluence_content.this.space
}

output "confluence_page_url" {
  description = "The URL of the created Confluence page"
  value       = confluence_content.this.url
}