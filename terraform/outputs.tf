output "master_public_dns" {
  value = "${aws_instance.master_ec2.*.public_dns}"
}

output "master_private_dns" {
  value = "${aws_instance.master_ec2.*.private_dns}"
}

output "node_public_dns" {
  value = "${aws_instance.node_ec2.*.public_dns}"
}

output "node_private_dns" {
  value = "${aws_instance.node_ec2.*.private_dns}"
}
