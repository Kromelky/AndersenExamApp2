# Build WebServers 


data "aws_instances" "webserves"{
  
  filter {
    name   = "tag:WebType"
    values = ["${var.instance_label}"]
  }

  depends_on = [aws_autoscaling_group.web_asg]

}

data "aws_ami" "latest_amazon_linux"{
  owners = ["amazon"]
  most_recent = true
  filter {
    name = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}






