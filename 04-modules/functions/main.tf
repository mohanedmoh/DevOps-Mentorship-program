# Nothing here talks to AWS. Run terraform apply and read the outputs, or
# open terraform console and try each expression by hand.
locals {
  # cidrsubnet(prefix, newbits, netnum) carves a smaller range out of a larger one.
  public_cidrs  = [for i in range(3) : cidrsubnet(var.vpc_cidr, 8, i)]
  private_cidrs = [for i in range(3) : cidrsubnet(var.vpc_cidr, 8, i + 100)]

  # lookup reads a map and falls back to a default. merge layers maps.
  instance_sizes = { dev = "t3.micro", prod = "t3.large" }
  environment    = "dev"
  instance_type  = lookup(local.instance_sizes, local.environment, "t3.small")
  base_tags      = { Project = "mentorship", Owner = "platform" }
  tags           = merge(local.base_tags, { Environment = local.environment })

  # for expressions build lists and maps from other lists.
  names        = [for i in range(3) : format("web-%02d", i + 1)]
  name_to_cidr = zipmap(local.names, local.public_cidrs)

  # flatten, values and sort tidy up nested data.
  groups    = { web = ["web-02", "web-01"], db = ["db-01"] }
  all_hosts = sort(flatten(values(local.groups)))

  # try turns an error into a fallback instead of a failed run. Its partner,
  # can, turns an error into true or false and is meant for variable validation
  # rules. See variables.tf.
  port = try(tonumber("eighty"), 80)
}

output "public_cidrs" {
  value = local.public_cidrs
}

output "private_cidrs" {
  value = local.private_cidrs
}

output "instance_type" {
  value = local.instance_type
}

output "tags" {
  value = local.tags
}

output "name_to_cidr" {
  value = local.name_to_cidr
}

output "all_hosts" {
  value = local.all_hosts
}

output "port" {
  value = local.port
}
