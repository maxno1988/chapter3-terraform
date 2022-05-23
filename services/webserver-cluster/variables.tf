variable "cluster_name" {
  description = "The name to use for all the cluster resources"
  type        = string
}

variable "rm_state_bt_name" {
  description = "The name to S3 bucket"
  type        = string
}


variable "db_rm_state_bt_key" {
  description = "The path for the database's remote state in S3"
  type        = string
}

variable "web_port" {
  description = "Web Server Port"
  default     = 80
}
variable "ssh_port" {
  description = "SSH Access port"
  default     = 22
}
variable "eu-main-vpc-id" {
  description = "MAIN VPC of eu-central-1 region"
  default     = "vpc-0c4b202d96e7494b7"
}
