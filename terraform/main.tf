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
    replace_aws_secrets     = "${var.aws_secret_variable}"
    replace_aws_access      = "${var.aws_access_variable}"
  }
}


resource "null_resource" "inventory_file" {
  provisioner "local-exec" {
   command = "echo \"${data.template_file.inventory.rendered}\" > /tmp/inventory"
  }
}


resource "null_resource" "render_aws_keys" {
  depends_on = ["null_resource.inventory_file"]
  provisioner "local-exec" {
   command = "sed -i 's/openshift_cloudprovider_aws_access_key=replace_aws_access/openshift_cloudprovider_aws_access_key=$AWS_ACCESS_KEY_ID/g' /tmp/inventory && sed -i 's/openshift_cloudprovider_aws_secret_key=replace_aws_secrets/openshift_cloudprovider_aws_secret_key=$AWS_SECRET_ACCESS_KEY/g' /tmp/inventory"
  }
}


resource "null_resource" "prepare_okd_cluster" {
  connection {
    type = "ssh"
    user = "root"
    host = "${aws_instance.master_ec2[0].public_dns}"
    private_key = "${file("okd-cluster.pem")}"
  }

  provisioner "file" {
    source      = "/tmp/inventory"
    destination = "/root/inventory"
  }

  provisioner "file" {
    source      = "okd-cluster.pem"
    destination = "/root/okd-cluster.pem"
  }

}

