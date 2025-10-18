# Use OpenJDK 11 slim image (multi-arch, works on Intel & Apple Silicon)
FROM openjdk:11-jre-slim

# Set working directory inside container
WORKDIR /opt/app

# Copy the built JAR file into the container
COPY target/spring-boot-web.jar app.jar

# Expose application port
EXPOSE 8080

# Run the Spring Boot application
ENTRYPOINT ["java", "-jar", "app.jar"]
