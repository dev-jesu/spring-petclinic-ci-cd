FROM eclipse-temurin:21-jre

WORKDIR /app

COPY target/spring-petclinic-rest-3.4.3.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java","-jar","app.jar"]