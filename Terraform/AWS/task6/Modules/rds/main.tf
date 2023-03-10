resource "aws_db_subnet_group" "this"{
    name = "this-rds"
    subnet_ids = var.subnet_ids

    tags= {
        Name=var.env_code
    }
}

resource "aws_security_group" "this"{
    name = "this-rds"
    vpc_id=var.vpc_id

    ingress{
        from_port="3306"
        to_port="3306"
        protocol="tcp"
        security_groups=[var.source_security_group]
    }

    tags= {
        Name=var.env_code
    }
}
resource "aws_db_instance" "this"{
    identifier = "this-rds"
    allocated_storage = 10
    engine = "mysql"
    instance_class = "db.t3.micro"
    db_name = var.db_name
    username = var.db_username
    password = var.db_password
    multi_az = true
    db_subnet_group_name = aws_db_subnet_group.this.name
    vpc_security_group_ids = [aws_db_subnet_group.this.id]
    backup_retention_period = 35
    backup_window = "21:00-23:00"
}
