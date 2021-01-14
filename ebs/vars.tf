variable "RDS_PASSWORD" {
  default = "easypassword123" # change it or supply while doing terraform apply
}

variable "PATH_TO_PUBLIC_KEY" {
  default = "keys/dkey.pub"
} 
