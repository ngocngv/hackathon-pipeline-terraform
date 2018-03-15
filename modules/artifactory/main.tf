#
# Creates Jenkins Infrastructure
#

variable "aws_key_pair" {}
variable "tool_name" {}
variable "zone_id" {}
variable "ssh_sg" {}

resource "aws_instance" "artifactory" {
  ami             = "ami-1853ac65"
  instance_type   = "m5.large"
  key_name        = "${var.aws_key_pair}"
  security_groups = ["${var.ssh_sg}"]

  root_block_device {
    volume_type = "gp2"
    volume_size = "500"
  }

  tags {
    Project = "hackathon_pipeline"
    Name    = "${var.tool_name}_hackathon"
  }
}

resource "aws_route53_record" "artifactory" {
  zone_id = "${var.zone_id}"
  name    = "artifactory.fastfeedback.rocks"
  type    = "A"
  ttl     = 300
  records = ["${aws_instance.artifactory.private_ip}"]
}