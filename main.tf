/*AWS elastic
terrform file for configur environment
for work with poject "web2"
Autor:bogdan
*/


//provider
provider "aws"{
  access_key = var.aws_key.access
  secret_key = var.aws_key.secret
  region     = "us-east-2"
}
//set up database
resource "aws_db_instance" "dbtfweb2" {
  identifier             = "dbtfweb2"
  instance_class         = "db.t2.micro"
  allocated_storage      = 5
  engine                 = "mysql"
  engine_version         = "8.0"
  db_name                = var.data_base.base
  username               = var.data_base.user
  password               = var.data_base.password
  publicly_accessible    = true
  skip_final_snapshot    = true
//upload data to db
  provisioner "local-exec" {
    command = "echo 'mysql --host=${aws_db_instance.tfweb2.address} --port=3306 --user=${var.data_base.user} --password=${var.data_base.password} --database=${var.data_base.base} < web2.sql' > set_d>
  }
  provisioner "local-exec" {
    command = "sudo bash set_db.sh"
  }
  provisioner "local-exec" {
    command = "rm -r set_db.sh"
  }
}

//setup application
resource "aws_elastic_beanstalk_application" "web2tf"{
  name        = "web2tf"
  description = "web2-project for study Teraform with AWS"
}

//setup environment
resource "aws_elastic_beanstalk_environment""web2tfenv"{
  name                = "web2tfenv"
  application         = "${aws_elastic_beanstalk_application.web2tf.name}"
  solution_stack_name = "64bit Amazon Linux 2 v3.3.10 running PHP 7.4"
  cname_prefix        = "web2"

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "EnvironmentType"
    value     = "SingleInstance"
  }
  setting {
    namespace = "aws:elasticbeanstalk:environment:proxy"
    name      = "ProxyServer"
    value     = "apache"
  }

//set ssh-key for connection
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "EC2KeyName"
    value     = "bogdan2"
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = "aws-elasticbeanstalk-ec2-role"
  }
//setup credentials for database
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "DB_HOST"
    value     = aws_db_instance.tfweb2.address
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "DB_DATABASE"
    value     = var.data_base.base
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "DB_USER"
    value     = var.data_base.user
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "DB_PASSWORD"
    value     = var.data_base.password
  }
}

/** deploy start app from git_url
  setting{
  namespace = "aws:cloudformation:template:parameter"
  name      = "AppSource"
  value     = var.app_source
}*/
