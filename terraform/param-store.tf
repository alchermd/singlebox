resource "aws_ssm_parameter" "secret_key" {
  name        = "/singlebox/SECRET_KEY"
  description = "Secret key for the application"
  type        = "SecureString"
  value       = var.secret_key
}

resource "aws_ssm_parameter" "debug" {
  name        = "/singlebox/DEBUG"
  description = "Debug mode"
  type        = "String"
  value       = var.app_debug
}

resource "aws_ssm_parameter" "allowed_hosts" {
  name        = "/singlebox/ALLOWED_HOSTS"
  description = "Allowed hosts for the application"
  type        = "String"
  value       = "*.${var.route53_zone_name} ${var.domain_name} *.${var.domain_name}"
}

resource "aws_ssm_parameter" "db_database" {
  name        = "/singlebox/DB_DATABASE"
  description = "Database name"
  type        = "String"
  value       = var.db_database
}

resource "aws_ssm_parameter" "db_user" {
  name        = "/singlebox/DB_USER"
  description = "Database user"
  type        = "String"
  value       = var.db_user
}

resource "aws_ssm_parameter" "db_password" {
  name        = "/singlebox/DB_PASSWORD"
  description = "Database password"
  type        = "SecureString"
  value       = var.db_password
}

resource "aws_ssm_parameter" "db_host" {
  name        = "/singlebox/DB_HOST"
  description = "Database host"
  type        = "String"
  value       = var.db_host
}

resource "aws_ssm_parameter" "db_port" {
  name        = "/singlebox/DB_PORT"
  description = "Database port"
  type        = "String"
  value       = var.db_port
}

resource "aws_ssm_parameter" "site" {
  name        = "/singlebox/SITE"
  description = "Application site"
  type        = "String"
  value       = var.domain_name
}
