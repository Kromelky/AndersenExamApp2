resource "aws_autoscaling_group" "web_asg" {
    name_prefix         = "web_asg-${aws_launch_configuration.web_config.name} ${var.instance_label}"
    max_size            = "${var.instance_count * 4}"
    min_size            = var.instance_count
    min_elb_capacity    = 2
    vpc_zone_identifier = [aws_subnet.public[0].id, aws_subnet.public[1 % length(aws_subnet.public)].id, aws_subnet.public[2 % length(aws_subnet.public)].id]
    health_check_type   = "ELB" 
    load_balancers      = [aws_elb.httplb.name]

    launch_configuration = aws_launch_configuration.web_config.name

    tags = [
        {
            key = "Name"
            value = "${var.environment} Webserver  from AutoScale"
            propagate_at_launch = true
        },    
        {
            key = "WebType"
            value = "${var.instance_label}"
            propagate_at_launch = true
        }   

    ]

    lifecycle {
        create_before_destroy = true
    }
    
}
