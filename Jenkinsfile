pipeline {
    agent any
    environment{
        AWS_DEFAULT_REGION = "us-east-1"
    }
    stages {
        stage('code checkout'){
            steps{
                //cleanWs()
                git url: "https://github.com/ayushrathore09/jenkins-terraform-cicd.git", branch: "master"
            }
        }

        stage('Terraform Init'){
            steps{
                echo "initializing terraform"
                sh 'terraform init'
            }
        }

        stage('Terraform Plan'){
            steps{
                echo "Planning terraform"
                sh 'terraform plan -out=tfplan' // this tfplan is a binary file which contains the execution plan
            }
        }
    }
}