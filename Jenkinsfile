pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "devjesu/petclinic-rest"
        DOCKER_TAG   = "1.0"
        DOCKER_CREDS = "dockerhub-creds"
    }

    stages {

        stage('Checkout Source') {
            steps {
                checkout scm
            }
        }

        stage('Maven Build') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Docker Build') {
            steps {
                sh "docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} ."
            }
        }

        stage('Trivy Image Scan') {
            steps {
                sh """
                  echo '🔍 Trivy scan: LOW & MEDIUM vulnerabilities (allowed)'
                  trivy image --exit-code 0 --severity LOW,MEDIUM ${DOCKER_IMAGE}:${DOCKER_TAG}

                  echo '🚨 Trivy scan: HIGH & CRITICAL vulnerabilities (will fail build)'
                  trivy image --exit-code 1 --severity HIGH,CRITICAL ${DOCKER_IMAGE}:${DOCKER_TAG}
                """
            }
        }

        stage('Docker Push') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: DOCKER_CREDS,
                        usernameVariable: 'DOCKER_USER',
                        passwordVariable: 'DOCKER_PASS'
                    )
                ]) {
                    sh """
                        echo "\$DOCKER_PASS" | docker login -u "\$DOCKER_USER" --password-stdin
                        docker push ${DOCKER_IMAGE}:${DOCKER_TAG}
                    """
                }
            }
        }
    }

    post {
        success {
            echo '✅ CI Pipeline completed successfully!'
        }
        failure {
            echo '❌ CI Pipeline failed due to build or security issues.'
        }
    }
}