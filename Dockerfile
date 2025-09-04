# Dockerfile optimizado para Render
FROM eclipse-temurin:21-jdk-alpine as build

WORKDIR /workspace/app

# Copiar archivos de build primero (para cache)
COPY gradlew .
COPY gradle gradle
COPY build.gradle .
COPY settings.gradle .

# Descargar dependencias
RUN chmod +x gradlew && \
    ./gradlew dependencies --no-daemon

# Copiar código y construir
COPY src src
RUN ./gradlew build -x test --no-daemon

# Fase de producción
FROM eclipse-temurin:21-jre-alpine

WORKDIR /app

# Copiar solo el JAR
COPY --from=build /workspace/app/build/libs/*.jar app.jar

# Usuario no-root
RUN addgroup -S spring && adduser -S spring -G spring
USER spring

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]