resource "aws_ecs_task_definition" "frontend" {
  family = "${var.project_name}-${var.environment}-frontend"

  container_definitions = <<TASK_DEFINITION
[
<<<<<<< HEAD
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
<<<<<<< HEAD
            "environment": [],
=======
            "environment": [
                {
                    "name": "VITE_HOST_URL"
                    "value": "${var.vite_host_url}"
                }
            ],
>>>>>>> 93bd191 (fix(ecs): enclose every variable inside quotes to prevent syntax and type errors)
            "environmentFiles": [],
            "mountPoints": [],
            "volumesFrom": [],
            "ulimits": [],
            "logConfiguration": {
                "logDriver": "awslogs",
                "options": {
                    "awslogs-group": "/ecs/${var.project_name}-${var.environment}-frontend",
                    "awslogs-create-group": "true",
<<<<<<< HEAD
                    "awslogs-region": "ap-south-1",
=======
                    "awslogs-region": "${data.aws_region.current.region}",
>>>>>>> 93bd191 (fix(ecs): enclose every variable inside quotes to prevent syntax and type errors)
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
    "taskRoleArn": "${var.task_role_arn}",
    "executionRoleArn": "${var.execution_role_arn}",
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
=======
    {
        "name": "web",
        "image": "${var.image}",
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
        "environment": [
            {
                "name": "VITE_HOST_URL",
                "value": "${var.vite_host_url}"
            }
        ],
        "environmentFiles": [],
        "mountPoints": [],
        "volumesFrom": [],
        "ulimits": [],
        "logConfiguration": {
            "logDriver": "awslogs",
            "options": {
                "awslogs-group": "/ecs/${var.project_name}-${var.environment}-frontend",
                "awslogs-create-group": "true",
                "awslogs-region": "${data.aws_region.current.region}",
                "awslogs-stream-prefix": "ecs"
            },
            "secretOptions": []
        },
        "healthCheck": {
            "command": [
                "CMD-SHELL",
                "curl -f http://127.0.0.1:5173/health >/dev/null 2>&1"
            ],
            "interval": 10,
            "timeout": 30,
            "retries": 5,
            "startPeriod": 5
        },
        "systemControls": []
    }
>>>>>>> 23c1335 (refactor(terraform): properly define ECS tasks with separate resource configurations)
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
