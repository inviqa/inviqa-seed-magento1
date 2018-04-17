String cron_string = BRANCH_NAME == 'master' ? 'H H * * *' : ''

pipeline {
    agent {
        label 'vmbuild'
    }

    triggers {
        cron cron_string
    }

    options {
        buildDiscarder(logRotator(numToKeepStr: '5', artifactNumToKeepStr: '5'))
        disableConcurrentBuilds()
        timeout(time: 1, unit: 'HOURS')
        timestamps()
    }

    stages {
        stage('Plant seed') {
            steps {
                checkout scm

                script {
                    env.PLANTED_PATH = sh(returnStdout: true, script: 'mktemp -d -p "${WORKSPACE}" seed-test-XXXXX').trim()
                }

                // make an available branch for Hem from the current git reference
                sh 'git branch -D ci-test || true'
                sh 'git checkout -b ci-test'

                dir(env.PLANTED_PATH) {
                    deleteDir()
                }

                sh 'hem seed plant "$(basename "${PLANTED_PATH}")" "--seed=${WORKSPACE}" --branch=ci-test --non-interactive'

                dir(env.PLANTED_PATH) {
                    sh 'hem deps gems'
                    sh 'sed -i -e \'/^\\s*ASSETS_S3_BUCKET/d\' docker-compose.yml'
                    sh 'touch docker.env'
                    sh '''python -c "$(cat <<EOF
import sys, yaml
data = yaml.load(sys.stdin)
for service in data['services']:
  data['services'][service].pop('ports', None)
print yaml.dump(data, default_flow_style = False)
EOF
)" < docker-compose.override.yml.dist > docker-compose.override.yml'''
                }
            }
            post {
                failure {
                    dir(env.PLANTED_PATH) {
                        deleteDir()
                    }
                }
            }
        }
        stage('Provision dev environments') {
            parallel {
                stage('Vagrant') {
                    steps {
                        dir(env.PLANTED_PATH) {
                            sh 'eval "$(ssh-agent)" && ssh-add && hem vm rebuild'
                            sh 'hem exec bash -c \'cd tools/vagrant && rake\''
                        }
                    }
                    post {
                        always {
                            dir(env.PLANTED_PATH) {
                                sh 'hem vm destroy'
                            }
                        }
                    }
                }
                stage('Docker Compose (stable tags)') {
                    steps {
                        dir(env.PLANTED_PATH) {
                            sh 'hem exec bash -c \'rake docker:up\''
                        }
                    }
                    post {
                        always {
                            dir(env.PLANTED_PATH) {
                                sh 'hem exec bash -c \'rake docker:down\''
                            }
                        }
                    }
                }
                stage('Docker Compose (latest tags)') {
                    steps {
                        script {
                            env.PLANTED_PATH_LATEST = sh(returnStdout: true, script: 'mktemp -d -p "${WORKSPACE}" seed-test-XXXXX').trim()
                        }

                        sh 'rm -rf "$PLANTED_PATH_LATEST" && cp -r "$PLANTED_PATH" "$PLANTED_PATH_LATEST"'

                        dir(env.PLANTED_PATH_LATEST) {
                            sh 'sed -i -e \'s/^\\(quay.io\\/continuouspipe\\/.*:\\)stable\\s*$/\\1latest/\' docker-compose.yml Dockerfile'
                            sh 'hem exec bash -c \'rake docker:up\''
                        }
                    }
                    post {
                        always {
                            dir(env.PLANTED_PATH_LATEST) {
                                sh 'hem exec bash -c \'rake docker:down\''
                                deleteDir()
                            }
                        }
                    }
                }
            }
            post {
                always {
                    dir(env.PLANTED_PATH) {
                        deleteDir()
                    }
                }
            }
        }
    }
}
