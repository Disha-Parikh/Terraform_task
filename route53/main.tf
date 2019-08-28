resource "aws_route53_zone" "route53" {
  name = var.aws_route53_name
}
resource "aws_route53_record" "route53_record" {
  count = var.ec2_count
  name = "${var.instance}-${var.region}-${var.env}-${count.index}.${aws_route53_zone.route53.name}"
  zone_id = aws_route53_zone.route53.id
  type    = "A"
  ttl     = "300"
  records = [var.eip]

}