resource "aws_key_pair" "key" {
  key_name   = var.key.name
  public_key = var.key.public
}

/* resource "aws_key_pair" "hjko_key" {
    key_name = "hjko-key"
    public_key = "ssh-rsa "  
} */