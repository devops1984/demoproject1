FROM tomcat:latest

ADD /opt/docker/webapp/target/webapp.war /usr/local/tomcat/webapps
