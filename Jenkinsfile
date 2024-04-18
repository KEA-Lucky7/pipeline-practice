pipeline {
    agent any

    environment {
        // 환경 변수 설정
        DOCKER_IMAGE = 'nginx-custom'
        DOCKER_TAG = 'latest'
        KUBECONFIG = '~/.kube/config'
        DEPLOYMENT_NAME = 'nginx-deployment'
        NAMESPACE = 'default'
    }

    triggers {
        // SCM 폴링을 통해 주기적인 리포지토리 체크
        pollSCM('H/1 * * * *')  // 매 1분마다 폴링
    }

    stages {
    //     stage('Clone repository') {
    //         steps {
    //             // GitHub에서 코드 클론
    //             git url: 'https://github.com/KEA-Lucky7/pipeline-practice.git', branch: 'main'
    //         }
    //     }

        stage('Build Docker Image') {
            steps {
                script {
                    // Docker 이미지 빌드
                    sh "docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} ."
                }
            }
        }
        stage('Push Docker Image') {
            steps {
                script {
                    // Docker 로그인 (Docker Hub 로그인 정보가 크레덴셜스에 저장되어 있어야 함)
                    withCredentials([usernamePassword(credentialsId: 'dockerhub-jenkins', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                        sh "docker login -u $USERNAME -p $PASSWORD"
                    }
                    // Docker 이미지 푸시
                    sh "docker push ${DOCKER_IMAGE}:${DOCKER_TAG}"
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    // Kubernetes에 배포
                    sh """
                    kubectl --kubeconfig ${KUBECONFIG} set image deployment/${DEPLOYMENT_NAME} nginx-container=${DOCKER_IMAGE}:${DOCKER_TAG} --namespace=${NAMESPACE}
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
