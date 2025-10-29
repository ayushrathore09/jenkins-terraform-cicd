pipeline {
    agent any
    environment{
        AWS_DEFAULT_REGION = "us-east-1"
    }
    stages {
        stage('clear workspace'){
            steps{
                cleanWs()
            }
        }

        stage('Download latest state if available') {
            steps {
                script {
                    try {
                        echo "Attempting to download latest Terraform state..."
                        copyArtifacts projectName: 'Terraform-apply', selector: lastSuccessful()
                        echo "State file copied successfully."
                    } catch (Exception e) {
                        echo "No previous state found — starting fresh deployment."
                    }
                }
            }
        }      

        stage('code checkout'){
            steps{
                git url: "https://github.com/ayushrathore09/jenkins-terraform-cicd.git", branch: "master"
            }
        }

        stage('Prepare the SSH Key'){
            steps{
                echo "copying ssh key to the workspace"
                sh 'cp /var/lib/jenkins/.ssh/id_ed25519.pub .'
                sh 'chmod 644 id_ed25519.pub'
                sh 'ls -l'
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
                sh 'ls -l'
                //archiveArtifacts artifacts: 'tfplan, terraform.tfstate, output_plan.txt, .terraform.lock.hcl', fingerprint: true, onlyIfSuccessful: true
               archiveArtifacts artifacts: '**', fingerprint: true, onlyIfSuccessful: true // entire workspace archived
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
                build job: 'Terraform-apply', wait: false
            }
        }
    }
}