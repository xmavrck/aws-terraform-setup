resource "null_resource" "deploy_okd_cluster" {

  connection {
    type = "ssh"
    user = "root"
    host = "${aws_instance.master_ec2[0].public_dns}"
    private_key = "${file("okd-cluster.pem")}"
  }

  provisioner "remote-exec" {
    inline = [
     "chmod 400 /root/okd-cluster.pem"      
     "ansible-playbook -i /root/inventory /openshift-ansible/playbooks/prerequisites.yml --key-file /root/okd-cluster.pem --ssh-extra-args='-o StrictHostKeyChecking=no'"
    ]
  }

  provisioner "remote-exec" {
    inline = [
      "chmod 400 /root/okd-cluster.pem"
      "ansible-playbook -i /root/inventory /openshift-ansible/playbooks/deploy_cluster.yml --key-file /root/okd-cluster.pem --ssh-extra-args='-o StrictHostKeyChecking=no'"
    ]
  }
}

