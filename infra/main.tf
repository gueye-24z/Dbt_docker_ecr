# Provider AWS
provider "aws" {
  region = "eu-west-3"
}

# Récupérer le Cluster ECS existant
data "aws_ecs_cluster" "existing_cluster" {
  cluster_name = "cluster_docker"
}

# Récupérer le Rôle IAM existant
data "aws_iam_role" "ecs_task_execution_role" {
  name = "VXEcsTaskExecutionRole"
}

# Groupe de logs CloudWatch pour ECS
resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name              = "/ecs/Dbt_docker_ecr"  # Nom du groupe de logs pertinent
  retention_in_days = 7  # Retention des logs (7 jours ici, ajustable)

  lifecycle {
      prevent_destroy = true
      ignore_changes = [name]
    }
}

# Task Definition ECS avec variables d'environnement Snowflake et logs CloudWatch
resource "aws_ecs_task_definition" "my_task" {
  family                = var.TASK_NAME
  network_mode          = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                   = "2048"
  memory                = "4096"
  execution_role_arn    = data.aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([{
    name      = "make_dbt_transformation"
    image     = "442426866837.dkr.ecr.eu-west-3.amazonaws.com/dbt_transform_comments:v1.0"
    cpu       = 2048
    memory    = 4096
    essential = true

    # Configuration des logs CloudWatch
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-group         = aws_cloudwatch_log_group.ecs_log_group.name
        awslogs-region        = "eu-west-3"
        awslogs-stream-prefix = "ecs"
      }
    }

    environment = [
      {
        name  = "SNOWFLAKE_ACCOUNT"
        value = var.SNOWFLAKE_ACCOUNT
      },
      {
        name  = "SNOWFLAKE_USER"
        value = var.SNOWFLAKE_USER
      },
      {
        name  = "SNOWFLAKE_PASSWORD"
        value = var.SNOWFLAKE_PASSWORD
      },
      {
        name  = "SNOWFLAKE_ROLE"
        value = var.SNOWFLAKE_ROLE
      },
      {
        name  = "SNOWFLAKE_DATABASE"
        value = var.SNOWFLAKE_DATABASE
      },
      {
        name  = "SNOWFLAKE_WAREHOUSE"
        value = var.SNOWFLAKE_WAREHOUSE
      },
      {
        name  = "SNOWFLAKE_NEW_SCHEMA"
        value = var.SNOWFLAKE_SCHEMA
      }
    ]
  }])
}