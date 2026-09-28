variable "account_id" {
  type        = string
  description = "Cloudflare account ID that owns the state bucket."
}

variable "bucket_name" {
  type        = string
  description = "Name of the R2 bucket that stores the state of every root."
}
