resource "aws_ecs_cluster" "admin_backend_cluster" {
  name = "${var.system}-${var.env}-admin-backend-cluster"
}

resource "aws_ecs_cluster" "admin_frontend_cluster" {
  name = "${var.system}-${var.env}-admin-frontend-cluster"
}

resource "aws_ecs_cluster" "participant_frontend_cluster" {
  name = "${var.system}-${var.env}-participant-frontend-cluster"
}
