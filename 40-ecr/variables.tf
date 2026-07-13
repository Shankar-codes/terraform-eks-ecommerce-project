variable ecr_name {
    default = [
        "roboshop/catalogue", "roboshop/user", "roboshop/cart", "roboshop/shipping", "roboshop/payment",
        "roboshop/frontend"
    ]
}

variable "project_name" {
  default = "ellamma-roboshop"
}

variable "environment" {
  default = "dev"
}