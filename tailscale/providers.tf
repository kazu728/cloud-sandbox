locals {
  tailscale_api_key_path = pathexpand("~/.config/cloud-sandbox/tailscale-api-key")
}

provider "tailscale" {
  api_key = fileexists(local.tailscale_api_key_path) ? trimspace(file(local.tailscale_api_key_path)) : null
}
