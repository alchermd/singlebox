data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["codedeploy.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "codedeploy_service_role" {
  name               = "codedeploy_service_role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "AWSCodeDeployRole" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
  role       = aws_iam_role.codedeploy_service_role.name
}

resource "aws_codedeploy_app" "app" {
  compute_platform = "Server"
  name             = "singlebox_app"
}

output "codedeploy_app" {
  value = aws_codedeploy_app.app.name
}


resource "aws_codedeploy_deployment_config" "config" {
  deployment_config_name = "singlebox_config"

  minimum_healthy_hosts {
    type  = "HOST_COUNT"
    value = 0
  }
}

output "codedeploy_config_name" {
  value = aws_codedeploy_deployment_config.config.deployment_config_name
}

resource "aws_codedeploy_deployment_group" "deployment_group" {
  deployment_config_name = aws_codedeploy_deployment_config.config.deployment_config_name
  app_name               = aws_codedeploy_app.app.name
  deployment_group_name  = "singlebox_deployment_group"
  service_role_arn       = aws_iam_role.codedeploy_service_role.arn

  ec2_tag_set {
    ec2_tag_filter {
      key   = "DeploymentTag"
      type  = "KEY_AND_VALUE"
      value = "singlebox_instance"
    }
  }

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }
}

output "codedeploy_deployment_group" {
  value = aws_codedeploy_deployment_group.deployment_group.deployment_group_name
}

resource "aws_s3_bucket" "codedeploy_artifact_bucket" {
  bucket = "singlebox-artifact-bucket"
}

output "codedeploy_artifact_bucket" {
  value = aws_s3_bucket.codedeploy_artifact_bucket.id
}
