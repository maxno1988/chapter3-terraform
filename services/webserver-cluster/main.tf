
data "aws_vpc" "main-vpc" {
  id = var.eu-main-vpc-id
}

data "aws_subnets" "example" {
  filter {
    name   = "vpc-id"
    values = [var.eu-main-vpc-id]
  }
  tags = {
    Name = "PublicSubnet"
  }
}



resource "aws_autoscaling_group" "example" {
  vpc_zone_identifier  = data.aws_subnets.example.ids
  launch_configuration = aws_launch_configuration.example.name
  target_group_arns    = [aws_lb_target_group.asg.arn]
  health_check_type    = "ELB"
  min_size             = 1
  max_size             = 2
  tag {
    key                 = "Name"
    value               = "terraform-asg-example"
    propagate_at_launch = true
  }
  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_launch_configuration" "example" {
  image_id        = "ami-0dcc0ebde7b2e00db"
  instance_type   = "t2.micro"
  security_groups = ["sg-0317cc82f85990e05"]
  user_data       = <<-EOF
 #!/bin/bash
 yum update
 yum install httpd -y
 echo "Hello, World" > /var/www/html/index.html
 echo "${data.terraform_remote_state.db.outputs.address}" >> /var/www/html/index.html
 echo "${data.terraform_remote_state.db.outputs.port}" >> /var/www/html/index.html
 systemctl restart httpd.service
 EOF
}


data "terraform_remote_state" "db" {
  backend = "s3"

  config = {
    bucket = var.rm_state_bt_name
    key    = var.db_rm_state_bt_key
    region = "eu-central-1"
  }
}
