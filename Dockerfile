FROM maven:3.6.3-jdk-8 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
COPY lib ./lib
RUN mvn clean package -DskipTests

FROM openjdk:8-jre-alpine
LABEL org.opencontainers.image.source="https://github.com/qzblue/Zhuzhenyu_Question-6"
WORKDIR /app
COPY --from=build /app/target/webim-*.war /app/app.war
EXPOSE 8080
ENTRYPOINT ["java", "-Djava.security.egd=file:/dev/./urandom", "-jar", "/app/app.war"]
