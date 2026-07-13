resource "aws_ecr_repository" "foo" {
  name                 = "roboshop/catalogue"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }
  force_delete = true
}