pipeline {
    agent any
    parameters {
        booleanParam(name: 'autoapprove', defaultValue: 'false', description: 'Automatically run apply after generating plan?')
        booleanParam(name: 'destroy', defaultValue: false, description: 'Destroy Terraform build?')
    }
    stages {
        stage("Git - Checkout") {
            steps {
              checkout([$class: 'GitSCM', branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/sstcheuffa/terraform-nodejs-app-dynamodb.git']]])   
            }
        }

        stage("Terraform - Planning > saving plan to tfplan file") {
            when {
                not {
                    equals expected: true, actual: params.destroy
                }
            }
            steps {
                sh 'terraform init  -migrate-state'                
                //sh 'terraform init '                
                sh 'terraform plan -input=false -out tfplan'
                sh 'terraform show -no-color tfplan > tfplan.txt'
            }
        }

        stage("Terraform - Approval") {
            when {
                not {
                    equals expected: true, actual: params.autoapprove
                }
                not {
                    equals expected: true, actual: params.destroy
                }
            }
            steps {
                script {
                    def plan = readFile 'tfplan.txt'
                    input message: "Do you want to apply the plan?", parameters: [text(name: 'Plan', description: 'Please review the plan', defaultValue: plan)]
                }
            }
        }

        stage("Terraform - Deploying the infrastructure and the application") {
            when {
                not {
                    equals expected: true, actual: params.destroy
                }
            }
            steps {
                sh 'terraform apply -input=false tfplan'
            }
        }

        stage("Terraform - Destroying the infrastructure and the application") {
            when {
                    equals expected: true, actual: params.destroy
            }
            
            steps {
                sh 'terraform destroy --auto-approve'
            }
        }
    }
}