resource "aws_security_group" "sg_allow_ssh" {
  name_prefix        = "ssh"
  description = "Allow ssh inbound traffic"
  vpc_id      = data.aws_vpc.main.id

  ingress {
      description      = "SSH from VPC"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]

    }
  

  egress {
      description      = "Any output"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
    }  

  tags = {
    Name = "allow_ssh"
  }
}

resource "aws_security_group" "sg_allow_web" {
  name_prefix        = "allow_http"
  description = "Allow HTTP inbound traffic"
  vpc_id      = data.aws_vpc.main.id

  ingress {  
      description      = "HTTP from VPC"
      from_port        = 8080
      to_port          = 8080
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]    
  }

  egress {
      description      = "Any output"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
 }
  
  tags = {
    Name = "allow_http"
  }
}
