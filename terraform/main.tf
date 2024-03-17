provider "aws" {
  region = "us-east-1"
}

# DynamoDB Table: chat_session
resource "aws_dynamodb_table" "chat_session" {
  name = "chat_session"
  billing_mode = "PROVISIONED"
  read_capacity = 1
  write_capacity = 1
  hash_key = "sid"

  attribute {
    name = "sid"
    type = "S"
  }

  tags = {
    Name = "chat_session"
  }
}

# DynamoDB Table: ml_chat_poc_users
resource "aws_dynamodb_table" "ml_chat_poc_users" {
    name = "ml_chat_poc_users"
    billing_mode = "PROVISIONED"
    read_capacity = 1
    write_capacity = 1
    hash_key = "userId"

    attribute {
      name = "userId"
      type = "S"
    }

    tags = {
      name = "ml_chat_poc_users"
    }
}

# DynamoDB Table: ml_chat_poc_chats
resource "aws_dynamodb_table" "ml_chat_poc_chats" {
    name = "ml_chat_poc_chats"
    billing_mode = "PROVISIONED"
    read_capacity = 1
    write_capacity = 1
    hash_key = "chatId"

    attribute {
      name = "chatId"
      type = "S"
    }

    tags = {
      name = "ml_chat_poc_chats"
    }
}

# DynamoDB Table: ml_chat_poc_messages
resource "aws_dynamodb_table" "ml_chat_poc_messages" {
    name = "ml_chat_poc_messages"
    billing_mode = "PROVISIONED"
    read_capacity = 1
    write_capacity = 1
    hash_key = "messageId"

    attribute {
      name = "messageId"
      type = "S"
    }

    tags = {
      name = "ml_chat_poc_messages"
    }
}

# S3 Bucket: ai-ian-datalake-testing
resource "aws_s3_bucket" "ai_ian_datalake_testing" {
  bucket = "ai-ian-datalake-testing"

  tags = {
    Name = "ai-ian-datalake-testing"
  }
}

# S3 bucket server side encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "ai_ian_datalake_test_server_side_encryption" {
    bucket = aws_s3_bucket.ai_ian_datalake_testing.id

    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
}

# S3 bucket access block
resource "aws_s3_bucket_public_access_block" "ai_ian_datalake_test_public_access_block" {
    bucket = aws_s3_bucket.ai_ian_datalake_testing.id

    block_public_acls   = true
    block_public_policy = true
    ignore_public_acls  = true
    restrict_public_buckets = true
}

# S3 bucket cloudtaril
# resource "aws_cloudtrail" "repay-default" {
#   name = "repay-default"
#   s3_bucket_name = aws_s3_bucket.ai_ian_datalake_testing.id
#   include_global_service_events = true
#   is_multi_region_trail = true
#   enable_logging = true

#   event_selector {
#     read_write_type = "All"
#     include_management_events = true
#     data_resource {
#       type = "AWS::S3::Object"
#       values = ["arn:aws:s3:::repay-default/"]
#     }
#   }
# }

# Attach S3 bucket policy to allow CloudTrail to write logs
resource "aws_s3_bucket_policy" "my_log_bucket_policy" {
  bucket = aws_s3_bucket.ai_ian_datalake_testing.id

  policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Action    = [
          "s3:GetBucketAcl",
          "s3:PutObject"
        ],
        Effect    = "Allow",
        Resource = [
          "${aws_s3_bucket.ai_ian_datalake_testing.arn}",
          "${aws_s3_bucket.ai_ian_datalake_testing.arn}/*"
        ],
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        },
        Sid       = "AWSCloudTrailWrite"
      }
    ]
  })
}
