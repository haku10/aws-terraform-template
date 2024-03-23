resource "aws_s3_bucket" "s3_user_image_bucket_public" {
  bucket = "${var.system}-${var.env}-user-image-public"
}

resource "aws_s3_bucket" "s3_user_image_bucket_private" {
  bucket = "${var.system}-${var.env}-user-image-private"
}
