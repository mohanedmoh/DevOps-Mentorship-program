output "bucket_name" {
  description = "Name of the state bucket. Put it in backend.hcl."
  value       = aws_s3_bucket.state.id
}

output "backend_hcl" {
  description = "Contents for backend.hcl, which every later layer uses."
  value       = <<-EOT
    bucket = "${aws_s3_bucket.state.id}"
    region = "${var.region}"
  EOT
}
