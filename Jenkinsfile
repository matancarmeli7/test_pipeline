pipeline {
    agent {
        label  "${env.AGENT_LABEL}"
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
