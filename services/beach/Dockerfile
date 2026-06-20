# Build stage
FROM gradle:8.7-jdk21 AS builder

WORKDIR /app

# Copy gradle files
COPY gradle/ gradle/
COPY build.gradle.kts settings.gradle.kts ./

# Copy source code
COPY src/ src/

# Build application using the Gradle binary in the base image
RUN gradle build -x test --no-daemon

# Runtime stage
FROM eclipse-temurin:21-jre-alpine

WORKDIR /app

# Copy jar from builder
COPY --from=builder /app/build/libs/*.jar app.jar

EXPOSE 8081

# Run application
CMD ["java", "-jar", "app.jar"]
