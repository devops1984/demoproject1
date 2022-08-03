pipeline {
    agent any
	environment {
	    PATH = "$PATH:/usr/share/maven/bin"
	}
	 stages {
                stage('Maven Build'){
		    steps{
			     sh " mvn clean package"   
			}
		}
		 stage('Sonar Analysis') {
                     steps {
                      withSonarQubeEnv('Sonarqube') {
                             sh " mvn sonar:sonar \
			          -Dsonar.host.url=http://54.183.145.72:9000 \
			          -Dsonar.login=sqa_3c21c782f53425c2ca8158be94c88b0c642c4622"
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
				     groupId: 'com.example.maven-project', 
				     nexusUrl: '51.124.248.36:8081', 
				     nexusVersion: 'nexus3', 
				     protocol: 'http', 
				     repository: 'demo-app', 
				     version: '1.0.0'
			}
		}
		stage('Transfer artifact to Ansible') {                               	
                    steps {
			   sshPublisher(publishers: 
			      [sshPublisherDesc(configName: 'jenkins', 
				  transfers: [sshTransfer(cleanRemote: false, 
				  excludes: '', 
				  execCommand: 'rsync -avh  /var/lib/jenkins/workspace/k8s-job/* --exclude "pom.xml" --exclude "Jenkinsfile" --exclude "demoapp-deploy.yml" --exclude "demoapp-service.yml" --exclude "README.md" --exclude "server"  ansadmin@172.31.8.42:/opt/docker/' ,
				                
				  execTimeout: 120000, flatten: false, 
				  makeEmptyDirs: false, noDefaultExcludes: false, 
				  patternSeparator: '[, ]+', 
				  remoteDirectory: '', remoteDirectorySDF: false, 
				  removePrefix: '', sourceFiles: '')], 
				  usePromotionTimestamp: false, useWorkspaceInPromotion: false, verbose: true)])
                       }
                }
		stage('Transfer artifact to Bootstrap Machine') {                               	
                    steps {
			   sshPublisher(publishers: 
			      [sshPublisherDesc(configName: 'jenkins', 
				  transfers: [sshTransfer(cleanRemote: false, 
				  excludes: '', 
				  execCommand: 'rsync -avh  /var/lib/jenkins/workspace/k8s-job/* --exclude "pom.xml" --exclude "Jenkinsfile" --exclude "create-demoapp-image.yml" --exclude "Dockerfile" --exclude "deployment.yml" --exclude "README.md" --exclude "server" --exclude "service.yml" --exclude "webapp" --exclude "target" deploy@172.31.12.188:/home/deploy/deployment' ,
				                
				  execTimeout: 120000, flatten: false, 
				  makeEmptyDirs: false, noDefaultExcludes: false, 
				  patternSeparator: '[, ]+', 
				  remoteDirectory: '', remoteDirectorySDF: false, 
				  removePrefix: '', sourceFiles: '')], 
				  usePromotionTimestamp: false, useWorkspaceInPromotion: false, verbose: true)])
                       }
                }
		stage ('Docker Image') {
			steps{
			      sshPublisher(publishers: 
				 [sshPublisherDesc(configName: 'ansible', 
				     transfers: [sshTransfer(cleanRemote: false, 
					  excludes: '', execCommand: 'ansible-playbook -i hosts /opt/docker/create-demoapp-image.yml', 
					  execTimeout: 120000, flatten: false, 
					  makeEmptyDirs: false, noDefaultExcludes: false, 
					  patternSeparator: '[, ]+', remoteDirectory: '', 
					  remoteDirectorySDF: false, removePrefix: '', sourceFiles: '')], 
					  usePromotionTimestamp: false, useWorkspaceInPromotion: false, verbose: true)])
                          }
		}
		stage ('Deployment') {
			steps{
			      sshPublisher(publishers: 
				 [sshPublisherDesc(configName: 'ansible', 
				     transfers: [sshTransfer(cleanRemote: false, 
					  excludes: '', execCommand: 'ansible-playbook -i hosts /opt/docker/deployment.yml', 
					  execTimeout: 120000, flatten: false, 
					  makeEmptyDirs: false, noDefaultExcludes: false, 
					  patternSeparator: '[, ]+', remoteDirectory: '', 
					  remoteDirectorySDF: false, removePrefix: '', sourceFiles: '')], 
					  usePromotionTimestamp: false, useWorkspaceInPromotion: false, verbose: true)])
                          }
		}	
	}
}   
