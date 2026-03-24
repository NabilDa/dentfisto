# Stage 1: Build the WAR with Maven
FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline -B
COPY src ./src
RUN mvn package -DskipTests -B

# Stage 2: Deploy to Tomcat
FROM tomcat:10.1-jdk17
# Remove default Tomcat apps
RUN rm -rf /usr/local/tomcat/webapps/*
# Copy our WAR as ROOT so it deploys at /
COPY --from=build /app/target/dentfisto.war /usr/local/tomcat/webapps/ROOT.war
EXPOSE 8080
CMD ["catalina.sh", "run"]
