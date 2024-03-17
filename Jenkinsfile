pipeline {
    agent any
    environment {
        AWS_DEFAULT_REGION = 'us-east-1'
    }
    stages {
        stage('Setup AWS Credentials') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'ravi_verma_aws'
                ]]) {
                    bat 'aws s3 ls'
                }
            }
        }

        stage('Initialize Terraform') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'ravi_verma_aws'
                ]]) {
                    bat 'cd terraform && terraform init'
                }
            }
        }

        stage('Check and Import DynamoDB Tables') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'ravi_verma_aws'
                ]]) {
                    script {
                        def tables = [
                            [table: "chat_session", resource: "aws_dynamodb_table.chat_session"],
                            [table: "ml_chat_poc_users", resource: "aws_dynamodb_table.ml_chat_poc_users"],
                            [table: "ml_chat_poc_chats", resource: "aws_dynamodb_table.ml_chat_poc_chats"],
                            [table: "ml_chat_poc_messages", resource: "aws_dynamodb_table.ml_chat_poc_messages"]
                        ]

                        tables.each {
                            def tableExists = bat(script: "aws dynamodb describe-table --table-name ${it.table}", returnStatus: true)
                            if (tableExists == 0) {
                                echo "Table ${it.table} exists. Importing..."
                                bat "terraform import ${it.resource} ${it.table}"
                            } else {
                                echo "Table ${it.table} does not exist. No import required."
                            }
                        }
                    }
                }
            }
        }

        stage('Check and Import S3 Bucket') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'ravi_verma_aws'
                ]]) {
                    script {
                        def s3Buckets = [
                            "ai-ian-datalake-test"
                        ]
                        s3Buckets.each { bucketName ->
                            echo "Checking for S3 bucket: ${bucketName}"
                            def bucketExists = bat(script: "aws s3 ls s3://${bucketName}", returnStatus: true)
                            if (bucketExists == 0) {
                                echo "Bucket ${bucketName} exists. Attempting to import..."
                                try {
                                    bat "terraform import aws_s3_bucket.my_bucket ${bucketName}"
                                } catch (Exception e) {
                                    echo "An error occurred during import: ${e.getMessage()}"
                                    echo "Continuing with the pipeline..."
                                }
                            } else {
                                echo "Bucket ${bucketName} does not exist. Skipping import."
                            }
                        }
                    }
                }
            }
        }

        stage('Plan Terraform Changes') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'ravi_verma_aws'
                ]]) {
                    bat 'cd terraform && terraform plan'
                }
            }
        }

        stage('Apply Terraform Changes') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'ravi_verma_aws'
                ]]) {
                    bat 'cd terraform && terraform apply -auto-approve'
                }
            }
        }

        stage('Deploy Serverless Components') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'ravi_verma_aws'
                ]]) {
                    echo "Placeholder for serverless deployment commands."
                    // Add your Serverless Framework deployment commands here
                    // Example: bat 'serverless deploy'
                }
            }
        }
    }
}
