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
  agent any
  environment { VENV = '.venv' }
  options { ansiColor('xterm'); timestamps() }

  stages {
    stage('Checkout') {
      steps { checkout scm }
    }

    stage('Setup venv + deps') {
      steps {
        sh '''
          python3 -m venv ${VENV}
          . ${VENV}/bin/activate
          pip install --upgrade pip
          sh 'python3 -m pip install --user -r app/requirements.txt'
          pip install pytest bandit pip-audit ansible
        '''
      }
    }

    stage('Test') {
      steps {
        sh '''
          . ${VENV}/bin/activate
          pytest app/tests
        '''
      }
    }

    stage('SAST - Bandit') {
      steps {
        sh '''
          . ${VENV}/bin/activate
          bandit -r app
        '''
      }
    }

    stage('Dependency Scan - pip-audit') {
      steps {
        sh '''
          . ${VENV}/bin/activate
          pip-audit -r app/requirements.txt
        '''
      }
    }

    stage('Deploy with Ansible') {
      steps {
        sh '''
          . ${VENV}/bin/activate
          ansible-playbook ansible/deploy.yml -i ansible/inventory.ini
        '''
      }
    }
  }

  post {
    always {
      sh 'rm -rf ${VENV} || true'
    }
  }
}


