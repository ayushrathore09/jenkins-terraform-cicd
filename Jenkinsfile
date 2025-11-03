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
        // by default git plugin clear the workspace before checkout so downloading latest state file must be done after code checkout
        stage('code checkout'){
            steps{
                git url: "https://github.com/ayushrathore09/jenkins-terraform-cicd.git", branch: "master"
            }
        }

        stage('Download latest tfstate if available') {
            steps {
                script {
                    try {
                        echo "Attempting to download latest Terraform state..."
                        copyArtifacts projectName: 'Terraform-apply', selector: lastSuccessful()
                        echo "State file copied successfully."
                        sh 'ls -l'
                        sh 'find $(pwd) -name terraform.tfstate'

                    } catch (Exception e) {
                        echo "No previous state found — starting fresh deployment."
                    }
                }
            }
        }      

        stage('copy the SSH Key to workspace'){
            steps{
                echo "copying ssh key to the workspace"
                sh 'cp /var/lib/jenkins/.ssh/id_ed25519.pub .'
                sh 'chmod 644 id_ed25519.pub'
                sh 'ls -l'
            }
        }
// doing parallel stages for terraform init , tf fmt and tf validate to save time

        stage("terraform init,fmt (parallel)"){
            parallel {
                stage('Terraform Fmt'){
                    steps{
                        echo "formatting terraform code"
                        sh 'terraform fmt -check' // if format is not correct then it will return non zero exit code and fail the build
                    }
                }  

                stage('Terraform Init') {
                    steps{
                        echo "initializing terraform"
                        sh 'terraform init'
                    }
                }
            }
        }
        
        stage('Terraform Validate') { 
            steps{
                echo "validating terraform code"
                sh 'terraform validate'
            }
        } 
        // stage('Terraform Init'){
        //     steps{
        //         echo "initializing terraform"
        //         sh 'terraform init'
        //     }
        // }

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

        stage('trigger tf-apply job'){
            steps{
                echo "Triggering terraform apply job"
                build job: 'Terraform-apply', wait: false
            }
        }
    }
}