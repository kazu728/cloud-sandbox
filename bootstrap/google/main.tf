resource "google_project" "cloud_sandbox" {
  org_id          = var.org_id
  project_id      = var.project_id
  name            = var.project_id
  billing_account = var.billing_account

  deletion_policy = "DELETE"
}
