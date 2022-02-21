data "aws_db_instance" "database" {
  depends_on = [aws_db_instance.dbtfweb2]
  db_instance_identifier = "dbtfweb2"
}


  data "local_file" "sql_script" {
  filename = "./web2.sql"
}


resource "null_resource" "db_setup" {
  depends_on = [aws_elastic_beanstalk_environment.web2tfenv, aws_db_instance.dbtfweb2, data.aws_db_instance.database]
  provisioner "local-exec" {
      command = "sleep 25s"
      }
  provisioner "local-exec" {
    command = "mysql --host=${data.aws_db_instance.database.address} --port=3306 --user=${var.data_base.user} --password=${var.data_base.password} --database=${var.data_base.base} < ${data.local_file.sql_script.content}"
        }
}
