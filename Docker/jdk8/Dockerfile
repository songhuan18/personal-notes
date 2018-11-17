FROM ubuntu:16.04

WORKDIR /usr/local/src

ADD jdk-8u181-linux-x64.tar.gz .

ENV JAVA_HOME /usr/local/src/jdk1.8.0_181
ENV CLASSPATH $JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
ENV PATH $PATH:$JAVA_HOME/bin

ADD apache-maven-3.5.0-bin.tar.gz .

COPY settings.xml /usr/local/src/apache-maven-3.5.0/conf
ENV M2_HOME /usr/local/src/apache-maven-3.5.0
ENV PATH $PATH:$M2_HOME/bin

COPY . /build/
WORKDIR /build
RUN mvn package -DskipTests=true
VOLUME /tmp
ARG JAR_FILE
RUN mv /build/${JAR_FILE} /app.jar
ADD run-java.sh /
RUN chmod +x /run-java.sh
EXPOSE 8080
ENTRYPOINT ["/run-java.sh"]
