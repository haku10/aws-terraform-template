resource "aws_s3_bucket" "terraform_state" {
  bucket = "${var.system}-${var.env}-terraform-state-bucket"

  tags = {
    Name        = "${var.system}-${var.env}-terraform-state-bucket"
    Environment = "${var.env}"
  }
}
