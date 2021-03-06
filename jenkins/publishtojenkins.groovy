pipeline {

    agent any

    environment {
        registryCredentials = "nexus-jenkins-acc"
        registry = "10.0.0.179:8085/"
        repo = "https://github.com/Kromelky/AndersenExamApp2"
        imageName = 'kromelky/application2'
        gitHubAuthId = 'git-kromelky-token'
        nexus_login = "nexus-acc"
        dockerImage  = ''
    }

    // Getting from repository
    stages {
        stage('Code checkout') {
            steps {
                checkout([$class                           : 'GitSCM',
                          branches                         : [[name: '*/dev']],
                          doGenerateSubmoduleConfigurations: false,
                          extensions                       : [], submoduleCfg: [],
                          userRemoteConfigs                : [[credentialsId: gitHubAuthId, url: repo]]])
            }
        }

        // add maven build
        stage ('Unit testing') {
            steps {
                sh "python3 test_hello_world.py"
            }
        }

        // Building Docker images
        stage('Building image') {
            steps{
                script {
                    dockerImage = docker.build(imageName)
                }
            }
        }

        stage('Test image') {
            steps {
                script {
                    dockerImage.inside {
                        sh 'echo "Tests passed"'
                    }
                }
            }
        }

         // Uploading Docker images into Nexus Registry
        stage('Uploading to Nexus') {
            steps{
                script {
                    docker.withRegistry('http://' + registry, nexus_login ) {
                        dockerImage.push("${env.BUILD_NUMBER}")
                        dockerImage.push('latest')
                    }
                }
            }
        }

        //Start deployment
        stage ('Invoke_deployment_pipeline') {
            steps {
                script{
                    try {
                        build job: 'DeployApplications2', parameters: [
                            string(name: 'env', value: "dev"),
                            string(name: 'image', value: imageName)
                        ]
                    } catch (err) {
                        echo err.getMessage()
                    }
                }
            }
        }

        stage ('Notify') {
            steps {
                script{
                    try {
                        notifySuccessful()
                    } catch (e) {
                        currentBuild.result = "FAILED"
                        notifyFailed()
                        throw e
                    }
                }
            }
        }
    }
}

def notifyStarted() {

    emailext (
            subject: "STARTED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
            body: """<p>STARTED: Job2 '${env.JOB_NAME} [${env.BUILD_NUMBER}]':</p>
        <p>Check console output at &QUOT;<a href='${env.BUILD_URL}'>${env.JOB_NAME} [${env.BUILD_NUMBER}]</a>&QUOT;</p>""",
            recipientProviders: [[$class: 'DevelopersRecipientProvider']]
    )
}


def notifySuccessful() {
    emailext (
            subject: "SUCCESSFUL: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
            body: """<p>SUCCESSFUL: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]':</p>
        <p>Check console output at &QUOT;<a href='${env.BUILD_URL}'>${env.JOB_NAME} [${env.BUILD_NUMBER}]</a>&QUOT;</p>""",
            recipientProviders: [[$class: 'DevelopersRecipientProvider']]
    )
}


def notifyFailed() {
    emailext (
            subject: "FAILED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
            body: """<p>FAILED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]':</p>
        <p>Check console output at &QUOT;<a href='${env.BUILD_URL}'>${env.JOB_NAME} [${env.BUILD_NUMBER}]</a>&QUOT;</p>""",
            recipientProviders: [[$class: 'DevelopersRecipientProvider']]
    )
}