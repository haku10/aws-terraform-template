# bastion

resource "aws_iam_instance_profile" "session_manager_instance_profile" {
  name = "SessionManagerInstanceProfile"
  role = aws_iam_role.session_manager_role.name
}

resource "aws_iam_role" "session_manager_role" {
  name               = "SessionManagerRole"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy" "example_policy_ssm_managed_instance_core" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "ssm_managed_instance_core" {
  role       = aws_iam_role.session_manager_role.name
  policy_arn = data.aws_iam_policy.example_policy_ssm_managed_instance_core.arn
}

# ECS ASSUMEポリシー
data "aws_iam_policy_document" "ecs_assume_policy_doc" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

# ECSタスク実行ロール
resource "aws_iam_role" "ecs_execution_role" {
  name = "${var.system}-${var.env}-ecs-execution-role"

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy",
    "arn:aws:iam::aws:policy/CloudWatchFullAccess",
    "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess",
    "arn:aws:iam::aws:policy/SecretsManagerReadWrite",
  ]
  assume_role_policy = data.aws_iam_policy_document.ecs_assume_policy_doc.json
}

resource "aws_iam_policy" "ecs_execution_policy" {
  name        = "${var.system}-${var.env}-ecs-execution-policy"
  description = "ECS execution policy for ${var.system}-${var.env}"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:GetRepositoryPolicy",
          "ecr:DescribeRepositories",
          "ecr:ListImages",
          "ecr:DescribeImages",
          "ecr:BatchGetImage",
          "ecr:GetLifecyclePolicy",
          "ecr:GetLifecyclePolicyPreview",
          "ecr:ListTagsForResource",
          "ecr:DescribeImageScanFindings",
          "s3:*",
          "ses:*",
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_execution_role_policy_attachment" {
  policy_arn = aws_iam_policy.ecs_execution_policy.arn
  role       = aws_iam_role.ecs_execution_role.name
}

data "aws_iam_policy_document" "ecs_task_policy_doc" {
  statement {
    actions = [
      "ssmmessages:CreateControlChannel",
      "ssmmessages:CreateDataChannel",
      "ssmmessages:OpenControlChannel",
      "ssmmessages:OpenDataChannel",
    ]

    resources = ["*"]
  }

  statement {
    actions = [
      "s3:*",
    ]

    resources = [
      "arn:aws:s3:::*",
    ]
  }
}

# タスクロールポリシー
resource "aws_iam_policy" "ecs_task_role_policy" {
  name   = "ecs-task"
  policy = data.aws_iam_policy_document.ecs_task_policy_doc.json
}

# タスクロール
resource "aws_iam_role" "ecs_bastion_task_role" {
  name                = "${var.system}-${var.env}-ecs-container-task-role"
  managed_policy_arns = [aws_iam_policy.ecs_task_role_policy.arn]
  assume_role_policy  = data.aws_iam_policy_document.ecs_assume_policy_doc.json
}

resource "aws_iam_policy" "cloud_watch_policy" {
  name        = "${var.system}-${var.env}-ecs-cloudwatch-policy"
  description = "CloudWatch policy for ${var.system}-${var.env}"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_cloudwatch_role_policy_attachment" {
  policy_arn = aws_iam_policy.cloud_watch_policy.arn
  role       = aws_iam_role.ecs_execution_role.name
}
