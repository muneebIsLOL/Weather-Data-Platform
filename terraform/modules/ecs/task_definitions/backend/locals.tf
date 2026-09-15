locals {
  my_container_defs = aws_ecs_task_definition.backend.container_definitions

  decoded_defs = jsondecode(local.my_container_defs)

  env_vars = local.decoded_defs[0].environment

  api_token = [for env in local.env_vars : env.value if env.name == "APP_AUTH_ACCESS_TOKEN"][0]
}
