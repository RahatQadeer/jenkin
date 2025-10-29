pipeline {
  agent any

  environment {
    IMAGE_NAME = "rahatqadeer/jenkin-demo"
    DOCKER_CRED = "docker-hub-creds"
    EC2_HOST = "54.153.180.154"          // your EC2 public IP
    EC2_USER = "ubuntu"                  // default EC2 username for Ubuntu
    EC2_KEY = "dbfc8dae-57db-4b83-aa77-d57bfc8a8c15"  // Jenkins credentials ID for your PEM key
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
          def tag = new Date().format('yyyyMMddHHmmss')   // unique timestamp tag
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
              plink -ssh -i "%KEYFILE%" %EC2_USER%@%EC2_HOST% "docker pull %IMAGE_NAME%:%IMAGE_TAG% && docker stop myapp || true && docker rm myapp || true && docker run -d -p 80:80 --name myapp %IMAGE_NAME%:%IMAGE_TAG%"
              echo Deployment Successful!
            """
          }
        }
      }
    }
  }

  post {
    success {
      echo "✅ Docker image built, pushed, and deployed successfully: ${IMAGE_NAME}:${IMAGE_TAG}"
    }
    failure {
      echo "❌ Build failed!"
    }
  }
}
