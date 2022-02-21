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
    host      = ${data.aws_db_instance.database.address}
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
