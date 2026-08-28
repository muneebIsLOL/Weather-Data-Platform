resource "aws_ecs_task_definition" "frontend" {
  family = "${var.project_name}-${var.environment}-frontend"

  container_definitions = <<TASK_DEFINITION
[
    [
        {
            "name": "web",
            "image": ${var.image}",
            "cpu": 0,
            "portMappings": [
                {
                    "containerPort": 5173,
                    "hostPort": 5173,
                    "protocol": "tcp",
                    "name": "5173",
                    "appProtocol": "http"
                }
            ],
            "essential": true,
            "environment": [],
            "environmentFiles": [],
            "mountPoints": [],
            "volumesFrom": [],
            "ulimits": [],
            "logConfiguration": {
                "logDriver": "awslogs",
                "options": {
                    "awslogs-group": "/ecs/${var.project_name}-${var.environment}-frontend",
                    "awslogs-create-group": "true",
                    "awslogs-region": "ap-south-1",
                    "awslogs-stream-prefix": "ecs"
                },
                "secretOptions": []
            },
            "healthCheck": {
                "command": [
                    "CMD-SHELL",
                    "curl -f http://127.0.0.1:5173 || >/dev/null"
                ],
                "interval": 10,
                "timeout": 30,
                "retries": 5,
                "startPeriod": 5
            },
            "systemControls": []
        }
    ],
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
