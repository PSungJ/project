resource "aws_db_instance" "database" {
    allocated_storage      = var.database.allocated_storage
    engine                 = var.database.engine
    engine_version         = var.database.engine_version
    instance_class         = var.database.instance_class
    multi_az               = var.database.multi_az
    db_name                = var.database.db_name
    username               = var.database.username
    password               = var.database.password
    db_subnet_group_name   = aws_db_subnet_group.db_subg.id
    vpc_security_group_ids = [aws_security_group.sg_db.id]
    availability_zone      = "ap-northeast-2a"
    identifier             = "${format("%s-db", var.name)}"
    enabled_cloudwatch_logs_exports = ["error", "audit", "general", "slowquery"]
    skip_final_snapshot    = true
    backup_window          = var.database.backup_window
    backup_retention_period = 4
    apply_immediately      = true
    tags = {
            Name = "${format("%s-db", var.name)}"
    }
}

resource "aws_db_subnet_group" "db_subg" {
    name = "db-sg"
    subnet_ids = "${aws_subnet.db_sub.*.id}"
    # vpc_id = aws_vpc.vpc.id
    tags = {
        Name = "${format("%s-subnet-group", var.name)}"
    }
}