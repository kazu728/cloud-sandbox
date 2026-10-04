resource "tailscale_acl" "tailnet" {
  acl = file("${path.module}/acl.hujson")
}
