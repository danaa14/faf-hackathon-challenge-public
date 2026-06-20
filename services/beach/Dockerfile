# Build stage
FROM gradle:8.7-jdk21 AS builder

WORKDIR /app

# Copy gradle files
COPY gradle/ gradle/
COPY gradlew build.gradle.kts settings.gradle.kts ./

# Build application
RUN ./gradlew build -x test --no-daemon

# Runtime stage
FROM openjdk:21-slim

WORKDIR /app

# Copy jar from builder
COPY --from=builder /app/build/libs/*.jar app.jar

EXPOSE 8081

# Run application
ENTRYPOINT ["java", "-jar", "app.jar"]
