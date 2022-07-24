resource "aws_instance" "ansible" {
    ami = var.ansible.ami
    instance_type = var.ansible.instance_type
    key_name = var.key.name
    vpc_security_group_ids = [aws_security_group.sg_ansible.id]
    subnet_id = aws_subnet.web_sub[0].id
    private_ip = "10.1.10.4"
    iam_instance_profile = aws_iam_instance_profile.profile_ansible.name
    depends_on = [aws_route_table_association.ngwrt_web_ass]
    user_data = <<EOF
#!/bin/bash
sudo su -
echo '${var.key.private}' > /root/.ssh/id_rsa
chmod 600 /root/.ssh/id_rsa
sed -i "s/#Port 22/Port ${var.sg_ansible.from_port}/g" /etc/ssh/sshd_config
systemctl restart sshd
yum install -y python-boto3
yum install -y git
git clone '${var.ansible.github}' /etc/ansible/
amazon-linux-extras enable ansible2
amazon-linux-extras install -y ansible2
ansible-playbook /etc/ansible/web.yaml -u ec2-user
ansible-playbook /etc/ansible/dbphp.yaml -u ec2-user
EOF

    tags = {
        Name = "ansible"
    }
    root_block_device {
        volume_size = 30
    }
    credit_specification{
        cpu_credits = "unlimited"
    }
}

resource "aws_iam_instance_profile" "profile_ansible" {
  name = "${format("%s-profile-ansible", var.name)}"
  role = aws_iam_role.role_ansible.name
}

resource "aws_iam_role" "role_ansible" {
  name = "${format("%s-role-ansible", var.name)}"
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

resource "aws_iam_role_policy" "policy_ansible" {
  name = "${format("%s-policy-ansible", var.name)}"
  role = aws_iam_role.role_ansible.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "*",
            "Resource": "*"
        }
    ]
}
EOF
}
