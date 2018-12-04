FROM ubuntu:16.04

WORKDIR /usr/local/src

ADD jdk-8u181-linux-x64.tar.gz .
ADD apache-maven-3.5.0-bin.tar.gz .

COPY settings.xml /usr/local/src/apache-maven-3.5.0/conf
COPY sources.list /etc/apt/sources.list

ENV JAVA_HOME /usr/local/src/jdk1.8.0_181 \
    && CLASSPATH $JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar \
    && PATH $PATH:$JAVA_HOME/bin \
    && M2_HOME /usr/local/src/apache-maven-3.5.0 \
    && PATH $PATH:$M2_HOME/binENV \
    && TZ=PRC
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
