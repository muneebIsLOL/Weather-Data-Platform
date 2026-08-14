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
                "value": ${var.app_db_host}
            },
            {
                "name": "APP_POSTGRES_PASSWORD",
                "value": ${var.app_postgres_password}
            },
            {
                "name": "APP_DB_NAME",
                "value": ${var.app_db_name}
            },
            {
                "name": "APP_POSTGRES_USER",
                "value": ${var.app_postgres_user}
            },
            {
                "name": "APP_AUTH_ACCESS_TOKEN",
                "value": "MySecureToken!"
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
                "awslogs-region": "ap-south-1",
                "awslogs-stream-prefix": "ecs"
            },
            "secretOptions": []
        },
        "healthCheck": {
            "command": [
                "CMD-SHELL",
                "curl -f http://127.0.0.1:8000/docs || >/dev/null"
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
                "value": ${var.app_db_host}
            },
            {
                "name": "APP_POSTGRES_PASSWORD",
                "value": ${var.app_postgres_password}
            },
            {
                "name": "APP_DB_NAME",
                "value": ${var.app_db_name}
            },
            {
                "name": "APP_POSTGRES_USER",
                "value": ${var.app_postgres_user}
            }
        ],
        "mountPoints": [],
        "volumesFrom": [],
        "logConfiguration": {
            "logDriver": "awslogs",
            "options": {
                "awslogs-group": "/ecs/${var.project_name}-${var.environment}-backend",
                "awslogs-create-group": "true",
                "awslogs-region": "ap-south-1",
                "awslogs-stream-prefix": "ecs"
            },
            "secretOptions": []
        },
        "systemControls": []
    },
    "taskRoleArn": ${var.task_role_arn},
    "executionRoleArn": ${var.execution_role_arn},
    "networkMode": "awsvpc",
    "volumes": [],
    "placementConstraints": [],
    "requiresCompatibilities": [
        "FARGATE"
    ],
    "cpu": "1024",
    "memory": "4096",
    "runtimePlatform": {
        "cpuArchitecture": "X86_64",
        "operatingSystemFamily": "LINUX"
    },
    "enableFaultInjection": false
]
    TASK_DEFINITION
}
