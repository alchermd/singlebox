variable "instance_type" {
  type        = string
  description = "EC2 instance type to be used. Example: t3.micro"
}

variable "domain_name" {
  type        = string
  description = "The domain name used. Must be a sub-domain of an existing Route53 hosted zone. (Example: singlebox.example.com)"
}

variable "route53_zone_name" {
  type        = string
  description = "Name to be used for an existing Route53 zone. (Example: example.com)"
}

variable "route53_a_record" {
  type        = string
  description = "The subdomain to use relative to the apex of the Route53 zone. (Example: singlebox)"
}

variable "route53_zone_id" {
  type        = string
  description = "The zone ID of the existing Route53 hosted zone."
}

variable "secret_key" {
  type        = string
  description = "The application's secret key, use for cryptographic purposes."
}

variable "app_debug" {
  type        = string
  description = "Whether the application launches in debug mode."
}

variable "db_database" {
  type        = string
  description = "Database name"
}

variable "db_user" {
  type        = string
  description = "Database user"
}

variable "db_password" {
  type        = string
  description = "Database password"
}


variable "db_host" {
  type        = string
  description = "Database host"
}


variable "db_port" {
  type        = string
  description = "Database port"
}
