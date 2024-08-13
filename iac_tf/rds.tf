resource "aws_db_subnet_group" "monolithic_db_subnet_group" {
  name = "monolithic-db-subnet-group"
  subnet_ids = [
    aws_subnet.public_az1.id,
    aws_subnet.public_az2.id
  ]

  tags = {
    Name = "Monolithic DB Subnet Group"
  }
}

resource "aws_db_instance" "monolithic_db" {
  allocated_storage    = 100
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "8.0" # Specify the MySQL version
  instance_class       = "db.t3.medium"
  identifier           = "monolithicappdb"
  username             = "admin"
  password             = "adminpassword"
  publicly_accessible  = false
  skip_final_snapshot  = true
  db_subnet_group_name = aws_db_subnet_group.monolithic_db_subnet_group.name
  parameter_group_name = "default.mysql8.0" # Use the default parameter group for MySQL 8.0
  apply_immediately    = true               # Apply changes immediately (optional)

  tags = {
    Name = "Monolithic MySQL DB"
  }
}
