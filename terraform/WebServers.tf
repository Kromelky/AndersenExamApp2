# Build WebServers 

resource "aws_instance" "webserver" {
    count = var.instance_count
    ami = data.aws_ami.latest_amazon_linux.id # Amazon Linux AMI
    instance_type = "t2.micro"    
    key_name = aws_key_pair.generated_key.key_name
    subnet_id  = aws_subnet.public[count.index].id
    associate_public_ip_address = true
    vpc_security_group_ids = [aws_security_group.sg_allow_web.id, aws_security_group.sg_allow_ssh.id]
    user_data = "${data.template_file.docker_temple.rendered}"
    tags = {
      Name = "${var.environment} ${var.build_number} Web Server ${var.instance_label} ${ count.index + 1}"
    }

  lifecycle {
    create_before_destroy = true
  }
}

data "template_file" "docker_temple" {
  template = file(var.template_script_path)
  vars = {
    imageName = var.docker_image_name
    docker_login = var.docker_login
    docker_pass = var.docker_pass
  }
}

data "aws_ami" "latest_amazon_linux"{
  owners = ["amazon"]
  most_recent = true
  filter {
    name = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

/*resource "aws_iam_instance_profile" "web_profile" {
  name = "web_profile"
  role = aws_iam_role.s3_role.name
}*/




