pipeline {
    agent any
    // environment {
    //     AWS_ACCESS_KEY_ID     = credentials('aws-access-key')
    //     AWS_SECRET_ACCESS_KEY = credentials('aws-secret-key')
    //     AWS_DEFAULT_REGION    = "us-east-1"
    // }
    stages {
        // stage('Example') {
        //     steps {
        //         echo 'Hello World'
        //     }
        // }

        stage('code checkout'){
            steps{
                git url: "https://github.com/ayushrathore09/jenkins-terraform-cicd.git", branch: "master"
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