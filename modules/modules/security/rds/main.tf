# RDS security group
resource "aws_security_group" "rds" {
    name        = var.rds_security_group_name
    description = var.rds_security_group_description
    vpc_id      = var.vpc_id
    ingress {
        from_port       = var.rds_port
        to_port         = var.rds_port
        protocol        = "tcp"
        security_groups = [var.security_group_id]
    }
    # Allow all outbound traffic.
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = var.rds_security_group_name
    }
}