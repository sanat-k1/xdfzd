pipeline {
    agent any
    stages {
        stage('Pre-check Docker') {
            steps {
                script {
                    try {
                        // Check if Docker is installed
                        def dockerVersion = bat(script: 'docker --version', returnStdout: true).trim()
                        if (!dockerVersion) {
                            error "Docker is not installed or not in the PATH. Please install Docker."
                        }

                        // Check if Docker daemon is running
                        def dockerInfo = bat(script: 'docker info', returnStatus: true)
                        if (dockerInfo != 0) {
                            error "Docker daemon is not running. Please start the Docker service."
                        }

                        echo "Docker is available and running: ${dockerVersion}"
                    } catch (Exception e) {
                        error "Pre-check failed: ${e.message}"
                    }
                }
            }
        }
        stage('Setup Workspace') {
    steps {
        script {
            // Assuming files are part of the Git repository
            def workspacePath = env.WORKSPACE

            // Copying files from the workspace (after git checkout)
            bat """
            copy ${workspacePath}\\delivery_metrics.py ${workspacePath}\\
            copy ${workspacePath}\\prometheus.yml ${workspacePath}\\
            copy ${workspacePath}\\alert_rules.yml ${workspacePath}\\
            """
        }
    }
}

        stage('Build Docker Image') {
            steps {
                bat 'docker build -t delivery_metrics .'
            }
        }
        stage('Run Application') {
            steps {
                bat 'docker run -d -p 8000:8000 --name delivery_metrics delivery_metrics'
            }
        }
        stage('Run Prometheus & Grafana') {
            steps {
                bat '''
                docker run -d --name prometheus -p 9090:9090 ^
                  -v %WORKSPACE%\\prometheus.yml:/etc/prometheus/prometheus.yml ^
                  -v %WORKSPACE%\\alert_rules.yml:/etc/prometheus/alert_rules.yml ^
                  prom/prometheus
                docker run -d --name grafana -p 3000:3000 grafana/grafana
                '''
            }
        }
    }
}
