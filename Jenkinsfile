pipeline {
    agent any

    environment {
        // 환경 변수 설정
        DOCKER_IMAGE = 'lucky-nginx'
        KUBECONFIG = '~/.kube/config'
        DEPLOYMENT_NAME = 'nginx-deployment'
        NAMESPACE = 'kube-system'
    }

    triggers {
        // SCM 폴링을 통해 주기적인 리포지토리 체크
        pollSCM('H/1 * * * *')  // 매 1분마다 폴링
    }

    stages {
        stage('Build and Push Docker Image') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'dockerhub-jenkins', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                        sh "docker build -t $USERNAME/${DOCKER_IMAGE} ."
                        sh "docker login -u $USERNAME -p $PASSWORD"
                        // Docker 이미지 푸시
                        sh "docker push $USERNAME/${DOCKER_IMAGE}"
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    // Kubernetes에 배포
                    sh """
                    kubectl --kubeconfig ${KUBECONFIG} set image deployment/${DEPLOYMENT_NAME} nginx-container=hyunseoklee99/${DOCKER_IMAGE} --namespace=${NAMESPACE}
                    """
                }
            }
        }

        stage('Check deployment') {
            steps {
                script {
                    // 배포 상태 확인
                    sh "kubectl --kubeconfig ${KUBECONFIG} rollout status deployment/${DEPLOYMENT_NAME} --namespace=${NAMESPACE}"
                }
            }
        }
    }

    post {
        always {
            // 로그 정리나 후처리 작업
            echo 'Pipeline execution complete!'
        }
    }
}
