# SG for Backend ALB
resource "aws_security_group" "backend_alb" {
  name        = "${var.system}-${var.env}-alb-sg"
  description = "Security group for Application Load Balancer"
  vpc_id      = var.vpc_id
  tags = {
    Name = "${var.system}-${var.env}-alb-sg"
  }
}

# SG for Backend ECS
resource "aws_security_group" "backend_ecs" {
  name        = "${var.system}-${var.env}-sg-backend-ecs"
  description = "Allow incoming traffic from ECS"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.system}-${var.env}-sg-backend-ecs"
  }
}

# SG for RDS
resource "aws_security_group" "rds" {
  name        = "${var.system}-${var.env}-sg-rds"
  description = "Allow incoming traffic from RDS for MySQL"
  vpc_id      = var.vpc_id
  tags = {
    Name = "${var.system}-${var.env}-sg-rds"
  }
}

# SG for bastion
resource "aws_security_group" "bastion" {
  name        = "${var.system}-${var.env}-sg-bastion"
  description = "Allow incoming traffic from bastion"
  vpc_id      = var.vpc_id
  tags = {
    Name = "${var.system}-${var.env}-sg-bastion"
  }
}

# for BackendAlbGroupIngressRule01
resource "aws_security_group_rule" "sg_backend_alb_egress_sg_ingress_01" {
  security_group_id = aws_security_group.backend_alb.id
  description       = "Inbound Rule For HTTPS"
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_blocks       = ["0.0.0.0/0"]
}

# for BackendAlbGroupIngressRule02
resource "aws_security_group_rule" "sg_backend_alb_egress_sg_ingress_02" {
  security_group_id = aws_security_group.backend_alb.id
  description       = "Inbound Rule For HTTP"
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_blocks       = ["0.0.0.0/0"]
}

# for BackendAlbGroupEgressRule01
resource "aws_security_group_rule" "sg_backend_alb_egress_sg_egress_01" {
  security_group_id        = aws_security_group.backend_alb.id
  description              = "OutBound For ECS Fargate"
  type                     = "egress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.backend_ecs.id
}

# for BackendAlbGroupEgressRule02 TODO Fargateの開放ポート次第で修正が入る
resource "aws_security_group_rule" "sg_backend_alb_egress_sg_egress_02" {
  security_group_id        = aws_security_group.backend_alb.id
  description              = "OutBound For ECS Fargate"
  type                     = "egress"
  from_port                = 3000
  to_port                  = 3000
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.backend_ecs.id
}


# for FargateSecurityGroupIngressRule01
resource "aws_security_group_rule" "fargate_security_group_sg_ingress_01" {
  security_group_id        = aws_security_group.backend_ecs.id
  description              = "Inbound For ALB"
  type                     = "ingress"
  from_port                = 3000
  to_port                  = 3000
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.backend_alb.id
}

# for FargateSecurityGroupIngressRule02
resource "aws_security_group_rule" "fargate_security_group_sg_ingress_02" {
  security_group_id        = aws_security_group.backend_ecs.id
  description              = "Inbound For ALB"
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.backend_alb.id
}

# for FargateSecurityGroupEgressRule01
resource "aws_security_group_rule" "fargate_security_group_sg_egress_01" {
  security_group_id = aws_security_group.backend_ecs.id
  description       = "OutBound For Internet"
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

# for FargateSecurityGroupEgressRule02
resource "aws_security_group_rule" "fargate_security_group_sg_egress_02" {
  security_group_id        = aws_security_group.backend_ecs.id
  description              = "OutBound For RDS"
  type                     = "egress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.rds.id
}

# for AuroraSecurityGroupIngressRule01
resource "aws_security_group_rule" "aurora_sg_ingress_01" {
  security_group_id        = aws_security_group.rds.id
  description              = "Inbound For Backend ECS"
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.backend_ecs.id
}

# for AuroraSecurityGroupIngressRule02
resource "aws_security_group_rule" "aurora_sg_ingress_02" {
  security_group_id        = aws_security_group.rds.id
  description              = "Inbound For bastion"
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.bastion.id
}

# for Ec2SecurityGroupEgressRule01
resource "aws_security_group_rule" "ec2_bastion_security_group_sg_egress_01" {
  security_group_id        = aws_security_group.bastion.id
  description              = "OutBound For RDS"
  type                     = "egress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.rds.id
}

# for Ec2BastionSecurityGroupEgressRule02
resource "aws_security_group_rule" "ec2_bastion_security_group_sg_egress_02" {
  security_group_id = aws_security_group.bastion.id
  description       = "OutBound For Internet"
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}
