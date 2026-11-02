variable "subscription_id" {
  type        = string
  description = "Azure subscription ID."
}
variable "location" {
  type    = string
  default = "centralindia"
}
variable "prefix" {
  type    = string
  default = "kssec"
}
