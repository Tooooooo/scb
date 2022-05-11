FROM java:8
#FROM openjdk:8-jdk-alpine
MAINTAINER 283127233@qq.com
ARG JAR_FILE
ARG PROJECT_NAME
RUN /bin/sh -c 'echo buyue: $JAR_FILE $PROJECT_NAME'
VOLUME /${PROJECT_NAME}
ADD ${JAR_FILE} app.jar
RUN cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
#RUN apk --no-cache add tzdata && \
#    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
#    echo "Asia/Shanghai" > /etc/timezone
RUN sh -c 'touch /app.jar'
ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-Duser.timezone=GMT+8","-jar","/app.jar"]