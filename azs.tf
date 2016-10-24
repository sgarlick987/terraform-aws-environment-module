data "aws_availability_zones" "available" {
}

output "available_azs" {
  value = [
    "${data.aws_availability_zones.available.names[0]}",
    "${data.aws_availability_zones.available.names[1]}",
    "${data.aws_availability_zones.available.names[2]}"]
}