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
                withCredentials([
                    string(credentialsId: 'aws-access-key', variable: 'AWS_ACCESS_KEY_ID'),
                    string(credentialsId: 'aws-secret-key', variable: 'AWS_SECRET_ACCESS_KEY')
                ]) {
                  sh 'terraform plan -out=tfplan' // this tfplan is a binary file which contains the execution plan
                }
                sh 'terraform show -no-color tfplan > output_plan.txt' // converting binary file to human readable format
                //archiving the tfplan file
                archiveArtifacts artifacts: 'tfplan, output_plan.txt, .terraform.lock.hcl', fingerprint: true, onlyIfSuccessful: true
            }   
        }

        stage('Approval'){
            steps{
                input message: 'Do you want to apply the changes?', ok: 'Apply'
            }
        }

        stage('trigger by code'){
            steps{
                echo "Triggering terraform apply job"
                build job: 'terraform-apply', wait: false
            }
        }
    }
}