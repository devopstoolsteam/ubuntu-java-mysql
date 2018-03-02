#
# dockerfile - ubuntu 16.04, oracle-java8, mysql-server, maven, awscli
#

# Use ubuntu:16.04 as base image
FROM ubuntu:16.04

MAINTAINER Nagireddy Guduru <dostiharise@gmail.com>

# Install essentials
RUN \
    apt-get update && \
    apt-get install -y build-essential && \
    apt-get install -y software-properties-common && \
    rm -rf /var/lib/apt/lists/*

# Install Java.
RUN \
    echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
    add-apt-repository -y ppa:webupd8team/java && \
    apt-get update && \
    apt-get install -y oracle-java8-installer && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /var/cache/oracle-jdk8-installer

# Define commonly used JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

# Install MySql
ENV DEBIAN_FRONTEND noninteractive

RUN \
    apt-get update && \
    apt-get install -y mysql-server mysql-client && \
    rm -rf /var/lib/apt/lists/*

# Install apache2
RUN \
    apt-get update && \
    apt-get install -y apache2
    
# Install tomcat7
RUN \
    apt-get update && \
    apt-get install -y wget

RUN \
    wget http://www-eu.apache.org/dist/tomcat/tomcat-7/v7.0.85/bin/apache-tomcat-7.0.85.tar.gz && \
    tar xzf apache-tomcat-7.0.85.tar.gz && \
    mv apache-tomcat-7.0.85 /usr/local/tomcat7 && \
    cd /usr/local/tomcat7 && \
    ./bin/startup.sh
    
# DB dump  
ADD dratool_Schema.sql /etc/mysql/dratool_Schema.sql

# Add Warfile in tomcat 
ADD DigitalReadinessAssessmentTool.war /usr/local/tomcat/webapps/

#Place the External Property file 
ADD application.properties /usr/local/tomcat7/
ADD application.properties /usr/local/tomcat7/conf/

# UI code 
#Copy the build into htdocs
COPY DigitalReadinessAssessmentTool_BUILD/ /var/www/html/

#copy httpd.conf file 
#COPY apache2.conf /etc/apache2/apache2.conf
#COPY httpd.conf /usr/local/apache2/conf/httpd.conf

    
    


