variable "cert" {
  description = "Path to digital certificate file."
}

variable "key" {
  description = "Path to digital certificate key file."
}

variable "ca" {
  description = "Path to digital ca certificate file."
}

variable "server_certificate_arn" {
  description = "Digital ca certificate arn."
}

variable "root_certificate_chain_arn" {
  description = "Digital ca certificate arn."
}

variable "key_name" {}

variable "stack_name" {}

variable "ami_name" {
  default = "ami-095192256fe1477ad"
}
