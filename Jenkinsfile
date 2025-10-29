pipeline {
  agent any

  environment {
    IMAGE_NAME = "rahatqadeer/jenkin-demo"
    DOCKER_CRED = "docker-hub-creds"
    EC2_HOST = "54.153.180.154"
    EC2_USER = "ubuntu"
    EC2_KEY = "ec2-ssh-key"
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
          def tag = new Date().format('yyyyMMddHHmmss')
          env.IMAGE_TAG = tag
          bat "docker build -t %IMAGE_NAME%:%IMAGE_TAG% ."
        }
      }
    }

    stage('Push to Docker Hub') {
      steps {
        withCredentials([usernamePassword(credentialsId: "${DOCKER_CRED}", usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
          bat """
            echo %DOCKER_PASS% | docker login -u %DOCKER_USER% --password-stdin
            docker push %IMAGE_NAME%:%IMAGE_TAG%
            docker logout
          """
        }
      }
    }

    stage('Deploy to EC2') {
      steps {
        script {
          withCredentials([sshUserPrivateKey(credentialsId: "${EC2_KEY}", keyFileVariable: 'KEYFILE')]) {
            bat """
              echo Deploying to EC2...
              ssh -o StrictHostKeyChecking=no -i "%KEYFILE%" %EC2_USER%@%EC2_HOST% "docker pull %IMAGE_NAME%:%IMAGE_TAG% && docker stop myapp || true && docker rm myapp || true && docker run -d -p 80:80 --name myapp %IMAGE_NAME%:%IMAGE_TAG%"
              echo Deployment Successful!
            """
          }
        }
      }
    }
  }

  post {
    success {
      echo "✅ Docker image built, pushed, and deployed successfully!"
    }
    failure {
      echo "❌ Build failed!"
    }
  }
}
