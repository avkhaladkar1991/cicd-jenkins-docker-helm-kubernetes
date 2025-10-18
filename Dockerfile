# Use official Eclipse Temurin image for Java 11 (multi-arch: works on Intel & Apple Silicon)
FROM eclipse-temurin:11-jre-alpine

# Set working directory inside container
WORKDIR /opt/app

# Copy the built JAR file into the container
# Make sure your JAR is built in 'target' folder (Maven default)
COPY target/spring-boot-web.jar app.jar

# Expose application port (optional, helpful for readability)
EXPOSE 8080

# Run the Spring Boot application
ENTRYPOINT ["java", "-jar", "app.jar"]
