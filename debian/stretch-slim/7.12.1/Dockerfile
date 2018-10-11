FROM debian:stretch-slim

MAINTAINER wilkesystems <maintainer@wilke.systems>

ENV JIRA_VERSION 7.12.1
ENV JIRA_HOME /var/atlassian/application-data/jira
ENV JIRA_INSTALL_DIR /opt/atlassian/jira
ARG JIRA_BINARY=https://www.atlassian.com/software/jira/downloads/binary/atlassian-jira-software-${JIRA_VERSION}-x64.bin

ENV MYSQL_CONNECTOR_JAVA_VERSION 5.1.47
ARG MYSQL_CONNECTOR_JAVA=https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-${MYSQL_CONNECTOR_JAVA_VERSION}.tar.gz

RUN apt-get update; \
apt-get install -y ca-certificates curl locales locales-all openssl perl procps ttf-dejavu wget; \
bash -c 'mkdir -m 755 -p /usr/share/atlassian/jira/{driver,install}'; \
curl -sSL ${JIRA_BINARY} -o /usr/share/atlassian/jira/install/atlassian-jira-software-${JIRA_VERSION}-x64.bin; \
chmod +x /usr/share/atlassian/jira/install/atlassian-jira-software-${JIRA_VERSION}-x64.bin; \
curl -sSL ${MYSQL_CONNECTOR_JAVA} | tar xz --directory "/usr/share/atlassian/jira/driver/" --strip-components=1 --no-same-owner \
"mysql-connector-java-${MYSQL_CONNECTOR_JAVA_VERSION}/mysql-connector-java-${MYSQL_CONNECTOR_JAVA_VERSION}-bin.jar"; \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*;

COPY docker-entrypoint.sh /usr/sbin/docker-entrypoint.sh

EXPOSE 8080

WORKDIR ${JIRA_HOME}

CMD ["${JIRA_INSTALL_DIR}/bin/start-jira.sh", "-fg"]

ENTRYPOINT ["docker-entrypoint.sh"]
