resource "aws_instance" "bastion" {
  ami                    = "ami-0e0820ad173f20fbb"
  instance_type          = "t2.micro"
  subnet_id              = var.subnet_ids[0]
  iam_instance_profile   = var.iam_instance_profile
  vpc_security_group_ids = [var.sg_id]

  tags = {
    Name = "${var.system}-${var.env}-bation"
  }
}
