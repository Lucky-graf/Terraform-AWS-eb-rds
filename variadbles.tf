variable "aws_key" {
  type = map(string)
  sensitive = true
  default = {
    access = ""
    secret = ""
  }
}

variable "data_base" {
  type = map(string)
  sensitive = true
  default = {
    host      = "tf-database-1.cwyboycueldk.us-east-2.rds.amazonaws.com"
    base      = "web2"
    user      = "myuser"
    password  = "mypassword"
  }
}

/**deploy start app from git_url
variable "app_source" {
  type    = string
  default = "https://github.com/Lucky-graf/web2/archive/refs/tags/default.zip"
}*/
