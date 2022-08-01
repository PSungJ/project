#AutoScaling 시작 구성
resource "aws_launch_configuration" "as_conf" {
  name                 = format("%s-as_conf", var.name)
  image_id             = aws_ami_from_instance.web_ami.id
  instance_type        = var.asgc.instance_type
  iam_instance_profile = aws_iam_instance_profile.profile_as.name
  security_groups      = [aws_security_group.sg_web.id]
  key_name             = var.key.name
  user_data            = <<EOF
    #!/bin/bash
    systemctl start httpd
    systmectl restart httpd
    systemctl enable httpd
  EOF
}

// AutoScaling Launch IAM
resource "aws_iam_instance_profile" "profile_as" {
  name = format("%s-profile-as", var.name)
  role = aws_iam_role.role_as.name
}

resource "aws_iam_role" "role_as" {
  name = format("%s-role-autoscaling", var.name)
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "policy_as" {
  name = format("%s-policy-as", var.name)
  role = aws_iam_role.role_as.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ec2:AttachVolume",
                "ec2:DetachVolume"
            ],
            "Resource": [
                "arn:aws:ec2:*:*:volume/*",
                "arn:aws:ec2:*:*:instance/*"
            ]
        }
    ]
}
EOF
}
