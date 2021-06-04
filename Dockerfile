  
FROM openjdk:8-jdk-alpine
MAINTAINER kprabhat0123@outlook.com
COPY target/*.jar batch10.jar
ENTRYPOINT ["java","-jar","/batch10.jar"]
EXPOSE 8087
