pipeline {
    agent any
    
    stages {
        stage('Build server image') {
            steps {
                script {
                    sh "bash ./test.sh"
                }
            }
        }
    }
}
