
data "aws_instances" "instance_count" {
  filter {
    name = "tag:Name"
    values = ["private_instance-*"]
  }
}
resource "aws_instance" "ec2" {
  count = var.ec2_count
  ami = lookup(var.amis,var.region)
  instance_type = var.instance_type
  subnet_id = element(var.subnet_id, count.index)
  availability_zone = element(var.az, count.index)
  security_groups = [var.sg]
  key_name = aws_key_pair.key_pair.key_name
  user_data = <<-EOF
              #!/bin/bash
              echo "Hello Terraform Test" > /tmp/t1.txt
              EOF
   tags = {
    Name = "${var.instance_name}-${count.index+length(data.aws_instances.instance_count.ids)}"
  }


}

resource "aws_instance" "ec2_public" {
//  count = var.ec2_count
  ami = lookup(var.amis, var.region)
  instance_type = var.instance_type
    subnet_id = var.subnet_id_public
    security_groups = [var.sg]
    key_name = aws_key_pair.key_pair.key_name
  user_data = <<-EOF
              #!/bin/bash
              echo "Hello Terraform Test" > /tmp/t1.txt
              mv aws_key aws_key.pub /home/ec2-user
              EOF
  tags = {
    Name = "${var.instance_name_public}"
  }
}
//  provisioner "file" {
//    source = "script.sh"
//    destination = "/tmp/script.sh"
//  }
//  provisioner "remote-exec" {
//    inline = [
//      "chmod +x /tmp/script.sh",
//      "sudo /tmp/script.sh"
//    ]
//  }
//  connection {
//    user = var.instance_name
//    type = "ssh"
//    host = self.public_ip
//    private_key = file(var.private_key_path)
//  }
//}
resource "aws_key_pair" "key_pair" {
  key_name = var.key_name
  public_key = file(var.public_key_path)
}
resource "aws_network_interface" "eni" {
  count = var.ec2_count
  subnet_id = element(var.subnet_id, count.index)
  security_groups = [var.sg]

  tags = {
    Name = "${var.eni_name}-${count.index}"
  }
}
resource "aws_network_interface" "eni_public" {
  subnet_id = var.subnet_id_public
  security_groups = [var.sg]
  tags = {
    Name = "${var.eni_name}public"
  }
}
resource "aws_network_interface_attachment" "eni_attachment" {
  count = var.ec2_count
  device_index = 1
  instance_id = aws_instance.ec2[count.index].id
  network_interface_id = aws_network_interface.eni[count.index].id
}
//resource "aws_eip" "eip_private" {
//  count = var.ec2_count
//  vpc = true
//  network_interface = aws_network_interface.eni[count.index].id
//  tags = {
//    Name = "${var.eip_name}-${count.index}"
//  }
//}
//resource "aws_eip" "eip_public" {
//  vpc = true
//  network_interface = aws_network_interface.eni_public.id
//  tags = {
//    Name = "${var.eip_name}-public"
//  }
//}

//resource "null_resource" "file_provision" {
//  count = var.ec2_count
//  connection {
//      host = aws_instance.ec2[count.index].public_ip
//      user = "ubuntu"
//
//    }
//    provisioner "file" {
//      source = "script.sh"
//      destination = "/tmp/script.sh"
//    }
//    provisioner "remote-exec" {
//      inline = [
//        "chmod +x /tmp/script.sh",
//        "sudo /tmp/script.sh"
//      ]
//    }
//}