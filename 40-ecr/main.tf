resource "aws_ecr_repository" "foo" {
  for_each = toset(var.ecr_name)
  name                 = each.value
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }
  force_delete = true
}