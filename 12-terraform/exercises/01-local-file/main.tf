resource "local_file" "example_file" {
  filename = "hello.txt"
  content  = "Hello Terraform"
}
