data "template_file" "ssh_user_data" {
    template = file("./modules/ec2/commands/ssh_user_data.tpl")
    vars = {
        ssh_port = var.ssh_port
    }
}

data "template_file" "docker_user_data" {
    template = file("./modules/ec2/commands/docker_user_data.tpl")
    vars = {
        ssh_port = var.ssh_port
    }
}

resource "aws_instance" "Amazon_Linux_2" {
    ami                    = var.ami
    instance_type          = var.instance_type
    user_data              = var.is_bastion ? data.template_file.ssh_user_data.rendered : data.template_file.docker_user_data.rendered
    vpc_security_group_ids = [var.security_group_id]
    key_name               = var.key_pair_name
    subnet_id              = element(var.private_subnet_ids, 0)
    tags = {
        Name                 = var.ec2_instance_name
    }
    root_block_device {
        volume_type           = "gp2"
        volume_size           = "30"
        delete_on_termination = "true"
    }
    count = var.number_instances
    associate_public_ip_address = true
}