
variable "domainName" {
  type = string
  description = "Domain will public"
}

variable "rootDomain" {
  type = string
  description = "Root domain"
}

variable "acmCertificateArn" {
  type = string
  description = "acm_certificate_arn"
}
