// Bastion 보안 그룹
resource "aws_security_group" "sg_bastion" {
    name = "${format("%s-sg-bastion", var.name)}"
    description = "security group for bastion"
    vpc_id = aws_vpc.vpc.id

    ingress = [
        {
            description = var.sg_bastion.description
            from_port = var.sg_bastion.from_port
            to_port = var.sg_bastion.to_port
            protocol = var.sg_bastion.protocol
            cidr_blocks = var.sg_bastion.cidr_blocks
            ipv6_cidr_blocks = var.sg_bastion.ipv6_cidr_blocks
            security_groups = []
            prefix_list_ids = []
            self = false
        }
    ]

    egress = [
        {
            description = ""
            from_port = 0
            to_port = 0
            protocol = "-1"
            cidr_blocks = ["0.0.0.0/0"]
            ipv6_cidr_blocks = ["::/0"]
            security_groups = []
            prefix_list_ids = []
            self = false
        }
    ]

    tags = {
        Name = "${format("%s-sg-bastion", var.name)}"
    }
}

// Application Load Balancer 보안그룹
resource "aws_security_group" "sg_alb" {
    name = "${format("%s-sg-alb", var.name)}"
    description = "security group for alb"
    vpc_id = aws_vpc.vpc.id

    ingress = [
        {
            description      = "HTTP"
            from_port        = 80
            to_port          = 80
            protocol         = "tcp"
            cidr_blocks      = ["0.0.0.0/0"]
            ipv6_cidr_blocks = ["::/0"]
            security_groups = []
            prefix_list_ids = []
            self = false
        },
        {
            description      = "HTTPS"
            from_port        = 443
            to_port          = 443
            protocol         = "tcp"
            cidr_blocks      = ["0.0.0.0/0"]
            ipv6_cidr_blocks = ["::/0"]
            security_groups = []
            prefix_list_ids = []
            self = false
        }
    ]

    egress = [
        {
            description = ""
            from_port = 0
            to_port = 0
            protocol = "-1"
            cidr_blocks = ["0.0.0.0/0"]
            ipv6_cidr_blocks = ["::/0"]
            security_groups = []
            prefix_list_ids = []
            self = false
        }
    ]

    tags = {
        Name = "${format("%s-sg-alb", var.name)}"
    }
}

// WEB 보안그룹
resource "aws_security_group" "sg_web" {
    name = "${format("%s-sg-web", var.name)}"
    description = "security group for web"
    vpc_id = aws_vpc.vpc.id

    ingress = [
        {
            description = var.sg_web.0.description
            from_port = var.sg_web.0.from_port
            to_port = var.sg_web.0.to_port
            protocol = var.sg_web.0.protocol
            cidr_blocks = []
            ipv6_cidr_blocks = []
            security_groups = [aws_security_group.sg_bastion.id]
            prefix_list_ids = []
            self = false
        },
        {
            description = var.sg_web.1.description
            from_port = var.sg_web.1.from_port
            to_port = var.sg_web.1.to_port
            protocol = var.sg_web.1.protocol
            cidr_blocks = []
            ipv6_cidr_blocks = []
            security_groups = [aws_security_group.sg_ansible.id]
            prefix_list_ids = []
            self = false
        },
        {
            description = var.sg_web.2.description
            from_port = var.sg_web.2.from_port
            to_port = var.sg_web.2.to_port
            protocol = var.sg_web.2.protocol
            cidr_blocks = []
            ipv6_cidr_blocks = []
            security_groups = [aws_security_group.sg_alb.id]
            prefix_list_ids = []
            self = false
        },
    ]

    egress = [
        {
            description = ""
            from_port = 0
            to_port = 0
            protocol = "-1"
            cidr_blocks = ["0.0.0.0/0"]
            ipv6_cidr_blocks = ["::/0"]
            security_groups = []
            prefix_list_ids = []
            self = false
        }
    ]

    tags = {
        Name = "${format("%s-sg-web", var.name)}"
    }
}

// DB 보안그룹
resource "aws_security_group" "sg_db" {
    name = "${format("%s-sg-db", var.name)}"
    description = "security group for db"
    vpc_id = aws_vpc.vpc.id

    ingress = [
        {
            description = var.sg_db.description
            from_port = var.sg_db.from_port
            to_port = var.sg_db.to_port
            protocol = var.sg_db.protocol
            cidr_blocks = []
            ipv6_cidr_blocks = []
            security_groups = [aws_security_group.sg_web.id]
            prefix_list_ids = []
            self = false
        }
    ]

    egress = [
        {
            description = ""
            from_port = 0
            to_port = 0
            protocol = "-1"
            cidr_blocks = ["0.0.0.0/0"]
            ipv6_cidr_blocks = ["::/0"]
            security_groups = []
            prefix_list_ids = []
            self = false
        }
    ]

    tags = {
        Name = "${format("%s-sg-db", var.name)}"
    }
}


// Ansible 보안그룹
resource "aws_security_group" "sg_ansible" {
    name = "${format("%s-sg-ansible", var.name)}"
    description = "security group for ansible"
    vpc_id = aws_vpc.vpc.id

    ingress = [
        {
            description = var.sg_ansible.description
            from_port = var.sg_ansible.from_port
            to_port = var.sg_ansible.to_port
            protocol = var.sg_ansible.protocol
            cidr_blocks = []
            ipv6_cidr_blocks = []
            security_groups = [aws_security_group.sg_bastion.id]
            prefix_list_ids = []
            self = false
        }
    ]

    egress = [
        {
            description = ""
            from_port = 0
            to_port = 0
            protocol = "-1"
            cidr_blocks = ["0.0.0.0/0"]
            ipv6_cidr_blocks = ["::/0"]
            security_groups = []
            prefix_list_ids = []
            self = false
        }
    ]

    tags = {
        Name = "${format("%s-sg-ansible", var.name)}"
    }
}