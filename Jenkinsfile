#!groovy

pipeline {
    agent {
        label "docker"
    }
    options {
        timestamps()
        timeout(time: 3, unit: 'HOURS')
        buildDiscarder(logRotator(numToKeepStr: '30', artifactNumToKeepStr: '5'))
    }
    environment {
        // In case another branch beside master or develop should be deployed, enter it here
        BRANCH_TO_DEPLOY = 'xyz'
        GITHUB_TOKEN = credentials('cdc81429-53c7-4521-81e9-83a7992bca76')
        DISCORD_WEBHOOK = credentials('991ce248-5da9-4068-9aea-8a6c2c388a19')
    }
    parameters {
        string defaultValue: 'latest', description: 'From which version should the image be created?', name: 'SPECTRECOIN_RELEASE', trim: false
        string defaultValue: '2018-10-16', description: 'Which date has the bootstrapped blockchain archive?', name: 'BLOCKCHAIN_ARCHIVE_VERSION', trim: false
    }
    stages {
        stage('Notification') {
            steps {
                discordSend(
                        description: "**Started build of branch $BRANCH_NAME**\n",
                        footer: 'Jenkins - the builder',
                        image: '',
                        link: "$env.BUILD_URL",
                        successful: true,
                        thumbnail: 'https://wiki.jenkins-ci.org/download/attachments/2916393/headshot.png',
                        title: "$env.JOB_NAME",
                        webhookURL: "${DISCORD_WEBHOOK}"
                )
            }
        }
        stage('Build image') {
            steps {
                script {
                    sh "echo IMG_NAME=Spectrecoin > config\n" +
                       "echo SPECTRECOIN_RELEASE=${SPECTRECOIN_RELEASE} >> config\n" +
                       "echo BLOCKCHAIN_ARCHIVE_VERSION=${BLOCKCHAIN_ARCHIVE_VERSION} >> config"
                    sh "touch ./stage4/SKIP ./stage4/SKIP_IMAGES"
                    sh "./build-docker.sh"
                }
            }
        }
        stage('Deploy image') {
            steps {
                script {
                    def CURRENT_DATE = sh(
                            script: "date +%Y-%m-%d",
                            returnStdout: true
                    )
                    sh "docker run \\\n" +
                            "--rm \\\n" +
                            "-it \\\n" +
                            "-e GITHUB_TOKEN=${GITHUB_TOKEN} \\\n" +
                            "-v ${WORKSPACE}/deploy/:/filesToUpload spectreproject/github-deployer:latest \\\n" +
                            "github-release upload \\\n" +
                            "    --user spectrecoin \\\n" +
                            "    --repo spectre \\\n" +
                            "    --tag ${SPECTRECOIN_RELEASE} \\\n" +
                            "    --name \"Spectrecoin-${SPECTRECOIN_RELEASE}-RaspberryPi-RaspbianLight.zip\" \\\n" +
                            "    --file /filesToUpload/image_${CURRENT_DATE}-Spectrecoin-lite.zip \\\n" +
                            "    --replace"
                }
            }
        }
    }
    post {
        success {
            script {
                discordSend(
                        description: "**Build:**  #$env.BUILD_NUMBER\n**Status:**  Success\n",
                        footer: 'Jenkins - the builder',
                        image: '',
                        link: "$env.BUILD_URL",
                        successful: true,
                        thumbnail: 'https://wiki.jenkins-ci.org/download/attachments/2916393/headshot.png',
                        title: "$env.JOB_NAME",
                        webhookURL: "${DISCORD_WEBHOOK}"
                )
            }
        }
        unstable {
            discordSend(
                    description: "**Build:**  #$env.BUILD_NUMBER\n**Status:**  Unstable\n",
                    footer: 'Jenkins - the builder',
                    image: '',
                    link: "$env.BUILD_URL",
                    successful: true,
                    thumbnail: 'https://wiki.jenkins-ci.org/download/attachments/2916393/headshot.png',
                    title: "$env.JOB_NAME",
                    webhookURL: "${DISCORD_WEBHOOK}"
            )
        }
        failure {
            discordSend(
                    description: "**Build:**  #$env.BUILD_NUMBER\n**Status:**  Failed\n",
                    footer: 'Jenkins - the builder',
                    image: '',
                    link: "$env.BUILD_URL",
                    successful: false,
                    thumbnail: 'https://wiki.jenkins-ci.org/download/attachments/2916393/headshot.png',
                    title: "$env.JOB_NAME",
                    webhookURL: "${DISCORD_WEBHOOK}"
            )
        }
    }
}