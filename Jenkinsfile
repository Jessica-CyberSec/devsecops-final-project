pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                sh 'pip install -r app/requirements.txt'
            }
        }
        stage('Test') {
            steps {
                sh 'pytest app/tests'
            }
        }
        stage('SAST - Bandit') {
            steps {
                sh './security/bandit_scan.sh'
            }
        }
        stage('Dependency Scan - pip-audit') {
            steps {
                sh './security/pip_audit.sh'
            }
        }
        stage('Deploy with Ansible') {
            steps {
                sh 'ansible-playbook ansible/deploy.yml -i ansible/inventory.ini'
            }
        }
    }
}

