pipeline {
  agent any
  options { ansiColor('xterm') }
  stages {
    stage('Checkout') {
      steps { checkout scm }
    }
    stage('Set up venv') {
      steps {
        sh '''
          python3 -m venv .venv
          . .venv/bin/activate
          python -m pip install --upgrade pip
          pip install -r app/requirements.txt
        '''
      }
    }
    stage('Unit Tests') {
      steps {
        sh '''
          . .venv/bin/activate
          python -m pytest app/tests -q
        '''
      }
    }
    stage('SAST: Bandit') {
      steps {
        sh '''
          . .venv/bin/activate
          pip install bandit
          bandit -r app
        '''
      }
    }
    stage('Dependency Scan: pip-audit') {
      steps {
        sh '''
          . .venv/bin/activate
          pip install pip-audit
          pip-audit
        '''
      }
    }
    stage('Deploy (Ansible Local)') {
      steps {
        sh '''
          . .venv/bin/activate
          which ansible || (sudo apt-get update && sudo apt-get install -y ansible)
          ansible-playbook ansible/deploy.yml -i ansible/inventory.ini
        '''
      }
    }
  }
  post {
    always {
      archiveArtifacts artifacts: '**/bandit*.txt, **/pip-audit*.txt, **/zap_report.html', allowEmptyArchive: true
    }
  }
}
