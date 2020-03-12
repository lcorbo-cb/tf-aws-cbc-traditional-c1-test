
resource "aws_iam_role" "replication_east" {
  name               = "tf-iam-role-replication-east"
  assume_role_policy = file("${path.module}/storage_scripts/aws_iam_role_replication.json")
}

resource "aws_iam_role" "replication_west" {
  name               = "tf-iam-role-replication-west"
  assume_role_policy = file("${path.module}/storage_scripts/aws_iam_role_replication.json")
}

data "template_file" "aws_iam_policy_replication_east" {
  template = file("${path.module}/storage_scripts/aws_iam_policy_replication.json.tpl")
  vars = {
    aws_s3_bucket_bucket_arn      = aws_s3_bucket.east.arn
    aws_s3_bucket_destination_arn = aws_s3_bucket.west.arn
  }
}

data "template_file" "aws_iam_policy_replication_west" {
  template = file("${path.module}/storage_scripts/aws_iam_policy_replication.json.tpl")
  vars = {
    aws_s3_bucket_bucket_arn      = aws_s3_bucket.west.arn
    aws_s3_bucket_destination_arn = aws_s3_bucket.east.arn
  }
}

resource "aws_iam_policy" "replication_west" {
  name   = "tf-iam-role-policy-replication-west"
  policy = data.template_file.aws_iam_policy_replication_west.rendered
}

resource "aws_iam_policy" "replication_east" {
  name   = "tf-iam-role-policy-replication-east"
  policy = data.template_file.aws_iam_policy_replication_east.rendered
}

resource "aws_iam_role_policy_attachment" "replication_east" {
  role       = aws_iam_role.replication_east.name
  policy_arn = aws_iam_policy.replication_east.arn
}

resource "aws_iam_role_policy_attachment" "replication_west" {
  role       = aws_iam_role.replication_west.name
  policy_arn = aws_iam_policy.replication_west.arn
}

resource "aws_s3_bucket" "west" {
  provider = aws.east
  bucket   = "cb-c1-test-bucket-west"
  acl      = "private"
  region   = "us-east-1"

  versioning {
    enabled = true
  }

  replication_configuration {
    role = aws_iam_role.replication_west.arn

    rules {
      id     = "Copy it to east"
      status = "Enabled"

      destination {
        bucket        = aws_s3_bucket.east.arn
        storage_class = "STANDARD"
      }
    }
  }
}

resource "aws_s3_bucket" "east" {
  provider = aws.east
  bucket   = "cb-c1-test-bucket-east"
  acl      = "private"
  region   = "us-east-1"

  versioning {
    enabled = true
  }

  replication_configuration {
    role = aws_iam_role.replication_east.arn

    rules {
      id     = "Copy it to west"
      status = "Enabled"

      destination {
        bucket        = "arn:aws:s3:::cb-c1-test-bucket-west"
        storage_class = "STANDARD"
      }
    }
  }

}
