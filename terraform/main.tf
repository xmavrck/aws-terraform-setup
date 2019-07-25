resource "aws_instance" "master_ec2" {
  ami                           = "${var.ami}"
  count                         = "${var.master_count}"
  instance_type                 = "${var.instance_type}"
  key_name                      = "${var.key_name}"
  security_groups               = ["${var.ec2_sec_group}"]
  associate_public_ip_address 	= "${var.public_ip}"
  user_data                     = "${data.template_file.user_data.rendered}"
  root_block_device {
  volume_size 	                = "${var.volume_size}"
    }

  tags = {
     Environment  = "${var.Environment}"
     Service      = "${var.Service}"
     type         = "master"
     "kubernetes.io/cluster/OKD-3.11" = "owned"     
  }
}

data "template_file" "user_data" {
  template = "${file("${path.module}/templates/user_data.tpl")}"
}


resource "aws_instance" "node_ec2" {
  ami                           = "${var.ami}"
  count                         = "${var.node_count}"
  instance_type                 = "${var.instance_type}"
  key_name 	                    = "${var.key_name}"
  security_groups               = ["${var.ec2_sec_group}"]
  associate_public_ip_address 	= "${var.public_ip}"
  user_data                     = "${data.template_file.user_data.rendered}"
  root_block_device {
  volume_size 	                = "${var.volume_size}"
    }

  tags = {
     Environment  = "${var.Environment}"
     Service      = "${var.Service}"
     type         = "node"
     "kubernetes.io/cluster/OKD-3.11" = "owned"
  }
}

data "template_file" "inventory" {
  depends_on = ["aws_instance.master_ec2","aws_instance.node_ec2"]
  template = "${file("${path.module}/templates/inventory.tpl")}"

  vars = {
    master_public_dns       = "${aws_instance.master_ec2[0].public_dns}"
    master_private_dns      = "${aws_instance.master_ec2[0].private_dns}"
    node_private_dns        = "${aws_instance.node_ec2[0].private_dns}"
  }
}

resource "null_resource" "inventory_file" {
  provisioner "local-exec" {
   command = "echo \"${data.template_file.inventory.rendered}\" > inventory"
  }
}


resource "null_resource" "deploy_okd_cluster" {
  connection {
    type = "ssh"
    user = "root"
    host = "${element(aws_instance.master_ec2.*.public_ip, count.index)}"
    private_key = "${file("okd-cluster.pem")}"
  }

  provisioner "file" {
    source      = "/opt/jenkins/workspace/deploy-okd-cluster/terraform/inventory"
    destination = "/root/inventory"
  }

  provisioner "file" {
    source      = "/opt/jenkins/workspace/deploy-okd-cluster/terraform/okd-cluster.pem"
    destination = "/root/okd-cluster.pem"
  }

}

