pipeline {
  agent any
  environment { VENV = '.venv' }
  options { timestamps() }

  stages {
    stage('Checkout') {
      steps { checkout scm }
    }

    stage('Setup venv + deps') {
  steps {
    sh '''
      rm -rf ${VENV}
      python3 -m venv ${VENV}
      . ${VENV}/bin/activate
      pip install --upgrade pip
      pip install -r app/requirements.txt
      pip install -U pytest bandit pip-audit ansible
      mkdir -p reports
    '''
  }
}

    stage('Build') {
      steps {
        sh '. ${VENV}/bin/activate; python3 -m pip install -r app/requirements.txt'
      }
    }

    stage('Test') {
      steps {
        sh '. ${VENV}/bin/activate; pytest app/tests --junitxml=reports/pytest.xml || true'
      }
      post {
        always { junit 'reports/pytest.xml' }
      }
    }

    stage('SAST - Bandit') {
      steps {
        sh '. ${VENV}/bin/activate; bandit -r app -x app/tests -f json -o reports/bandit.json --exit-zero'
      }
      post {
        always { archiveArtifacts artifacts: "reports/bandit.json", fingerprint: true, onlyIfSuccessful: false }
      }
    }

    stage('Dependency Scan - pip-audit') {
      steps {
        sh '. ${VENV}/bin/activate; pip-audit -r app/requirements.txt --format=json > reports/pip-audit.json || true'
      }
      post {
        always { archiveArtifacts artifacts: "reports/pip-audit.json", fingerprint: true, onlyIfSuccessful: false }
      }
    }

    stage('Deploy with Ansible') {
      steps {
        sh '. ${VENV}/bin/activate; ansible-playbook ansible/deploy.yml -i ansible/inventory.ini'
      }
    }
  }

  post {
    always { sh 'rm -rf ${VENV} || true' }
  }
}

