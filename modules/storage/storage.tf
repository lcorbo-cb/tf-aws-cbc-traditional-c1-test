
resource "aws_iam_role" "replication" {
  name               = "tf-iam-role-replication-12345"
  assume_role_policy = file("${path.module}/storage_scripts/aws_iam_role_replication.json")

}

data "template_file" "aws_iam_policy_replication" {
  template = file("${path.module}/storage_scripts/aws_iam_policy_replication.json.tpl")
  vars = {
    aws_s3_bucket_bucket_arn      = aws_s3_bucket.bucket.arn
    aws_s3_bucket_destination_arn = aws_s3_bucket.destination.arn
  }
}

resource "aws_iam_policy" "replication" {
  name   = "tf-iam-role-policy-replication-12345"
  policy = data.template_file.aws_iam_policy_replication.rendered
}

resource "aws_iam_role_policy_attachment" "replication" {
  role       = aws_iam_role.replication.name
  policy_arn = aws_iam_policy.replication.arn
}

resource "aws_s3_bucket" "destination" {
  provider = aws.east
  bucket   = "cb-c1-test-bucket-west"
  region   = "us-east-1"

  versioning {
    enabled = true
  }
}

resource "aws_s3_bucket" "bucket" {
  provider = aws.east
  bucket   = "cb-c1-test-bucket-east"
  acl      = "private"
  region   = "us-east-1"

  versioning {
    enabled = true
  }

  replication_configuration {
    role = aws_iam_role.replication.arn

    rules {
      id     = "foobar"
      prefix = "foo"
      status = "Enabled"

      destination {
        bucket        = aws_s3_bucket.destination.arn
        storage_class = "STANDARD"
      }
    }
  }
}
