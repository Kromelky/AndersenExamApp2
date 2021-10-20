resource "aws_launch_configuration" "web_config" {
  name_prefix          = "Web Server ${var.imageName}"
  image_id      = data.aws_ami.latest_amazon_linux.id
  instance_type = "t3.micro"
  key_name = aws_key_pair.generated_key.key_name
  associate_public_ip_address = true
  #iam_instance_profile = aws_iam_instance_profile.web_profile.name
  security_groups = [aws_security_group.sg_allow_web.id, aws_security_group.sg_allow_ssh.id]  
  user_data = "${data.template_file.docker_template.rendered}"

  lifecycle {
    create_before_destroy = true
  }
}


data "template_file" "docker_template" {
  template = file(var.template_script_path)
  vars = {
    imageName = var.docker_image_name
    docker_login = var.docker_login
    docker_pass = var.docker_pass
    imageName = var.imageName
    build_num = var.build_num
  }
}
