resource "cloudflare_r2_bucket" "tfstate" {
  account_id = var.account_id
  name       = var.bucket_name
}
