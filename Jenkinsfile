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
			          -Dsonar.login=squ_7c11429c82fede8c7f4d20ebba9ca738b52f0c6f"
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
		                                        def remote = [:]
                                                        remote.name = 'jenkins'
                                                        remote.host = '54.176.45.61'
                                                        remote.user = 'jenkins'
                                                        remote.password = 'jenkins'
                                                        remote.allowAnyHosts = true 
		stage('Transfer artifact to Ansible') {
		                                        	
                    steps {
			    sshCommand('rsync -avh  /var/lib/jenkins/workspace/k8s-job/webapp/target/*.war ansadmin@172.31.8.42:/opt/docker/webapp.war')
			   /* sshPublisher(publishers: 
			      [sshPublisherDesc(configName: 'jenkins', 
				  transfers: [sshTransfer(cleanRemote: false, 
				  excludes: '', 
				  execCommand: 'rsync -avh  /var/lib/jenkins/workspace/k8s-job/webapp/target/*.war ansadmin@172.31.8.42:/opt/docker/webapp.war', 
				  execTimeout: 120000, flatten: false, 
				  makeEmptyDirs: false, noDefaultExcludes: false, 
				  patternSeparator: '[, ]+', 
				  remoteDirectory: '', remoteDirectorySDF: false, 
				  removePrefix: '', sourceFiles: '')], 
				  usePromotionTimestamp: false, useWorkspaceInPromotion: false, verbose: true)])*/
                       }
                }
		stage ('Run Ansible Playbook') {
			steps{
			      sshPublisher(publishers: 
				 [sshPublisherDesc(configName: 'ansible', 
				     transfers: [sshTransfer(cleanRemote: false, 
					  excludes: '', execCommand: 'ansible-playbook /sourcecode/demoproject.yml', 
					  execTimeout: 120000, flatten: false, 
					  makeEmptyDirs: false, noDefaultExcludes: false, 
					  patternSeparator: '[, ]+', remoteDirectory: '', 
					  remoteDirectorySDF: false, removePrefix: '', sourceFiles: '')], 
					  usePromotionTimestamp: false, useWorkspaceInPromotion: false, verbose: true)])
                          }
		}
		/*stage('Publish Docker Image to DockerHub') {
                    steps {
			    withDockerRegistry([credentialsID: "dockerHub" , url: ""])	{	    
			     sh 'docker push k2r2t2/demoapp:latest'
			    }
                       }
                }*/
		
	}
}   
