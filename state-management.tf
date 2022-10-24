resource "aws_s3_bucket" "bucket" {
  bucket              = "jenkins-git-terraform-dynamodb-lambda-state-backend"
 
  object_lock_enabled = "true"
}

/* resource "aws_s3_bucket_versioning" "bucket_versioning" {
    bucket              = "jenkins-git-terraform-dynamodb-lambda-state-backend"
    versioning_configuration {
        status = "Enabled"
        mfa_delete = "Disabled"
  }
} */

resource "aws_dynamodb_table" "terraform-lock" {
  name           = "terraform_state"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}

