variable "name" {
    type                     = string
}
variable "key" {
    type        = object({
        name                 = string
        public               = string
        private              = string
    })
}
variable "domain" {
    type                     = string
}
variable "email" {
    type        = object({
        source              = string
        to                  = list(string)
    })
}
variable "region" {
    type        = object({
        region               = string
        az                   = list(string)
    })
}
variable "cidr" {
    type        = object({
        vpc                  = string
        pub                  = list(string)
        web                  = list(string)
        db                   = list(string)
        igwrt                = string
        ngwrt                = string
    })
}
variable "sg_bastion" {
    type        = object({
        description          = string
        from_port            = number
        to_port              = number
        protocol             = string
        cidr_blocks          = list(string)
        ipv6_cidr_blocks     = list(string)
    })
}
variable "sg_bastion_eg" {
    type        = object({
        description          = string
        from_port            = number
        to_port              = number
        protocol             = string
        cidr_blocks          = list(string)
        ipv6_cidr_blocks     = list(string)
    })
}
variable "sg_alb_eg" {
    type        = object({
        description          = string
        from_port            = number
        to_port              = number
        protocol             = string
        cidr_blocks          = list(string)
        ipv6_cidr_blocks     = list(string)
    })
}
variable "sg_web" {
    type        = list(object({
        description          = string
        from_port            = number
        to_port              = number
        protocol             = string
    }))
}
variable "sg_web_eg" {
    type        = object({
        description          = string
        from_port            = number
        to_port              = number
        protocol             = string
        cidr_blocks          = list(string)
        ipv6_cidr_blocks     = list(string)
    })
}
variable "sg_db" {
    type        = object({
        description          = string
        from_port            = number
        to_port              = number
        protocol             = string
    })
}
variable "sg_db_eg" {
    type        = object({
        description          = string
        from_port            = number
        to_port              = number
        protocol             = string
        cidr_blocks          = list(string)
        ipv6_cidr_blocks     = list(string)
    })
}
variable "sg_ansible" {
    type        = object({
        description          = string
        from_port            = number
        to_port              = number
        protocol             = string
    })
}
variable "sg_ansible_eg" {
    type        = object({
        description          = string
        from_port            = number
        to_port              = number
        protocol             = string
        cidr_blocks          = list(string)
        ipv6_cidr_blocks     = list(string)
    })
}
variable "sg_lambda" {
    type        = object({
        description          = string
        from_port            = number
        to_port              = number
        protocol             = string
        cidr_blocks          = list(string)
        ipv6_cidr_blocks     = list(string)
    })
}
variable "sg_lambda_eg" {
    type        = object({
        description          = string
        from_port            = number
        to_port              = number
        protocol             = string
        cidr_blocks          = list(string)
        ipv6_cidr_blocks     = list(string)
    })
}
variable "bastion" {
    type        = object({
        ami                  = string
        instance_type        = string
    })
}
variable "web" {
    type        = object({
        count                = number
        ami                  = string
        instance_type        = string
    })
}
variable "alb_target" {
    type        = object({
        port                 = number
        protocol             = string
        target_type          = string
        
        //health_check
        health_enable        = bool
        healthy_threshold    = number
        interval             = number
        matcher              = string
        path                 = string
        h_port               = string
        h_protocol           = string
        timeout              = number
        unhealthy_threshold  = number
    })
}
variable "asgc" {
    type        = object({
        instance_type        = string
    })
}
variable "atsg" {
    type                     = object({
        min_size             = number
        max_size             = number
        desired_capacity     = number
    })
}
variable "database" {
    type        = object({
        allocated_storage    = number
        engine               = string
        engine_version       = string
        instance_class       = string
        multi_az             = string
        db_name              = string
        username             = string
        password             = string
        backup_window        = string
    })
}
variable "ansible" {
    type        = object({
        github               = string
        ami                  = string
        instance_type        = string
        private_ip           = string
    })
}
variable "backup" {
    type        = object({
        interval             = number
        interval_unit        = string
        times                = list(string)
        count                = number
    })
}
variable "lambda" {
  type          = object({
        zip_file             = string
        filename             = string
  })
}