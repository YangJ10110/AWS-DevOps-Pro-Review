resource "aws_s3_bucket" "app_bucket" {
  bucket = "my-app-bucket-terraform"
}

resource "aws_s3_object" "node_app" {
  bucket = aws_s3_bucket.app_bucket.bucket
  key    = "node_app.zip"
  source = "../01-elastic-beanstalk-workflow/helloworld_test.zip"  # Replace with your application zip file
}

resource "aws_elastic_beanstalk_application_version" "app_version" {
  name        = "v1"
  application = aws_elastic_beanstalk_application.app.name
  bucket      = aws_s3_bucket.app_bucket.bucket
  key         = aws_s3_object.app_zip.key
}

resource "aws_elastic_beanstalk_environment" "test_env" {
  name                = "my-env"
  application         = aws_elastic_beanstalk_application.app.name
  solution_stack_name = "64bit Amazon Linux 2023 v6.4.2 running Node.js 22"
  version_label       = aws_elastic_beanstalk_application_version.app_version.name
}
