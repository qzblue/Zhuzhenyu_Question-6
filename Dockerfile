FROM maven:3.8-eclipse-temurin-8 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn install:install-file -Dfile=src/main/resources/WEB-INF/lib/jave-1.0.2.jar -DgroupId=lt.jave -DartifactId=jave -Dversion=1.0.2 -Dpackaging=jar
RUN mvn clean package -DskipTests

FROM eclipse-temurin:8-jre
LABEL org.opencontainers.image.source="https://github.com/qzblue/Zhuzhenyu_Question-6"
WORKDIR /app
COPY --from=build /app/target/webim-*.war /app/app.war
EXPOSE 8080
ENTRYPOINT ["java", "-Djava.security.egd=file:/dev/./urandom", "-jar", "/app/app.war"]
