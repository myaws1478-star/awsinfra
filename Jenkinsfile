pipeline {

    parameters {
        booleanParam(name: 'autoApprove', defaultValue: false, description: 'Automatically run apply after generating plan?')
    } 
    environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        TERRAFORM_EXE         = 'D:\\User Data\\terraform\\terraform_1.3.9_windows_amd64\\terraform.exe'
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
                bat 'cd terraform && "%TERRAFORM_EXE%" init'
                bat 'cd terraform && "%TERRAFORM_EXE%" plan -out tfplan'
                bat 'cd terraform && "%TERRAFORM_EXE%" show -no-color tfplan > tfplan.txt'
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
                bat 'cd terraform && "%TERRAFORM_EXE%" apply -input=false tfplan'
            }
        }
    }
}
