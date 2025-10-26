pipeline {
  agent any

  environment {
    IMAGE_NAME = "rahatqadeer/jenkin-demo"
    DOCKER_CRED = "docker-hub-creds"
  }

  stages {
    stage('Checkout') {
      steps {
        git branch: 'main',
            url: 'https://github.com/RahatQadeer/jenkin.git'
      }
    }

    stage('Build Docker Image') {
      steps {
        script {
          bat 'docker build -t %IMAGE_NAME%:%BUILD_NUMBER% .'
        }
      }
    }

    stage('Push to Docker Hub') {
      steps {
        withCredentials([usernamePassword(credentialsId: "${DOCKER_CRED}", usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
          bat '''
            echo %DOCKER_PASS% | docker login -u %DOCKER_USER% --password-stdin
            docker push %IMAGE_NAME%:%BUILD_NUMBER%
            docker logout
          '''
        }
      }
    }
  }

  post {
    success {
      echo "Docker image pushed successfully: ${IMAGE_NAME}:${BUILD_NUMBER}"
    }
    failure {
      echo "Build failed!"
    }
  }
}
