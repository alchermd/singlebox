resource "aws_ssm_parameter" "secret_key" {
  name        = "/singlebox/SECRET_KEY"
  description = "Secret key for the application"
  type        = "SecureString"
  value       = "dev-key"
}

resource "aws_ssm_parameter" "debug" {
  name        = "/singlebox/DEBUG"
  description = "Debug mode"
  type        = "String"
  value       = "1"
}

resource "aws_ssm_parameter" "allowed_hosts" {
  name        = "/singlebox/ALLOWED_HOSTS"
  description = "Allowed hosts for the application"
  type        = "String"
  value       = "* localhost 127.0.0.1 [::1]"
}

resource "aws_ssm_parameter" "db_database" {
  name        = "/singlebox/DB_DATABASE"
  description = "Database name"
  type        = "String"
  value       = "singlebox"
}

resource "aws_ssm_parameter" "db_user" {
  name        = "/singlebox/DB_USER"
  description = "Database user"
  type        = "String"
  value       = "singlebox_user"
}

resource "aws_ssm_parameter" "db_password" {
  name        = "/singlebox/DB_PASSWORD"
  description = "Database password"
  type        = "SecureString"
  value       = "singlebox_password"
}

resource "aws_ssm_parameter" "db_host" {
  name        = "/singlebox/DB_HOST"
  description = "Database host"
  type        = "String"
  value       = "db"
}

resource "aws_ssm_parameter" "db_port" {
  name        = "/singlebox/DB_PORT"
  description = "Database port"
  type        = "String"
  value       = "5432"
}
