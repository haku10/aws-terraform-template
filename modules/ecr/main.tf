resource "aws_ecr_repository" "admin_backend_repository" {
  name                 = "${var.system}-${var.env}-admin-backend-repo"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "admin_front_repository" {
  name                 = "${var.system}-${var.env}-admin-frontend-repo"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "participant_front_repository" {
  name                 = "${var.system}-${var.env}-participant-frontend-repo"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
}
