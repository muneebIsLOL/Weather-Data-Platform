data "aws_region" "current" {}

resource "aws_ecs_task_definition" "backend" {
  family = "${var.project_name}-${var.environment}-backend"

  container_definitions = <<TASK_DEFINITION
[
    {
        "name": "backend-api",
        "image": ${var.image},
        "cpu": 0,
        "portMappings": [
            {
                "containerPort": 8000,
                "hostPort": 8000,
                "protocol": "tcp",
                "name": "8000",
                "appProtocol": "http"
            }
        ],
        "essential": true,
        "environment": [
            {
                "name": "APP_DB_HOST",
                "value": "${var.app_db_host}"
            },
            {
                "name": "APP_POSTGRES_PASSWORD",
                "value": "${var.app_postgres_password}"
            },
            {
                "name": "APP_DB_NAME",
                "value": "${var.app_db_name}"
            },
            {
                "name": "APP_POSTGRES_USER",
                "value": "${var.app_postgres_user}"
            },
            {
                "name": "APP_AUTH_ACCESS_TOKEN",
                "value": "MySecureToken!"
            },
            {
                "name": "CI",
                "value": "false"
            }
        ],
        "mountPoints": [],
        "volumesFrom": [],
        "dependsOn": [
            {
                "containerName": "backend-db",
                "condition": "SUCCESS"
            }
        ],
        "logConfiguration": {
            "logDriver": "awslogs",
            "options": {
                "awslogs-group": "/ecs/${var.project_name}-${var.environment}-backend",
                "awslogs-create-group": "true",
                "awslogs-region": "${data.aws_region.current.region}",
                "awslogs-stream-prefix": "ecs"
            },
            "secretOptions": []
        },
        "healthCheck": {
            "command": [
                "CMD-SHELL",
                "curl -f http://127.0.0.1:8000/health >/dev/null 2>&1"
            ],
            "interval": 30,
            "timeout": 5,
            "retries": 3
        },
        "systemControls": []
    },
    {
        "name": "backend-db",
        "image": ${var.image},
        "cpu": 0,
        "portMappings": [],
        "essential": false,
        "entryPoint": [
            "/bin/sh",
            "-c",
            "./src/db/scripts/migrations.sh"
        ],
        "environment": [
            {
                "name": "APP_DB_HOST",
                "value": "${var.app_db_host}"
            },
            {
                "name": "APP_POSTGRES_PASSWORD",
                "value": "${var.app_postgres_password}"
            },
            {
                "name": "APP_DB_NAME",
                "value": "${var.app_db_name}"
            },
            {
                "name": "APP_POSTGRES_USER",
                "value": "${var.app_postgres_user}"
            },
            {
                "name": "CI",
                "value": "false"
            }
        ],
        "mountPoints": [],
        "volumesFrom": [],
        "logConfiguration": {
            "logDriver": "awslogs",
            "options": {
                "awslogs-group": "/ecs/${var.project_name}-${var.environment}-backend",
                "awslogs-create-group": "true",
                "awslogs-region": "${data.aws_region.current.region}",
                "awslogs-stream-prefix": "ecs"
            },
            "secretOptions": []
        },
        "systemControls": []
    }
]
    TASK_DEFINITION

  task_role_arn      = var.task_role_arn
  execution_role_arn = var.execution_role_arn
  network_mode       = "awsvpc"
  cpu                = 1024
  memory             = 4096
  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }
  enable_fault_injection   = false
  requires_compatibilities = ["FARGATE"]
}
