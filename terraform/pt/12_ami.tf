resource "aws_ami_from_instance" "web_ami" {
  name               = "web-image"
  source_instance_id = aws_instance.web[0].id
  depends_on         = [aws_db_instance.database]
}
