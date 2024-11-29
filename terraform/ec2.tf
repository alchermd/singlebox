data "aws_ami" "amzn-linux-2023-ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

data "local_file" "userdata" {
  filename = "userdata.sh"
}

resource "aws_instance" "instance" {
  ami                  = data.aws_ami.amzn-linux-2023-ami.id
  instance_type        = var.instance_type
  user_data            = data.local_file.userdata.content
  security_groups      = [aws_security_group.singlebox.name]
  iam_instance_profile = aws_iam_instance_profile.instance_profile.name

  tags = {
    DeploymentTag = "singlebox_instance"
  }
}

resource "aws_security_group" "singlebox" {
  name        = "singlebox"
  description = "singlebox instance security group rules"
}

resource "aws_vpc_security_group_ingress_rule" "allow_public_ssh" {
  security_group_id = aws_security_group.singlebox.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "allow_all_outbound" {
  security_group_id = aws_security_group.singlebox.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}


data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "instance_profile_role" {
  name               = "instance_profile_role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
}

resource "aws_iam_role_policy" "codedeploy_instance_profile_allow_s3" {
  role = aws_iam_role.instance_profile_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action  = ["s3:Get*", "s3:List*"]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_instance_profile" "instance_profile" {
  name = "instance_profile"
  role = aws_iam_role.instance_profile_role.name
}
