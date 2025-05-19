variable "repository_owner" {
  description = "The owner of the GitHub repository"
  type        = string
}

variable "repository_name" {
  description = "The name of the GitHub repository"
  type        = string
}

variable "confluence_parent_id" {
  description = "The ID of the parent Confluence page where documentation should be created"
  type        = string
}

variable "confluence_space" {
  description = "The Confluence space key where the documentation should be created"
  type        = string
}

variable "title_prefix" {
  description = "Prefix to add to the Confluence page title"
  type        = string
  default     = "Repository: "
}

variable "contacts" {
  description = "List of contacts for the repository"
  type = list(object({
    name  = string
    email = string
    role  = string
  }))
  default = []
}

variable "include_collaborators" {
  description = "Whether to include collaborators in the repository documentation"
  type        = bool
  default     = true
}

variable "include_teams" {
  description = "Whether to include teams in the repository documentation"
  type        = bool
  default     = true
}

variable "include_environments" {
  description = "Whether to include environments in the repository documentation"
  type        = bool
  default     = true
}