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
