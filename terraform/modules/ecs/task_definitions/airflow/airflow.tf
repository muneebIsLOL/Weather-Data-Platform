data "aws_region" "current" {}

resource "aws_ecs_task_definition" "airflow" {
  family = "${var.project_name}-${var.environment}-airflow"

  container_definitions = <<TASK_DEFINITION
[
        {
            "name": "airflow-apiserver",
            "image": "${var.image}",
            "cpu": 0,
            "portMappings": [
                    {
                        "containerPort": 8080,
                        "hostPort": 8080,
                        "protocol": "tcp",
                        "name": "8080",
                        "appProtocol": "http"
                    }
                ],
            "essential": true,
            "command": [
                "api-server"
            ],
            "environment": [
                {
                    "name": "AIRFLOW__CORE__EXECUTION_API_SERVER_URL",
                    "value": "http://localhost:8080/execution/"
                },
                {
                    "name": "_AIRFLOW_WWW_USER_EMAIL",
                    "value": "admin@example.com"
                },
                {
                    "name": "AIRFLOW__CORE__LOAD_EXAMPLES",
                    "value": "false"
                },
                {
                    "name": "_AIRFLOW_WWW_USER_USERNAME",
                    "value": "admin"
                },
                {
                    "name": "_AIRFLOW_WWW_USER_ROLE",
                    "value": "Admin"
                },
                {
                    "name": "AIRFLOW__CORE__AUTH_MANAGER",
                    "value": "airflow.providers.fab.auth_manager.fab_auth_manager.FabAuthManager"
                },
                {
                    "name": "AIRFLOW__DATABASE__SQL_ALCHEMY_CONN",
                    "value": "${var.airflow_db_sqlalchemy_conn_string}?sslmode=verify-full&sslrootcert=%2Fopt%2Fairflow%2Fglobal-bundle.pem"
                },
                {
                    "name": "AIRFLOW__API_AUTH__JWT_ISSUER",
                    "value": "airflow"
                },
                {
                    "name": "AIRFLOW__API_AUTH__JWT_SECRET",
                    "value": "airflow_jwt_secret"
                },
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
                    "name": "AIRFLOW__SCHEDULER__ENABLE_HEALTH_CHECK",
                    "value": "true"
                },
                {
                    "name": "AIRFLOW_UID",
                    "value": "0"
                },
                {
                    "name": "AIRFLOW__CORE__FERNET_KEY",
                    "value": ""
                },
                {
                    "name": "AIRFLOW_CONN_AWS_DEFAULT",
                    "value": "aws://"
                },
                {
                    "name": "AIRFLOW_CONFIG",
                    "value": "/opt/airflow/config/airflow.cfg"
                },
                {
                    "name": "AIRFLOW__CELERY__BROKER_URL",
                    "value": "redis://:@localhost:6379/0"
                },
                {
                    "name": "AIRFLOW__CELERY__RESULT_BACKEND",
                    "value": "db+${var.airflow_db_sqlalchemy_conn_string}?sslmode=verify-full&sslrootcert=%2Fopt%2Fairflow%2Fglobal-bundle.pem"
                },
                {
                    "name": "AIRFLOW__CORE__EXECUTOR",
                    "value": "CeleryExecutor"
                },
                {
                    "name": "_AIRFLOW_WWW_USER_PASSWORD",
                    "value": "airflow"
                },
                {
                    "name": "AIRFLOW_REMOTE_LOGGING",
                    "value": "true"
                },
                {
                    "name": "AIRFLOW__REMOTE_BASE_LOG_FOLDER",
                    "value": "s3://${var.bucket_name}/airflow/logs"
                },
                {
                    "name": "AIRFLOW__REMOTE_BASE_LOG_FOLDER",
                    "value": "aws_conn"
                },
                {
                    "name": "AIRFLOW__ENCRYPT_S3_LOGS",
                    "value": "False"
                }
            ],
            "mountPoints": [],
            "volumesFrom": [],
            "dependsOn": [
                {
                    "containerName": "redis",
                    "condition": "HEALTHY"
                },
                {
                    "containerName": "airflow-init",
                    "condition": "COMPLETE"
                }
            ],
            "logConfiguration": {
                "logDriver": "awslogs",
                "options": {
                    "awslogs-group": "/ecs/${var.project_name}-${var.environment}-airflow",
                    "awslogs-create-group": "true",
                    "awslogs-region": "${data.aws_region.current.region}",
                    "awslogs-stream-prefix": "ecs"
                },
                "secretOptions": []
    {
        "name": "airflow-apiserver",
        "image": "${var.image}",
        "cpu": 0,
        "portMappings": [
                {
                    "containerPort": 8080,
                    "hostPort": 8080,
                    "protocol": "tcp",
                    "name": "8080",
                    "appProtocol": "http"
                }
            ],
        "essential": true,
        "command": [
            "api-server"
        ],
        "environment": [
            {
                "name": "AIRFLOW__CORE__EXECUTION_API_SERVER_URL",
                "value": "http://localhost:8080/execution/"
            },
            {
                "name": "_AIRFLOW_WWW_USER_EMAIL",
                "value": "admin@example.com"
            },
            {
                "name": "AIRFLOW__CORE__LOAD_EXAMPLES",
                "value": "false"
            },
            {
                "name": "_AIRFLOW_WWW_USER_USERNAME",
                "value": "admin"
            },
            {
                "name": "_AIRFLOW_WWW_USER_ROLE",
                "value": "Admin"
            },
            {
                "name": "AIRFLOW__CORE__AUTH_MANAGER",
                "value": "airflow.providers.fab.auth_manager.fab_auth_manager.FabAuthManager"
            },
            {
                "name": "AIRFLOW__DATABASE__SQL_ALCHEMY_CONN",
                "value": "${var.airflow_db_sqlalchemy_conn_string}?sslmode=verify-full&sslrootcert=%2Fopt%2Fairflow%2Fglobal-bundle.pem"
            },
            {
                "name": "AIRFLOW__API_AUTH__JWT_ISSUER",
                "value": "airflow"
            },
            {
                "name": "AIRFLOW__API_AUTH__JWT_SECRET",
                "value": "airflow_jwt_secret"
            },
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
                "name": "AIRFLOW__SCHEDULER__ENABLE_HEALTH_CHECK",
                "value": "true"
            },
            {
                "name": "AIRFLOW_UID",
                "value": "0"
            },
            {
                "name": "AIRFLOW__CORE__FERNET_KEY",
                "value": ""
            },
            {
                "name": "AIRFLOW_CONN_AWS_DEFAULT",
                "value": "aws://"
            },
            {
                "name": "AIRFLOW_CONFIG",
                "value": "/opt/airflow/config/airflow.cfg"
            },
            {
                "name": "AIRFLOW__CELERY__BROKER_URL",
                "value": "redis://:@localhost:6379/0"
            },
            {
                "name": "AIRFLOW__CELERY__RESULT_BACKEND",
                "value": "db+${var.airflow_db_sqlalchemy_conn_string}?sslmode=verify-full&sslrootcert=%2Fopt%2Fairflow%2Fglobal-bundle.pem"
            },
            {
                "name": "AIRFLOW__CORE__EXECUTOR",
                "value": "CeleryExecutor"
            },
            {
                "name": "_AIRFLOW_WWW_USER_PASSWORD",
                "value": "airflow"
            },
            {
                "name": "AIRFLOW_REMOTE_LOGGING",
                "value": "true"
            },
            {
                "name": "AIRFLOW__REMOTE_BASE_LOG_FOLDER",
                "value": "s3://${var.bucket_name}/airflow/logs"
            },
            {
                "name": "AIRFLOW__LOGGING__REMOTE_LOG_CONN_ID",
                "value": "aws_conn"
            },
            {
                "name": "AIRFLOW__ENCRYPT_S3_LOGS",
                "value": "False"
            }
        ],
        "mountPoints": [],
        "volumesFrom": [],
        "dependsOn": [
            {
                "containerName": "redis",
                "condition": "HEALTHY"
            },
            {
                "containerName": "airflow-init",
                "condition": "COMPLETE"
            }
        ],
        "logConfiguration": {
            "logDriver": "awslogs",
            "options": {
                "awslogs-group": "/ecs/${var.project_name}-${var.environment}-airflow",
                "awslogs-create-group": "true",
                "awslogs-region": "${data.aws_region.current.region}",
                "awslogs-stream-prefix": "ecs"
            },
            "secretOptions": []
        },
        {
            "name": "airflow-scheduler",
            "image": "${var.image}",
            "cpu": 0,
            "portMappings": [],
            "essential": true,
            "command": [
                "CMD-SHELL",
                "curl --fail http://localhost:8080/api/v2/monitor/health"
            ],
            "environment": [
                {
                    "name": "AIRFLOW__CORE__EXECUTION_API_SERVER_URL",
                    "value": "http://localhost:8080/execution/"
                },
                {
                    "name": "_AIRFLOW_WWW_USER_EMAIL",
                    "value": "admin@example.com"
                },
                {
                    "name": "AIRFLOW__CORE__LOAD_EXAMPLES",
                    "value": "false"
                },
                {
                    "name": "_AIRFLOW_WWW_USER_USERNAME",
                    "value": "muneebadmin"
                },
                {
                    "name": "_AIRFLOW_WWW_USER_ROLE",
                    "value": "Admin"
                },
                {
                    "name": "AIRFLOW__CORE__AUTH_MANAGER",
                    "value": "airflow.providers.fab.auth_manager.fab_auth_manager.FabAuthManager"
                },
                {
                    "name": "AIRFLOW__DATABASE__SQL_ALCHEMY_CONN",
                    "value": "${var.airflow_db_sqlalchemy_conn_string}?sslmode=verify-full&sslrootcert=%2Fopt%2Fairflow%2Fglobal-bundle.pem"
                },
                {
                    "name": "AIRFLOW__API_AUTH__JWT_ISSUER",
                    "value": "airflow"
                },
                {
                    "name": "AIRFLOW__API_AUTH__JWT_SECRET",
                    "value": "airflow_jwt_secret"
                },
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
                    "name": "AIRFLOW__SCHEDULER__ENABLE_HEALTH_CHECK",
                    "value": "true"
                },
                {
                    "name": "AIRFLOW_UID",
                    "value": "1000"
                },
                {
                    "name": "AIRFLOW__CORE__FERNET_KEY",
                    "value": ""
                },
                {
                    "name": "AIRFLOW_CONN_AWS_DEFAULT",
                    "value": "aws://"
                },
                {
                    "name": "AIRFLOW_CONFIG",
                    "value": "/opt/airflow/config/airflow.cfg"
                },
                {
                    "name": "AIRFLOW__CELERY__BROKER_URL",
                    "value": "redis://:@localhost:6379/0"
                },
                {
                    "name": "AIRFLOW__CELERY__RESULT_BACKEND",
                    "value": "db+${var.airflow_db_sqlalchemy_conn_string}?sslmode=verify-full&sslrootcert=%2Fopt%2Fairflow%2Fglobal-bundle.pem"
                },
                {
                    "name": "AIRFLOW__CORE__EXECUTOR",
                    "value": "CeleryExecutor"
                },
                {
                    "name": "_AIRFLOW_WWW_USER_PASSWORD",
                    "value": "airflow"
                },
                {
                    "name": "AIRFLOW_REMOTE_LOGGING",
                    "value": "true"
                },
                {
                    "name": "AIRFLOW__REMOTE_BASE_LOG_FOLDER",
                    "value": "s3://${var.bucket_name}/airflow/logs"
                },
                {
                    "name": "AIRFLOW__REMOTE_BASE_LOG_FOLDER",
                    "value": "aws_conn"
                },
                {
                    "name": "AIRFLOW__ENCRYPT_S3_LOGS",
                    "value": "False"
                }
            ],
            "mountPoints": [],
            "volumesFrom": [],
            "dependsOn": [
                {
                    "containerName": "redis",
                    "condition": "HEALTHY"
                },
                {
                    "containerName": "airflow-init",
                    "condition": "COMPLETE"
                }
            ],
            "logConfiguration": {
                "logDriver": "awslogs",
                "options": {
                    "awslogs-group": "/ecs/${var.project_name}-${var.environment}-airflow",
                    "awslogs-create-group": "true",
                    "awslogs-region": "${data.aws_region.current.region}",
                    "awslogs-stream-prefix": "ecs"
                },
                "secretOptions": []
            },
            "healthCheck": {
                "command": [
                    "CMD-SHELL",
                    "curl --fail http://localhost:8974/health"
                ],
                "interval": 30,
                "timeout": 10,
                "retries": 5,
                "startPeriod": 30
            },
            "systemControls": []
        },
        {
            "name": "airflow-worker",
            "image": "${var.image}",
            "cpu": 0,
            "portMappings": [],
            "essential": false,
            "command": [
                "celery",
                "worker"
            ],
            "environment": [
                {
                    "name": "AIRFLOW__CORE__EXECUTION_API_SERVER_URL",
                    "value": "http://localhost:8080/execution/"
                },
                {
                    "name": "_AIRFLOW_WWW_USER_EMAIL",
                    "value": "admin@example.com"
                },
                {
                    "name": "AIRFLOW__CORE__LOAD_EXAMPLES",
                    "value": "false"
                },
                {
                    "name": "_AIRFLOW_WWW_USER_USERNAME",
                    "value": "muneebadmin"
                },
                {
                    "name": "_AIRFLOW_WWW_USER_ROLE",
                    "value": "Admin"
                },
                {
                    "name": "AIRFLOW__CORE__AUTH_MANAGER",
                    "value": "airflow.providers.fab.auth_manager.fab_auth_manager.FabAuthManager"
                },
                {
                    "name": "AIRFLOW__DATABASE__SQL_ALCHEMY_CONN",
                    "value": "${var.airflow_db_sqlalchemy_conn_string}?sslmode=verify-full&sslrootcert=%2Fopt%2Fairflow%2Fglobal-bundle.pem"
                },
                {
                    "name": "AIRFLOW__API_AUTH__JWT_ISSUER",
                    "value": "airflow"
                },
                {
                    "name": "AIRFLOW__API_AUTH__JWT_SECRET",
                    "value": "airflow_jwt_secret"
                },
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
                    "name": "AIRFLOW__SCHEDULER__ENABLE_HEALTH_CHECK",
                    "value": "true"
                },
                {
                    "name": "AIRFLOW_UID",
                    "value": "1000"
                },
                {
                    "name": "AIRFLOW__CORE__FERNET_KEY",
                    "value": ""
                },
                {
                    "name": "AIRFLOW_CONN_AWS_DEFAULT",
                    "value": "aws://"
                },
                {
                    "name": "AIRFLOW_CONFIG",
                    "value": "/opt/airflow/config/airflow.cfg"
                },
                {
                    "name": "AIRFLOW__CELERY__BROKER_URL",
                    "value": "redis://:@localhost:6379/0"
                },
                {
                    "name": "AIRFLOW__CELERY__RESULT_BACKEND",
                    "value": "db+${var.airflow_db_sqlalchemy_conn_string}?sslmode=verify-full&sslrootcert=%2Fopt%2Fairflow%2Fglobal-bundle.pem"
                },
                {
                    "name": "AIRFLOW__CORE__EXECUTOR",
                    "value": "CeleryExecutor"
                },
                {
                    "name": "_AIRFLOW_WWW_USER_PASSWORD",
                    "value": "airflow"
                },
                {
                    "name": "AIRFLOW_REMOTE_LOGGING",
                    "value": "true"
                },
                {
                    "name": "AIRFLOW__REMOTE_BASE_LOG_FOLDER",
                    "value": "s3://${var.bucket_name}/airflow/logs"
                },
                {
                    "name": "AIRFLOW__REMOTE_BASE_LOG_FOLDER",
                    "value": "aws_conn"
                },
                {
                    "name": "AIRFLOW__ENCRYPT_S3_LOGS",
                    "value": "False"
                }
            ],
            "mountPoints": [],
            "volumesFrom": [],
            "dependsOn": [
                {
                    "containerName": "airflow-apiserver",
                    "condition": "HEALTHY"
                },
                {
                    "containerName": "redis",
                    "condition": "HEALTHY"
                },
                {
                    "containerName": "airflow-init",
                    "condition": "COMPLETE"
                }
            ],
            "logConfiguration": {
                "logDriver": "awslogs",
                "options": {
                    "awslogs-group": "/ecs/${var.project_name}-${var.environment}-airflow",
                    "awslogs-create-group": "true",
                    "awslogs-region": "${data.aws_region.current.region}",
                    "awslogs-stream-prefix": "ecs"
                },
                "secretOptions": []
            },
            "healthCheck": {
                "command": [
                    "CMD-SHELL",
                    'python -m celery --app airflow.providers.celery.executors.celery_executor.app inspect ping -d "celery@$${HOSTNAME}"'
                ],
                "interval": 30,
                "timeout": 10,
                "retries": 5,
                "startPeriod": 30
            },
            "systemControls": []
        },
        {
            "name": "airflow-triggerer",
            "image": "${var.image}",
            "cpu": 0,
            "portMappings": [],
            "essential": false,
            "command": [
                "triggerer"
            ],
            "environment": [
                {
                    "name": "AIRFLOW__CORE__EXECUTION_API_SERVER_URL",
                    "value": "http://localhost:8080/execution/"
                },
                {
                    "name": "_AIRFLOW_WWW_USER_EMAIL",
                    "value": "admin@example.com"
                },
                {
                    "name": "AIRFLOW__CORE__LOAD_EXAMPLES",
                    "value": "false"
                },
                {
                    "name": "_AIRFLOW_WWW_USER_USERNAME",
                    "value": "muneebadmin"
                },
                {
                    "name": "_AIRFLOW_WWW_USER_ROLE",
                    "value": "Admin"
                },
                {
                    "name": "AIRFLOW__CORE__AUTH_MANAGER",
                    "value": "airflow.providers.fab.auth_manager.fab_auth_manager.FabAuthManager"
                },
                {
                    "name": "AIRFLOW__DATABASE__SQL_ALCHEMY_CONN",
                    "value": "${var.airflow_db_sqlalchemy_conn_string}?sslmode=verify-full&sslrootcert=%2Fopt%2Fairflow%2Fglobal-bundle.pem"
                },
                {
                    "name": "AIRFLOW__API_AUTH__JWT_ISSUER",
                    "value": "airflow"
                },
                {
                    "name": "AIRFLOW__API_AUTH__JWT_SECRET",
                    "value": "airflow_jwt_secret"
                },
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
                    "name": "AIRFLOW__SCHEDULER__ENABLE_HEALTH_CHECK",
                    "value": "true"
                },
                {
                    "name": "AIRFLOW_UID",
                    "value": "1000"
                },
                {
                    "name": "AIRFLOW__CORE__FERNET_KEY",
                    "value": ""
                },
                {
                    "name": "AIRFLOW_CONN_AWS_DEFAULT",
                    "value": "aws://"
                },
                {
                    "name": "AIRFLOW_CONFIG",
                    "value": "/opt/airflow/config/airflow.cfg"
                },
                {
                    "name": "AIRFLOW__CELERY__BROKER_URL",
                    "value": "redis://:@localhost:6379/0"
                },
                {
                    "name": "AIRFLOW__CELERY__RESULT_BACKEND",
                    "value": "db+${var.airflow_db_sqlalchemy_conn_string}?sslmode=verify-full&sslrootcert=%2Fopt%2Fairflow%2Fglobal-bundle.pem"
                },
                {
                    "name": "AIRFLOW__CORE__EXECUTOR",
                    "value": "CeleryExecutor"
                },
                {
                    "name": "_AIRFLOW_WWW_USER_PASSWORD",
                    "value": "airflow"
                },
                {
                    "name": "AIRFLOW_REMOTE_LOGGING",
                    "value": "true"
                },
                {
                    "name": "AIRFLOW__REMOTE_BASE_LOG_FOLDER",
                    "value": "s3://${var.bucket_name}/airflow/logs"
                },
                {
                    "name": "AIRFLOW__REMOTE_BASE_LOG_FOLDER",
                    "value": "aws_conn"
                },
                {
                    "name": "AIRFLOW__ENCRYPT_S3_LOGS",
                    "value": "False"
                }
            ],
            "mountPoints": [],
            "volumesFrom": [],
            "dependsOn": [
                {
                    "containerName": "redis",
                    "condition": "HEALTHY"
                },
                {
                    "containerName": "airflow-init",
                    "condition": "COMPLETE"
                }
            ],
            "logConfiguration": {
                "logDriver": "awslogs",
                "options": {
                    "awslogs-group": "/ecs/${var.project_name}-${var.environment}-airflow",
                    "awslogs-create-group": "true",
                    "awslogs-region": "${data.aws_region.current.region}",
                    "awslogs-stream-prefix": "ecs"
                },
                "secretOptions": []
            },
            "healthCheck": {
                "command": [
                    "CMD-SHELL",
                    'python -m airflow jobs check --job-type TriggererJob --hostname "$${HOSTNAME}"'
                ],
                "interval": 30,
                "timeout": 10,
                "retries": 3
            },
            "systemControls": []
        },
        {
            "name": "redis",
            "image": "public.ecr.aws/docker/library/redis:7.2-alpine",
            "cpu": 0,
            "portMappings": [],
            "essential": false,
            "environment": [],
            "mountPoints": [],
            "volumesFrom": [],
            "logConfiguration": {
                "logDriver": "awslogs",
                "options": {
                    "awslogs-group": "/ecs/${var.project_name}-${var.environment}-airflow",
                    "awslogs-create-group": "true",
                    "awslogs-region": "${data.aws_region.current.region}",
                    "awslogs-stream-prefix": "ecs"
                },
                "secretOptions": []
            },
            "healthCheck": {
                "command": [
                    "CMD-SHELL",
                    "redis-cli ping"
                ],
                "interval": 10,
                "timeout": 30,
                "retries": 10,
                "startPeriod": 30
            },
            "systemControls": []
        },
        {
            "name": "airflow-dag-processor",
            "image": "${var.image}",
            "cpu": 0,
            "portMappings": [],
            "essential": false,
            "command": [
                "dag-processor"
            ],
            "environment": [
                {
                    "name": "AIRFLOW__CORE__EXECUTION_API_SERVER_URL",
                    "value": "http://localhost:8080/execution/"
                },
                {
                    "name": "_AIRFLOW_WWW_USER_EMAIL",
                    "value": "admin@example.com"
                },
                {
                    "name": "AIRFLOW__CORE__LOAD_EXAMPLES",
                    "value": "false"
                },
                {
                    "name": "_AIRFLOW_WWW_USER_USERNAME",
                    "value": "muneebadmin"
                },
                {
                    "name": "_AIRFLOW_WWW_USER_ROLE",
                    "value": "Admin"
                },
                {
                    "name": "AIRFLOW__CORE__AUTH_MANAGER",
                    "value": "airflow.providers.fab.auth_manager.fab_auth_manager.FabAuthManager"
                },
                {
                    "name": "AIRFLOW__DATABASE__SQL_ALCHEMY_CONN",
                    "value": "${var.airflow_db_sqlalchemy_conn_string}?sslmode=verify-full&sslrootcert=%2Fopt%2Fairflow%2Fglobal-bundle.pem"
                },
                {
                    "name": "AIRFLOW__API_AUTH__JWT_ISSUER",
                    "value": "airflow"
                },
                {
                    "name": "AIRFLOW__API_AUTH__JWT_SECRET",
                    "value": "airflow_jwt_secret"
                },
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
                    "name": "AIRFLOW__SCHEDULER__ENABLE_HEALTH_CHECK",
                    "value": "true"
                },
                {
                    "name": "AIRFLOW_UID",
                    "value": "1000"
                },
                {
                    "name": "AIRFLOW__CORE__FERNET_KEY",
                    "value": ""
                },
                {
                    "name": "AIRFLOW_CONN_AWS_DEFAULT",
                    "value": "aws://"
                },
                {
                    "name": "AIRFLOW_CONFIG",
                    "value": "/opt/airflow/config/airflow.cfg"
                },
                {
                    "name": "AIRFLOW__CELERY__BROKER_URL",
                    "value": "redis://:@localhost:6379/0"
                },
                {
                    "name": "AIRFLOW__CELERY__RESULT_BACKEND",
                    "value": "db+${var.airflow_db_sqlalchemy_conn_string}?sslmode=verify-full&sslrootcert=%2Fopt%2Fairflow%2Fglobal-bundle.pem"
                },
                {
                    "name": "AIRFLOW__CORE__EXECUTOR",
                    "value": "CeleryExecutor"
                },
                {
                    "name": "_AIRFLOW_WWW_USER_PASSWORD",
                    "value": "airflow"
                },
                {
                    "name": "AIRFLOW_REMOTE_LOGGING",
                    "value": "true"
                },
                {
                    "name": "AIRFLOW__REMOTE_BASE_LOG_FOLDER",
                    "value": "s3://${var.bucket_name}/airflow/logs"
                },
                {
                    "name": "AIRFLOW__REMOTE_BASE_LOG_FOLDER",
                    "value": "aws_conn"
                },
                {
                    "name": "AIRFLOW__ENCRYPT_S3_LOGS",
                    "value": "False"
                }
            ],
            "mountPoints": [],
            "volumesFrom": [],
            "dependsOn": [
                {
                    "containerName": "airflow-init",
                    "condition": "COMPLETE"
                },
                {
                    "containerName": "redis",
                    "condition": "HEALTHY"
                }
            ],
            "logConfiguration": {
                "logDriver": "awslogs",
                "options": {
                    "awslogs-group": "/ecs/${var.project_name}-${var.environment}-airflow",
                    "awslogs-create-group": "true",
                    "awslogs-region": "${data.aws_region.current.region}",
                    "awslogs-stream-prefix": "ecs"
                },
                "secretOptions": []
            },
            "healthCheck": {
                "command": [
                    "CMD-SHELL",
                    'python -m airflow jobs check --job-type DagProcessorJob --hostname "$${HOSTNAME}"'
                ],
                "interval": 10,
                "timeout": 30,
                "retries": 5,
                "startPeriod": 30
            },
            "systemControls": []
        },
        {
            "name": "airflow-init",
            "image": "${var.image}",
            "cpu": 0,
            "portMappings": [],
            "essential": false,
            "command": [
                "db",
                "migrate"
            ],
            "environment": [
                {
                    "name": "AIRFLOW__CORE__EXECUTION_API_SERVER_URL",
                    "value": "http://localhost:8080/execution/"
                },
                {
                    "name": "_AIRFLOW_WWW_USER_EMAIL",
                    "value": "admin@example.com"
                },
                {
                    "name": "AIRFLOW__CORE__LOAD_EXAMPLES",
                    "value": "false"
                },
                {
                    "name": "_AIRFLOW_WWW_USER_USERNAME",
                    "value": "muneebadmin"
                },
                {
                    "name": "_AIRFLOW_WWW_USER_ROLE",
                    "value": "Admin"
                },
                {
                    "name": "AIRFLOW__CORE__AUTH_MANAGER",
                    "value": "airflow.providers.fab.auth_manager.fab_auth_manager.FabAuthManager"
                },
                {
                    "name": "AIRFLOW__DATABASE__SQL_ALCHEMY_CONN",
                    "value": "${var.airflow_db_sqlalchemy_conn_string}?sslmode=verify-full&sslrootcert=%2Fopt%2Fairflow%2Fglobal-bundle.pem"
                },
                {
                    "name": "AIRFLOW__API_AUTH__JWT_ISSUER",
                    "value": "airflow"
                },
                {
                    "name": "AIRFLOW__API_AUTH__JWT_SECRET",
                    "value": "airflow_jwt_secret"
                },
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
                    "name": "AIRFLOW__SCHEDULER__ENABLE_HEALTH_CHECK",
                    "value": "true"
                },
                {
                    "name": "AIRFLOW_UID",
                    "value": "1000"
                },
                {
                    "name": "AIRFLOW__CORE__FERNET_KEY",
                    "value": ""
                },
                {
                    "name": "AIRFLOW_CONN_AWS_DEFAULT",
                    "value": "aws://"
                },
                {
                    "name": "AIRFLOW_CONFIG",
                    "value": "/opt/airflow/config/airflow.cfg"
                },
                {
                    "name": "AIRFLOW__CELERY__BROKER_URL",
                    "value": "redis://:@localhost:6379/0"
                },
                {
                    "name": "AIRFLOW__CELERY__RESULT_BACKEND",
                    "value":"db+${var.airflow_db_sqlalchemy_conn_string}?sslmode=verify-full&sslrootcert=%2Fopt%2Fairflow%2Fglobal-bundle.pem"
                },
                {
                    "name": "AIRFLOW__CORE__EXECUTOR",
                    "value": "CeleryExecutor"
                },
                {
                    "name": "_AIRFLOW_WWW_USER_PASSWORD",
                    "value": "airflow"
                },
                {
                    "name": "AIRFLOW_REMOTE_LOGGING",
                    "value": "true"
                },
                {
                    "name": "AIRFLOW__REMOTE_BASE_LOG_FOLDER",
                    "value": "s3://${var.bucket_name}/airflow/logs"
                },
                {
                    "name": "AIRFLOW__REMOTE_BASE_LOG_FOLDER",
                    "value": "aws_conn"
                },
                {
                    "name": "AIRFLOW__ENCRYPT_S3_LOGS",
                    "value": "False"
                }
            ],
            "mountPoints": [],
            "volumesFrom": [],
            "logConfiguration": {
                "logDriver": "awslogs",
                "options": {
                    "awslogs-group": "/ecs/${var.project_name}-${var.environment}-airflow",
                    "awslogs-create-group": "true",
                    "awslogs-region": "${data.aws_region.current.region}",
                    "awslogs-stream-prefix": "ecs"
                },
                "secretOptions": []
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
    "cpu": "2048",
    "memory": "16384",
    "runtimePlatform": {
        "cpuArchitecture": "X86_64",
        "operatingSystemFamily": "LINUX"
    },
    {
        "name": "airflow-scheduler",
        "image": "${var.image}",
        "cpu": 0,
        "portMappings": [],
        "essential": true,
        "command": [
            "scheduler"
        ],
        "environment": [
            {
                "name": "AIRFLOW__CORE__EXECUTION_API_SERVER_URL",
                "value": "http://localhost:8080/execution/"
            },
            {
                "name": "_AIRFLOW_WWW_USER_EMAIL",
                "value": "admin@example.com"
            },
            {
                "name": "AIRFLOW__CORE__LOAD_EXAMPLES",
                "value": "false"
            },
            {
                "name": "_AIRFLOW_WWW_USER_USERNAME",
                "value": "muneebadmin"
            },
            {
                "name": "_AIRFLOW_WWW_USER_ROLE",
                "value": "Admin"
            },
            {
                "name": "AIRFLOW__CORE__AUTH_MANAGER",
                "value": "airflow.providers.fab.auth_manager.fab_auth_manager.FabAuthManager"
            },
            {
                "name": "AIRFLOW__DATABASE__SQL_ALCHEMY_CONN",
                "value": "${var.airflow_db_sqlalchemy_conn_string}?sslmode=verify-full&sslrootcert=%2Fopt%2Fairflow%2Fglobal-bundle.pem"
            },
            {
                "name": "AIRFLOW__API_AUTH__JWT_ISSUER",
                "value": "airflow"
            },
            {
                "name": "AIRFLOW__API_AUTH__JWT_SECRET",
                "value": "airflow_jwt_secret"
            },
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
                "name": "AIRFLOW__SCHEDULER__ENABLE_HEALTH_CHECK",
                "value": "true"
            },
            {
                "name": "AIRFLOW_UID",
                "value": "0"
            },
            {
                "name": "AIRFLOW__CORE__FERNET_KEY",
                "value": ""
            },
            {
                "name": "AIRFLOW_CONN_AWS_DEFAULT",
                "value": "aws://"
            },
            {
                "name": "AIRFLOW_CONFIG",
                "value": "/opt/airflow/config/airflow.cfg"
            },
            {
                "name": "AIRFLOW__CELERY__BROKER_URL",
                "value": "redis://:@localhost:6379/0"
            },
            {
                "name": "AIRFLOW__CELERY__RESULT_BACKEND",
                "value": "db+${var.airflow_db_sqlalchemy_conn_string}?sslmode=verify-full&sslrootcert=%2Fopt%2Fairflow%2Fglobal-bundle.pem"
            },
            {
                "name": "AIRFLOW__CORE__EXECUTOR",
                "value": "CeleryExecutor"
            },
            {
                "name": "_AIRFLOW_WWW_USER_PASSWORD",
                "value": "airflow"
            },
            {
                "name": "AIRFLOW_REMOTE_LOGGING",
                "value": "true"
            },
            {
                "name": "AIRFLOW__REMOTE_BASE_LOG_FOLDER",
                "value": "s3://${var.bucket_name}/airflow/logs"
            },
            {
                "name": "AIRFLOW__LOGGING__REMOTE_LOG_CONN_ID",
                "value": "aws_conn"
            },
            {
                "name": "AIRFLOW__ENCRYPT_S3_LOGS",
                "value": "False"
            }
        ],
        "mountPoints": [],
        "volumesFrom": [],
        "dependsOn": [
            {
                "containerName": "redis",
                "condition": "HEALTHY"
            },
            {
                "containerName": "airflow-init",
                "condition": "COMPLETE"
            }
        ],
        "logConfiguration": {
            "logDriver": "awslogs",
            "options": {
                "awslogs-group": "/ecs/${var.project_name}-${var.environment}-airflow",
                "awslogs-create-group": "true",
                "awslogs-region": "${data.aws_region.current.region}",
                "awslogs-stream-prefix": "ecs"
            },
            "secretOptions": []
        },
        "healthCheck": {
            "command": [
                "CMD-SHELL",
                "curl --fail http://localhost:8974/health"
            ],
            "interval": 30,
            "timeout": 10,
            "retries": 5,
            "startPeriod": 30
        },
        "systemControls": []
    },
    {
        "name": "airflow-worker",
        "image": "${var.image}",
        "cpu": 0,
        "portMappings": [],
        "essential": false,
        "command": [
            "celery",
            "worker"
        ],
        "environment": [
            {
                "name": "AIRFLOW__CORE__EXECUTION_API_SERVER_URL",
                "value": "http://localhost:8080/execution/"
            },
            {
                "name": "_AIRFLOW_WWW_USER_EMAIL",
                "value": "admin@example.com"
            },
            {
                "name": "AIRFLOW__CORE__LOAD_EXAMPLES",
                "value": "false"
            },
            {
                "name": "_AIRFLOW_WWW_USER_USERNAME",
                "value": "muneebadmin"
            },
            {
                "name": "_AIRFLOW_WWW_USER_ROLE",
                "value": "Admin"
            },
            {
                "name": "AIRFLOW__CORE__AUTH_MANAGER",
                "value": "airflow.providers.fab.auth_manager.fab_auth_manager.FabAuthManager"
            },
            {
                "name": "AIRFLOW__DATABASE__SQL_ALCHEMY_CONN",
                "value": "${var.airflow_db_sqlalchemy_conn_string}?sslmode=verify-full&sslrootcert=%2Fopt%2Fairflow%2Fglobal-bundle.pem"
            },
            {
                "name": "AIRFLOW__API_AUTH__JWT_ISSUER",
                "value": "airflow"
            },
            {
                "name": "AIRFLOW__API_AUTH__JWT_SECRET",
                "value": "airflow_jwt_secret"
            },
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
                "name": "AIRFLOW__SCHEDULER__ENABLE_HEALTH_CHECK",
                "value": "true"
            },
            {
                "name": "AIRFLOW_UID",
                "value": "0"
            },
            {
                "name": "AIRFLOW__CORE__FERNET_KEY",
                "value": ""
            },
            {
                "name": "AIRFLOW_CONN_AWS_DEFAULT",
                "value": "aws://"
            },
            {
                "name": "AIRFLOW_CONFIG",
                "value": "/opt/airflow/config/airflow.cfg"
            },
            {
                "name": "AIRFLOW__CELERY__BROKER_URL",
                "value": "redis://:@localhost:6379/0"
            },
            {
                "name": "AIRFLOW__CELERY__RESULT_BACKEND",
                "value": "db+${var.airflow_db_sqlalchemy_conn_string}?sslmode=verify-full&sslrootcert=%2Fopt%2Fairflow%2Fglobal-bundle.pem"
            },
            {
                "name": "AIRFLOW__CORE__EXECUTOR",
                "value": "CeleryExecutor"
            },
            {
                "name": "_AIRFLOW_WWW_USER_PASSWORD",
                "value": "airflow"
            },
            {
                "name": "AIRFLOW_REMOTE_LOGGING",
                "value": "true"
            },
            {
                "name": "AIRFLOW__REMOTE_BASE_LOG_FOLDER",
                "value": "s3://${var.bucket_name}/airflow/logs"
            },
            {
                "name": "AIRFLOW__LOGGING__REMOTE_LOG_CONN_ID",
                "value": "aws_conn"
            },
            {
                "name": "AIRFLOW__ENCRYPT_S3_LOGS",
                "value": "False"
            }
        ],
        "mountPoints": [],
        "volumesFrom": [],
        "dependsOn": [
            {
                "containerName": "airflow-apiserver",
                "condition": "HEALTHY"
            },
            {
                "containerName": "redis",
                "condition": "HEALTHY"
            },
            {
                "containerName": "airflow-init",
                "condition": "COMPLETE"
            }
        ],
        "logConfiguration": {
            "logDriver": "awslogs",
            "options": {
                "awslogs-group": "/ecs/${var.project_name}-${var.environment}-airflow",
                "awslogs-create-group": "true",
                "awslogs-region": "${data.aws_region.current.region}",
                "awslogs-stream-prefix": "ecs"
            },
            "secretOptions": []
        },
        "healthCheck": {
            "command": [
                "CMD-SHELL",
                "python -m celery --app airflow.providers.celery.executors.celery_executor.app inspect ping -d 'celery@$${HOSTNAME}'"
            ],
            "interval": 30,
            "timeout": 10,
            "retries": 5,
            "startPeriod": 30
        },
        "systemControls": []
    },
    {
        "name": "airflow-triggerer",
        "image": "${var.image}",
        "cpu": 0,
        "portMappings": [],
        "essential": false,
        "command": [
            "triggerer"
        ],
        "environment": [
            {
                "name": "AIRFLOW__CORE__EXECUTION_API_SERVER_URL",
                "value": "http://localhost:8080/execution/"
            },
            {
                "name": "_AIRFLOW_WWW_USER_EMAIL",
                "value": "admin@example.com"
            },
            {
                "name": "AIRFLOW__CORE__LOAD_EXAMPLES",
                "value": "false"
            },
            {
                "name": "_AIRFLOW_WWW_USER_USERNAME",
                "value": "muneebadmin"
            },
            {
                "name": "_AIRFLOW_WWW_USER_ROLE",
                "value": "Admin"
            },
            {
                "name": "AIRFLOW__CORE__AUTH_MANAGER",
                "value": "airflow.providers.fab.auth_manager.fab_auth_manager.FabAuthManager"
            },
            {
                "name": "AIRFLOW__DATABASE__SQL_ALCHEMY_CONN",
                "value": "${var.airflow_db_sqlalchemy_conn_string}?sslmode=verify-full&sslrootcert=%2Fopt%2Fairflow%2Fglobal-bundle.pem"
            },
            {
                "name": "AIRFLOW__API_AUTH__JWT_ISSUER",
                "value": "airflow"
            },
            {
                "name": "AIRFLOW__API_AUTH__JWT_SECRET",
                "value": "airflow_jwt_secret"
            },
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
                "name": "AIRFLOW__SCHEDULER__ENABLE_HEALTH_CHECK",
                "value": "true"
            },
            {
                "name": "AIRFLOW_UID",
                "value": "0"
            },
            {
                "name": "AIRFLOW__CORE__FERNET_KEY",
                "value": ""
            },
            {
                "name": "AIRFLOW_CONN_AWS_DEFAULT",
                "value": "aws://"
            },
            {
                "name": "AIRFLOW_CONFIG",
                "value": "/opt/airflow/config/airflow.cfg"
            },
            {
                "name": "AIRFLOW__CELERY__BROKER_URL",
                "value": "redis://:@localhost:6379/0"
            },
            {
                "name": "AIRFLOW__CELERY__RESULT_BACKEND",
                "value": "db+${var.airflow_db_sqlalchemy_conn_string}?sslmode=verify-full&sslrootcert=%2Fopt%2Fairflow%2Fglobal-bundle.pem"
            },
            {
                "name": "AIRFLOW__CORE__EXECUTOR",
                "value": "CeleryExecutor"
            },
            {
                "name": "_AIRFLOW_WWW_USER_PASSWORD",
                "value": "airflow"
            },
            {
                "name": "AIRFLOW_REMOTE_LOGGING",
                "value": "true"
            },
            {
                "name": "AIRFLOW__REMOTE_BASE_LOG_FOLDER",
                "value": "s3://${var.bucket_name}/airflow/logs"
            },
            {
                "name": "AIRFLOW__LOGGING__REMOTE_LOG_CONN_ID",
                "value": "aws_conn"
            },
            {
                "name": "AIRFLOW__ENCRYPT_S3_LOGS",
                "value": "False"
            }
        ],
        "mountPoints": [],
        "volumesFrom": [],
        "dependsOn": [
            {
                "containerName": "redis",
                "condition": "HEALTHY"
            },
            {
                "containerName": "airflow-init",
                "condition": "COMPLETE"
            }
        ],
        "logConfiguration": {
            "logDriver": "awslogs",
            "options": {
                "awslogs-group": "/ecs/${var.project_name}-${var.environment}-airflow",
                "awslogs-create-group": "true",
                "awslogs-region": "${data.aws_region.current.region}",
                "awslogs-stream-prefix": "ecs"
            },
            "secretOptions": []
        },
        "healthCheck": {
            "command": [
                "CMD-SHELL",
                "python -m airflow jobs check --job-type TriggererJob --hostname '$${HOSTNAME}'"
            ],
            "interval": 30,
            "timeout": 10,
            "retries": 3
        },
        "systemControls": []
    },
    {
        "name": "redis",
        "image": "public.ecr.aws/docker/library/redis:7.2-alpine",
        "cpu": 0,
        "portMappings": [],
        "essential": false,
        "environment": [],
        "mountPoints": [],
        "volumesFrom": [],
        "logConfiguration": {
            "logDriver": "awslogs",
            "options": {
                "awslogs-group": "/ecs/${var.project_name}-${var.environment}-airflow",
                "awslogs-create-group": "true",
                "awslogs-region": "${data.aws_region.current.region}",
                "awslogs-stream-prefix": "ecs"
            },
            "secretOptions": []
        },
        "healthCheck": {
            "command": [
                "CMD-SHELL",
                "redis-cli ping"
            ],
            "interval": 10,
            "timeout": 30,
            "retries": 10,
            "startPeriod": 30
        },
        "systemControls": []
    },
    {
        "name": "airflow-dag-processor",
        "image": "${var.image}",
        "cpu": 0,
        "portMappings": [],
        "essential": false,
        "command": [
            "dag-processor"
        ],
        "environment": [
            {
                "name": "AIRFLOW__CORE__EXECUTION_API_SERVER_URL",
                "value": "http://localhost:8080/execution/"
            },
            {
                "name": "_AIRFLOW_WWW_USER_EMAIL",
                "value": "admin@example.com"
            },
            {
                "name": "AIRFLOW__CORE__LOAD_EXAMPLES",
                "value": "false"
            },
            {
                "name": "_AIRFLOW_WWW_USER_USERNAME",
                "value": "muneebadmin"
            },
            {
                "name": "_AIRFLOW_WWW_USER_ROLE",
                "value": "Admin"
            },
            {
                "name": "AIRFLOW__CORE__AUTH_MANAGER",
                "value": "airflow.providers.fab.auth_manager.fab_auth_manager.FabAuthManager"
            },
            {
                "name": "AIRFLOW__DATABASE__SQL_ALCHEMY_CONN",
                "value": "${var.airflow_db_sqlalchemy_conn_string}?sslmode=verify-full&sslrootcert=%2Fopt%2Fairflow%2Fglobal-bundle.pem"
            },
            {
                "name": "AIRFLOW__API_AUTH__JWT_ISSUER",
                "value": "airflow"
            },
            {
                "name": "AIRFLOW__API_AUTH__JWT_SECRET",
                "value": "airflow_jwt_secret"
            },
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
                "name": "AIRFLOW__SCHEDULER__ENABLE_HEALTH_CHECK",
                "value": "true"
            },
            {
                "name": "AIRFLOW_UID",
                "value": "0"
            },
            {
                "name": "AIRFLOW__CORE__FERNET_KEY",
                "value": ""
            },
            {
                "name": "AIRFLOW_CONN_AWS_DEFAULT",
                "value": "aws://"
            },
            {
                "name": "AIRFLOW_CONFIG",
                "value": "/opt/airflow/config/airflow.cfg"
            },
            {
                "name": "AIRFLOW__CELERY__BROKER_URL",
                "value": "redis://:@localhost:6379/0"
            },
            {
                "name": "AIRFLOW__CELERY__RESULT_BACKEND",
                "value": "db+${var.airflow_db_sqlalchemy_conn_string}?sslmode=verify-full&sslrootcert=%2Fopt%2Fairflow%2Fglobal-bundle.pem"
            },
            {
                "name": "AIRFLOW__CORE__EXECUTOR",
                "value": "CeleryExecutor"
            },
            {
                "name": "_AIRFLOW_WWW_USER_PASSWORD",
                "value": "airflow"
            },
            {
                "name": "AIRFLOW_REMOTE_LOGGING",
                "value": "true"
            },
            {
                "name": "AIRFLOW__REMOTE_BASE_LOG_FOLDER",
                "value": "s3://${var.bucket_name}/airflow/logs"
            },
            {
                "name": "AIRFLOW__LOGGING__REMOTE_LOG_CONN_ID",
                "value": "aws_conn"
            },
            {
                "name": "AIRFLOW__ENCRYPT_S3_LOGS",
                "value": "False"
            }
        ],
        "mountPoints": [],
        "volumesFrom": [],
        "dependsOn": [
            {
                "containerName": "airflow-init",
                "condition": "COMPLETE"
            },
            {
                "containerName": "redis",
                "condition": "HEALTHY"
            }
        ],
        "logConfiguration": {
            "logDriver": "awslogs",
            "options": {
                "awslogs-group": "/ecs/${var.project_name}-${var.environment}-airflow",
                "awslogs-create-group": "true",
                "awslogs-region": "${data.aws_region.current.region}",
                "awslogs-stream-prefix": "ecs"
            },
            "secretOptions": []
        },
        "healthCheck": {
            "command": [
                "CMD-SHELL",
                "python -m airflow jobs check --job-type DagProcessorJob --hostname '$${HOSTNAME}'"
            ],
            "interval": 10,
            "timeout": 30,
            "retries": 5,
            "startPeriod": 30
        },
        "systemControls": []
    },
    {
        "name": "airflow-init",
        "image": "${var.image}",
        "cpu": 0,
        "portMappings": [],
        "essential": false,
        "command": [
            "db",
            "migrate"
        ],
        "environment": [
            {
                "name": "AIRFLOW__CORE__EXECUTION_API_SERVER_URL",
                "value": "http://localhost:8080/execution/"
            },
            {
                "name": "_AIRFLOW_WWW_USER_EMAIL",
                "value": "admin@example.com"
            },
            {
                "name": "AIRFLOW__CORE__LOAD_EXAMPLES",
                "value": "false"
            },
            {
                "name": "_AIRFLOW_WWW_USER_USERNAME",
                "value": "muneebadmin"
            },
            {
                "name": "_AIRFLOW_WWW_USER_ROLE",
                "value": "Admin"
            },
            {
                "name": "AIRFLOW__CORE__AUTH_MANAGER",
                "value": "airflow.providers.fab.auth_manager.fab_auth_manager.FabAuthManager"
            },
            {
                "name": "AIRFLOW__DATABASE__SQL_ALCHEMY_CONN",
                "value": "${var.airflow_db_sqlalchemy_conn_string}?sslmode=verify-full&sslrootcert=%2Fopt%2Fairflow%2Fglobal-bundle.pem"
            },
            {
                "name": "AIRFLOW__API_AUTH__JWT_ISSUER",
                "value": "airflow"
            },
            {
                "name": "AIRFLOW__API_AUTH__JWT_SECRET",
                "value": "airflow_jwt_secret"
            },
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
                "name": "AIRFLOW__SCHEDULER__ENABLE_HEALTH_CHECK",
                "value": "true"
            },
            {
                "name": "AIRFLOW_UID",
                "value": "0"
            },
            {
                "name": "AIRFLOW__CORE__FERNET_KEY",
                "value": ""
            },
            {
                "name": "AIRFLOW_CONN_AWS_DEFAULT",
                "value": "aws://"
            },
            {
                "name": "AIRFLOW_CONFIG",
                "value": "/opt/airflow/config/airflow.cfg"
            },
            {
                "name": "AIRFLOW__CELERY__BROKER_URL",
                "value": "redis://:@localhost:6379/0"
            },
            {
                "name": "AIRFLOW__CELERY__RESULT_BACKEND",
                "value":"db+${var.airflow_db_sqlalchemy_conn_string}?sslmode=verify-full&sslrootcert=%2Fopt%2Fairflow%2Fglobal-bundle.pem"
            },
            {
                "name": "AIRFLOW__CORE__EXECUTOR",
                "value": "CeleryExecutor"
            },
            {
                "name": "_AIRFLOW_WWW_USER_PASSWORD",
                "value": "airflow"
            },
            {
                "name": "AIRFLOW_REMOTE_LOGGING",
                "value": "true"
            },
            {
                "name": "AIRFLOW__REMOTE_BASE_LOG_FOLDER",
                "value": "s3://${var.bucket_name}/airflow/logs"
            },
            {
                "name": "AIRFLOW__LOGGING__REMOTE_LOG_CONN_ID",
                "value": "aws_conn"
            },
            {
                "name": "AIRFLOW__ENCRYPT_S3_LOGS",
                "value": "False"
            }
        ],
        "mountPoints": [],
        "volumesFrom": [],
        "logConfiguration": {
            "logDriver": "awslogs",
            "options": {
                "awslogs-group": "/ecs/${var.project_name}-${var.environment}-airflow",
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
  cpu                = 2048
  memory             = 16384
  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }
  enable_fault_injection = false
}
