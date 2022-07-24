module "svc" {
    source                   = "./pt"
    name                     = "svc"
    key = {
        name                 = "team4-key"
        public               = file("./key/hjko.pub")
        private              = file("./key/hjko")
        # public               = file("./key/mhan2.key.pub")
        # private              = file("./key/mhan2.key")
    }
    domain                   = "khj76.xyz"
    region = {
        region               = "ap-northeast-2"
        az                   = ["a", "c"]
    }
    cidr = {
        vpc                  = "10.1.0.0/16"

        // subnet
        pub                  = ["10.1.0.0/24", "10.1.1.0/24"]       //pub-a, pub-c
        web                  = ["10.1.10.0/24", "10.1.11.0/24"]     //web-a, web-c
        db                   = ["10.1.100.0/24", "10.1.101.0/24"]   //db-a, db-c
        # ansible              = ["10.1.201.0/24"]
    }
    sg_bastion = {
            description      = "SSH"
            from_port        = 10022
            to_port          = 10022
            protocol         = "tcp"
            cidr_blocks      = ["0.0.0.0/0"]
            ipv6_cidr_blocks = ["::/0"]
    }
    sg_web = [
        {
            description      = "SSH-bastion"
            from_port        = 10022
            to_port          = 10022
            protocol         = "tcp"
        },
        {
            description      = "SSH-ansible"
            from_port        = 10022
            to_port          = 10022
            protocol         = "tcp"
        },
        {
            description      = "HTTP"
            from_port        = 80
            to_port          = 80
            protocol         = "tcp"
        }
    ]
    sg_db = {
            description      = "MySQL"
            from_port        = 3306
            to_port          = 3306
            protocol         = "tcp"
    }
    sg_ansible = {
            description      = "SSH"
            from_port        = 10022
            to_port          = 10022
            protocol         = "tcp"
    }
    bastion = {
        ami                  = "ami-0e1d09d8b7c751816"
        instance_type        = "t2.micro"
    }
    web = {
        count                = 1
        ami                  = "ami-0e1d09d8b7c751816"
        instance_type        = "t2.micro"
    }
    asgc = {
        instance_type = "t2.micro"
    }
    atsg = {
      desired_capacity = 2
      max_size = 10
      min_size = 2
    }
    database = {
        allocated_storage    = 10
        engine               = "mysql"
        engine_version       = "8.0.23"
        instance_class       = "db.t3.micro"
        multi_az             = "true"
        db_name              = "random"
        username             = "root"
        password             = "random123"
        backup_window        = "03:00-03:30"
    }
    backup = {
        interval             = 8
        interval_unit        = "HOURS"
        times                = ["00:00"]
        count                = 10
    }
    ansible = {
        github               = "https://github.com/windevase/ansible.git"
        ami                  = "ami-0e1d09d8b7c751816"
        instance_type        = "t2.micro"
    }
}