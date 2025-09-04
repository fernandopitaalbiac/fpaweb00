# Dockerfile optimizado para OpenJDK 21 y Gradle
FROM eclipse-temurin:21-jdk-alpine as build

WORKDIR /workspace/app

# Copiar archivos de build para cachear dependencias
COPY gradlew .
COPY gradle gradle
COPY build.gradle .
COPY settings.gradle .

# Dar permisos y descargar dependencias
RUN chmod +x gradlew && \
    ./gradlew dependencies --no-daemon

# Copiar código fuente
COPY src src

# Build de la aplicación
RUN ./gradlew build -x test --no-daemon && \
    mkdir -p build/dependency && \
    cd build/dependency && \
    jar -xf ../libs/*.jar

# Fase final de producción
FROM eclipse-temurin:21-jre-alpine

VOLUME /tmp

# Usar usuario no-root
RUN addgroup -S spring && adduser -S spring -G spring
USER spring

ARG DEPENDENCY=/workspace/app/build/dependency

COPY --from=build ${DEPENDENCY}/BOOT-INF/lib /app/lib
COPY --from=build ${DEPENDENCY}/META-INF /app/META-INF
COPY --from=build ${DEPENDENCY}/BOOT-INF/classes /app

# Ejecutar la aplicación optimizada para containers
ENTRYPOINT ["java", \
    "-cp", "app:app/lib/*", \
    "-XX:+UseContainerSupport", \
    "-XX:MaxRAMPercentage=75.0", \
    "com.fpa.fpaweb00.Fpaweb00Application"]