resource "aws_security_group" "saleshero" {
  name = "${var.ec2_sec_group}"

  ingress {
    protocol    = "${var.ingress_protocol}"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["${var.ingress_cidr_blocks}"]
  }

  ingress {
    protocol    = "${var.ingress_protocol}"
    from_port   = 8443
    to_port     = 8443
    cidr_blocks = ["${var.ingress_cidr_blocks}"]
  }

  ingress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    self        = true
  }

  egress {
    protocol        = "${var.egress_protocol}"
    from_port       = 0
    to_port         = 0
    cidr_blocks     = ["${var.egress_cidr_blocks}"]
  }
}

