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

        stage('Checkout GitHub Code') {
            steps {
                checkout([$class: 'GitSCM', branches: [[name: '*/main']], 
                userRemoteConfigs: [[url: 'https://github.com/Rvi851994/serverless_deployment.git']]])
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
    }
}
