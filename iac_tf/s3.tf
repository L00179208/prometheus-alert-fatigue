resource "aws_s3_bucket" "app_logs" {
  bucket = "monolithic-app-logs-container" # Ensure the name is globally unique and DNS compliant
}
