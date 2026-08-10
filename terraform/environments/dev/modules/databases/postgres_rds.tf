resource "aws_db_subnet_group" "this" {
  name       = "weather-db-subnet-group"
  subnet_ids = var.subnet_ids
}

resource "aws_db_instance" "weather" {
  identifier             = "${var.project_name}-${var.environment}-weather-instance"
  engine                 = "postgres"
  engine_version         = "18.4"
  allocated_storage      = 20
  storage_type           = "gp3"
  db_name                = "${var.project_name}_${var.environment}_weather_db"
  username               = "postgres"
  password               = "MySecurePassword123!"
  instance_class         = "db.t3.micro"
  db_subnet_group_name   = aws_db_subnet_group.this.name
  publicly_accessible    = false
  skip_final_snapshot    = true
  deletion_protection    = false
  storage_encrypted      = true
  vpc_security_group_ids = var.sg_ids
}

resource "aws_db_instance" "airflow" {
  identifier             = "${var.project_name}-${var.environment}-airflow-instance"
  engine                 = "postgres"
  engine_version         = "18.4"
  allocated_storage      = 20
  storage_type           = "gp3"
  db_name                = "${var.project_name}_${var.environment}_airflow_db"
  username               = "postgres"
  password               = "MySecurePassword123!"
  instance_class         = "db.t3.micro"
  db_subnet_group_name   = aws_db_subnet_group.this.name
  publicly_accessible    = false
  skip_final_snapshot    = true
  deletion_protection    = false
  storage_encrypted      = true
  vpc_security_group_ids = var.sg_ids
}
