FROM maven:3.8-eclipse-temurin-8 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN sed -i 's/repo.spring.io\/libs-milestone/repo.maven.apache.org\/maven2/g' pom.xml && sed -i 's/http:\/\/repo1.maven.org/https:\/\/repo1.maven.org/g' pom.xml
RUN mvn install:install-file -Dfile=src/main/resources/WEB-INF/lib/jave-1.0.2.jar -DgroupId=lt.jave -DartifactId=jave -Dversion=1.0.2 -Dpackaging=jar && \
    mvn install:install-file -Dfile=src/main/resources/WEB-INF/lib/ip2region-1.2.4.jar -DgroupId=org.lionsoul.ip2region -DartifactId=ip2region -Dversion=1.2.4 -Dpackaging=jar && \
    mvn install:install-file -Dfile=src/main/resources/WEB-INF/lib/mondrian-3.7.0.jar -DgroupId=mondrian -DartifactId=mondrian -Dversion=3.7.0 -Dpackaging=jar
RUN mvn clean package -DskipTests

FROM eclipse-temurin:8-jre
LABEL org.opencontainers.image.source="https://github.com/qzblue/Zhuzhenyu_Question-6"
WORKDIR /app
COPY --from=build /app/target/webim-*.war /app/app.war
EXPOSE 8080
ENTRYPOINT ["java", "-Djava.security.egd=file:/dev/./urandom", "-jar", "/app/app.war"]
