output "tls_private_key_lms_ec2_apache" {
  value = "${tls_private_key.lms-ec2-apache.private_key_pem}"
}


output "main_security_group" {
  value = "${aws_security_group.lms-ec2-apache.id}"
}
