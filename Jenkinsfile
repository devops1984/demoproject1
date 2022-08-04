pipeline {
    agent any
	environment {
	    PATH = "$PATH:/usr/share/maven/bin"
	    imagename = "k2r2t2/demoproject"
	    dockerImage = ""	
	}
	 stages {
                stage('Maven Build'){
		    steps{
			     sh " mvn clean package -Dv=${BUILD_NUMBER}"   
			}
		}
		 stage('Sonar Analysis') {
                     steps {
                      withSonarQubeEnv('Sonarqube') {
                               sh " mvn sonar:sonar \
			       Dsonar.host.url=http://54.183.145.72:9000 \
			       Dsonar.login=sqa_89d8d3702cc95b24efc28fdcff0c8494fa83fbd2"
			         
                             }
                     }
               }
		stage('Upload War to Nexus'){
		    steps{
			     nexusArtifactUploader artifacts: [
				     [
					     artifactId: 'webapp', 
					     classifier: '', 
					     file: 'webapp/target/webapp.war', 
					     type: 'war'
				     ]
			     ], 
				     credentialsId: 'NEXUS3', 
				     groupId: 'com.example.demo-project', 
				     nexusUrl: '51.124.248.36:8081', 
				     nexusVersion: 'nexus3', 
				     protocol: 'http', 
				     repository: 'demo-app', 
				     version: '1.0.${BUILD_NUMBER}'
			}
		}
		stage('Build Image') {                               	
                    steps {
			    script {
				 dockerImage = docker.build imagename
			    }
                       }
                }
		stage('Push Image') {   
			environment {
				registryCredential = 'dockerhub'
			}
                    steps {
			    script {
				    docker.withRegistry( 'https://registry.hub.docker.com' , registryCredential ){
					    dockerImage.push("latest")
				    }
			    }   
                       }
                }
		stage ('Deployment') {
			steps{
				script{
				    kubernetesDeploy(configs: "deployment.yml", kubeconfigId: "kubernetes")
                          }
		}	
	}
    }   
}
