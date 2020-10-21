pipeline {
    agent {
        label  "docker-engine"
    }
    
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
