pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                sh 'python3 -m pip install --user -r app/requirements.txt'
            }
        }
        stage('Test') {
            steps {
                sh 'python3 -m pytest app/tests'
            }
        }
        stage('SAST - Bandit') {
            steps {
                sh 'python3 -m pip install --user bandit && python3 -m bandit -r app'
            }
        }
        stage('Dependency Scan - pip-audit') {
            steps {
                sh 'python3 -m pip install --user pip-audit && python3 -m pip_audit -r app/requirements.txt'
            }
        }
        stage('Deploy with Ansible') {
            steps {
                sh 'ansible-playbook ansible/deploy.yml -i ansible/inventory.ini'
            }
        }
    }
}


