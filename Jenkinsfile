pipeline {

    parameters {
        booleanParam(name: 'autoApprove', defaultValue: false, description: 'Automatically run apply after generating plan?')
    } 
    environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }

    agent any
    stages {
        stage('checkout') {
            steps {
                script {
                    dir("terraform") {
                        git "https://github.com/myaws1478-star/awsinfra.git"
                    }
                }
            }
        }

        stage('Plan') {
            steps {
                // 'cd' and 'terraform' are chained using '&&' in Windows Batch
                bat 'cd terraform && terraform init'
                bat "cd terraform && terraform plan -out tfplan"
                bat 'cd terraform && terraform show -no-color tfplan > tfplan.txt'
            }
        }
        
        stage('Approval') {
            when {
                not {
                    equals expected: true, actual: params.autoApprove
                }
            }

            steps {
                script {
                    // Windows uses backslashes for paths, though Jenkins readFile usually handles forward slashes. 
                    // Adjusted to backslash for native Windows execution consistency.
                    def plan = readFile 'terraform\\tfplan.txt'
                    input message: "Do you want to apply the plan?",
                    parameters: [text(name: 'Plan', description: 'Please review the plan', defaultValue: plan)]
                }
            }
        }

        stage('Apply') {
            steps {
                bat "cd terraform && terraform apply -input=false tfplan"
            }
        }
    }
}
