FROM tomcat:latest

COPY /opt/docker/webapp/target/webapp.war /usr/local/tomcat/webapps
