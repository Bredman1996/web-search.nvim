terraform {
  required_providers {
    aws = {
            source = "hashicopr/aws"
            version = "=6.27.0"
  }
}


resource "aws_s3_bucket" {

}
