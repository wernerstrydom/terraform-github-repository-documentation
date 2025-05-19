data "github_repository" "this" {
  full_name = "${var.repository_owner}/${var.repository_name}"
}

data "github_collaborators" "this" {
  count       = var.include_collaborators ? 1 : 0
  repository  = data.github_repository.this.name
  owner = var.repository_owner
  affiliation = "all"
}

data "github_repository_teams" "this" {
  count      = var.include_teams ? 1 : 0
  full_name = data.github_repository.this.full_name
}

data "github_repository_environments" "this" {
  count      = var.include_environments ? 1 : 0
  repository = data.github_repository.this.name
}

# Fetch environment details
data "github_rest_api" "environments" {
  for_each   = var.include_environments ? toset(data.github_repository_environments.this[0].environments.*.name) : []
  endpoint   = "repos/${var.repository_owner}/${var.repository_name}/environments/${each.key}"
}

# Fetch environment secrets
data "github_actions_environment_secrets" "this" {
  for_each   = var.include_environments ? toset(data.github_repository_environments.this[0].environments.*.name) : []
  full_name  = data.github_repository.this.full_name
  environment = each.key
}

# Fetch environment variables
data "github_actions_environment_variables" "this" {
  for_each   = var.include_environments ? toset(data.github_repository_environments.this[0].environments.*.name) : []
  full_name  = data.github_repository.this.full_name
  environment = each.key
}

data "github_repository_branches" "this" {
    repository = data.github_repository.this.name
}

locals {
  branch_map = {
    for branch in data.github_repository_branches.this.branches : branch.name => branch
  }

  branch_names = toset(data.github_repository_branches.this.branches.*.name)
  release_branch_names = toset([
    for name in local.branch_names : name
    if can(regex("^release[-/]", name))
  ])

  environment_names = toset(
    var.include_environments ? data.github_repository_environments.this[0].environments.*.name : []
  )
  environment_branch_names = setintersection(local.environment_names, local.branch_names)

  special_branch_names = setintersection(toset(["main", "master", "develop"]), local.branch_names)

  scoped_branch_names = setunion(
    local.release_branch_names,
    local.environment_branch_names,
    local.special_branch_names
  )

  special_branches = {
    for name in local.special_branch_names: name => merge(
      local.branch_map[name],
      {
        protection = try(jsondecode(data.github_rest_api.branch_protection[name].body), null)
        rules = try(jsondecode(data.github_rest_api.branch_rules[name].body), null)
      }
    )
  }
  environment_branches = {
    for name in local.environment_branch_names: name => merge(
      local.branch_map[name],
      {
        protection = try(jsondecode(data.github_rest_api.branch_protection[name].body), null)
        rules = try(jsondecode(data.github_rest_api.branch_rules[name].body), null)
      }
    )
  }
  release_branches = {
    for name in local.release_branch_names: name => merge(
      local.branch_map[name],
      {
        protection = try(jsondecode(data.github_rest_api.branch_protection[name].body), null)
        rules = try(jsondecode(data.github_rest_api.branch_rules[name].body), null)
      }
    )
  }
}

data "github_rest_api" "branch" {
  for_each = local.scoped_branch_names
  endpoint = "repos/${var.repository_owner}/${var.repository_name}/branches/${each.key}"
}

data "github_rest_api" "branch_protection" {
  for_each = local.scoped_branch_names
  endpoint = "repos/${var.repository_owner}/${var.repository_name}/branches/${each.key}/protection"
}

data "github_rest_api" "branch_rules" {
  for_each = local.scoped_branch_names
  endpoint = "repos/${var.repository_owner}/${var.repository_name}/rules/branches/${each.key}"
}

output "branches" {
  value = {
    "special" = local.special_branches,
    "environments" = local.environment_branches,
    "releases" = local.release_branches
  }
}

# Combine all environment data
locals {
  environments = {
    for env_name in var.include_environments ? toset(data.github_repository_environments.this[0].environments.*.name) : [] : env_name => merge(
      jsondecode(data.github_rest_api.environments[env_name].body),
      {
        variables = data.github_actions_environment_variables.this[env_name].variables,
        secrets = data.github_actions_environment_secrets.this[env_name].secrets
      }
    )
  }
}

locals {
  repository_full_name = "${var.repository_owner}/${var.repository_name}"
  page_title           = "${var.title_prefix}${var.repository_name}"
  
  collaborators = var.include_collaborators ? data.github_collaborators.this[0].collaborator : []
  teams         = var.include_teams ? data.github_repository_teams.this[0].teams : []

  # Pass the entire repository object to the template
  page_content = templatefile("${path.module}/templates/repository.tftpl", {
    repository             = data.github_repository.this
    repository_full_name   = local.repository_full_name
    contacts               = var.contacts
    collaborators          = local.collaborators
    teams                  = local.teams
    environments           = local.environments
    branches               = {
      special      = local.special_branches
      environments = local.environment_branches
      releases     = local.release_branches
      all          = local.branch_map
    }
    include_collaborators  = var.include_collaborators
    include_teams          = var.include_teams
    include_environments   = var.include_environments
  })
}

resource "confluence_content" "this" {
  title   = local.page_title
  body    = local.page_content
  space   = var.confluence_space
  parent  = var.confluence_parent_id
  type    = "page"
}

