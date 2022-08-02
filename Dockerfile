FROM tomcat:latest

ADD ./webapp.war /usr/local/tomcat/webapps
