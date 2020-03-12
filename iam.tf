resource "aws_iam_policy" "cap1_test" {
  name        = "cap1_test_1"
  description = "cap1_test"

  policy = <<EOF
{
      "Version": "2012-10-17",
      "Statement": [
          {
              "Action": [
                  "s3:ListAllMyBuckets"
              ],
              "Effect": "Allow",
              "Resource": "arn:aws:s3:::*"
          },
          {
              "Action": "s3:*",
              "Effect": "Allow",
              "Resource": [
                  "arn:aws:s3:::cb-c1-test-bucket-east",
                  "arn:aws:s3:::cb-c1-test-bucket-east/*",
                  "arn:aws:s3:::cb-c1-test-bucket-west",
                  "arn:aws:s3:::cb-c1-test-bucket-west/*"
              ]
          }
      ]
}
EOF
}


resource "aws_iam_instance_profile" "s3_plugin_test_ec2" {
  name = "s3_plugin_test_ec2_test_2"
  role = aws_iam_role.s3_plugin_test_ec2.name
}


resource "aws_iam_role" "s3_plugin_test_ec2" {
  name = "s3_plugin_test_ec2_test"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "ec2.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
}
EOF
}

resource "aws_iam_policy_attachment" "s3_plugin_test_ec2_attachment" {
  name       = "s3_plugin_test_ec2_attachment"
  roles      = [aws_iam_role.s3_plugin_test_ec2.name]
  policy_arn = aws_iam_policy.cap1_test.arn
}
