#!/bin/bash
set -euo pipefail

function main {
   # Set Jira user and group
    : ${JIRA_USER:=jira}
    : ${JIRA_GROUP:=jira}

    # Set Jira uid and gid
    : ${JIRA_UID:=999}
    : ${JIRA_GID:=999}

    # Set Jira http port
    : ${JIRA_HTTP_PORT:=8080}

    # Set Jira control port
    : ${JIRA_RMI_PORT:=8005}

    # Set Jira language
    : ${JIRA_LANGUAGE:=en}

    # Set Jira context path
    : ${JIRA_CONTEXT_PATH:=}

    # Setup Jira SSL Opts
    : ${JIRA_SSL_CACERTIFICATE:=}
    : ${JIRA_SSL_CERTIFICATE:=}
    : ${JIRA_SSL_CERTIFICATE_KEY:=}

    # Jira installer
    if [ ! -d ${JIRA_INSTALL_DIR}/.install4j ] || [ ! -d ${JIRA_HOME}/data ]; then
        # Create the response file for Jira
        echo "#install4j response file for JIRA Software ${JIRA_VERSION}" > /usr/share/atlassian/jira/install/response.varfile
        echo "#$(date)" >> /usr/share/atlassian/jira/install/response.varfile
        echo "launch.application\$Boolean=false" >> /usr/share/atlassian/jira/install/response.varfile
        echo "rmiPort\$Long=${JIRA_RMI_PORT}" >> /usr/share/atlassian/jira/install/response.varfile
        echo "app.jiraHome=${JIRA_HOME}" >> /usr/share/atlassian/jira/install/response.varfile
        echo "app.install.service\$Boolean=false" >> /usr/share/atlassian/jira/install/response.varfile
        echo "existingInstallationDir=${JIRA_INSTALL_DIR}" >> /usr/share/atlassian/jira/install/response.varfile
        echo "sys.confirmedUpdateInstallationString=false" >> /usr/share/atlassian/jira/install/response.varfile
        echo "sys.languageId=${JIRA_LANGUAGE}" >> /usr/share/atlassian/jira/install/response.varfile
        echo "sys.installationDir=${JIRA_INSTALL_DIR}" >> /usr/share/atlassian/jira/install/response.varfile
        echo "executeLauncherAction\$Boolean=true" >> /usr/share/atlassian/jira/install/response.varfile
        echo "httpPort\$Long=${JIRA_HTTP_PORT}" >> /usr/share/atlassian/jira/install/response.varfile
        echo "portChoice=custom" >> /usr/share/atlassian/jira/install/response.varfile

        # Start Jira installer
        /usr/share/atlassian/jira/install/atlassian-jira-software-${JIRA_VERSION}-x64.bin -q -varfile /usr/share/atlassian/jira/install/response.varfile

        # Copy the Java Mysql connector
        cp -pr /usr/share/atlassian/jira/driver/mysql-connector-java-5.1.47-bin.jar ${JIRA_INSTALL_DIR}/lib

        # Change ownership of the Java Mysql connector
        chown ${JIRA_USER}:${JIRA_GROUP} ${JIRA_INSTALL_DIR}/lib/mysql-connector-java-5.1.44-bin.jar

        # Change usermod
        usermod -d ${JIRA_HOME} -u ${JIRA_UID} ${JIRA_USER}

        # Change groupmod
        groupmod -g ${JIRA_GID} ${JIRA_GROUP}

        # Change ownership of Jira files 
        chown -R ${JIRA_USER}:${JIRA_GROUP} ${JIRA_HOME} ${JIRA_INSTALL_DIR}

        # SSL configuration
        if [ -f ${JIRA_INSTALL_DIR}/jre/bin/keytool -a -n "${JIRA_SSL_CERTIFICATE}" -a -n "${JIRA_SSL_CERTIFICATE_KEY}" ]; then
            # Add cacerts
            if [ -n "${JIRA_SSL_CACERTIFICATE}" ]; then 
                if [ -f ${JIRA_SSL_CACERTIFICATE} ]; then
                    ${JIRA_INSTALL_DIR}/jre/bin/keytool \
                        -importcert \
                        -noprompt \
                        -alias tomcat \
                        -file ${JIRA_SSL_CACERTIFICATE} \
                        -keystore ${JIRA_INSTALL_DIR}/jre/lib/security/cacerts \
                        -storepass changeit \
                        -keypass changeit
                fi
            fi
            # Activate SSL connector
            if (grep -qn 'Connector port="8443"' ${JIRA_INSTALL_DIR}/conf/server.xml);
            then
                sed -i -e "s/    <Connector port=\"8443\"/--> <Connector port=\"8443\"/g" ${JIRA_INSTALL_DIR}/conf/server.xml
                sed -i -e "s/keystoreFile=\"\(.*\)\"\/>/keystoreFile=\"\1\"\/> <\!--/g" ${JIRA_INSTALL_DIR}/conf/server.xml
            else
                sed -i -e "s/acceptCount=\"100\" disableUploadTimeout=\"true\" bindOnInit=\"false\"\/>/acceptCount=\"100\" disableUploadTimeout=\"true\" bindOnInit=\"false\"\/>\\n\\n        <Connector port=\"8443\" maxThreads=\"150\" minSpareThreads=\"25\" enableLookups=\"false\"\\n                   maxHttpHeaderSize=\"8192\" protocol=\"org.apache.coyote.http11.Http11NioProtocol\" useBodyEncodingForURI=\"true\"\\n                   acceptCount=\"100\" disableUploadTimeout=\"true\" clientAuth=\"false\" scheme=\"https\" secure=\"true\"\\n                   SSLEnabled=\"true\" sslProtocol=\"TLS\" keystoreFile=\"\/var\/atlassian\/application-data\/jira\/.keystore\"\/>/" ${JIRA_INSTALL_DIR}/conf/server.xml
            fi
        fi

        # Set Context Path
        sed -i -e "s/<Context path=\"\"/<Context path=\"${JIRA_CONTEXT_PATH////\\/}\"/g" ${JIRA_INSTALL_DIR}/conf/server.xml
    fi

    # Keystore configuration
    if [ -f ${JIRA_INSTALL_DIR}/jre/bin/keytool -a -n "${JIRA_SSL_CERTIFICATE}" -a -n "${JIRA_SSL_CERTIFICATE_KEY}" ]; then
        if [ -f ${JIRA_HOME}/.keystore ]; then
            rm -f ${JIRA_HOME}/.keystore
        fi

        # Create Keystore
        ${JIRA_INSTALL_DIR}/jre/bin/keytool \
            -genkey \
            -noprompt \
            -alias tomcat \
            -dname "CN=localhost, OU=JIRA, O=Atlassian, L=Sydney, C=AU" \
            -keystore ${JIRA_HOME}/.keystore \
            -storepass changeit \
            -keypass changeit

        # Remove alias 
        ${JIRA_INSTALL_DIR}/jre/bin/keytool \
            -delete \
            -noprompt \
            -alias tomcat \
            -keystore ${JIRA_HOME}/.keystore \
            -storepass changeit \
            -keypass changeit

        if [ -f ${JIRA_SSL_CERTIFICATE} -a -f ${JIRA_SSL_CERTIFICATE_KEY} ]; then
            # Create PKCS12 Keystore
            openssl pkcs12 \
                -export \
                -in ${JIRA_SSL_CERTIFICATE} \
                -inkey ${JIRA_SSL_CERTIFICATE_KEY} \
                -out ${JIRA_HOME}/.keystore.p12 \
                -name tomcat \
                -passout pass:changeit

            # Import PKCS12 keystore
            ${JIRA_INSTALL_DIR}/jre/bin/keytool \
                -importkeystore \
                -deststorepass changeit \
                -destkeypass changeit \
                -destkeystore ${JIRA_HOME}/.keystore \
                -srckeystore ${JIRA_HOME}/.keystore.p12 \
                -srcstoretype PKCS12 \
                -srcstorepass changeit

            # Remove PKCS12 Keystore
            rm -f ${JIRA_HOME}/.keystore.p12
        fi

        # Change server configuration
        sed -i -e "s/keystoreFile=\"\(.*\)\"/keystoreFile=\"${JIRA_HOME////\\/}\/.keystore\"/" ${JIRA_INSTALL_DIR}/conf/server.xml

        # Set keystore file permissions
        chown ${JIRA_USER}:${JIRA_GROUP} ${JIRA_HOME}/.keystore
        chmod 600 ${JIRA_HOME}/.keystore
    fi

    # Setup Catalina Opts
    : ${CATALINA_CONNECTOR_PROXYNAME:=}
    : ${CATALINA_CONNECTOR_PROXYPORT:=}
    : ${CATALINA_CONNECTOR_SCHEME:=http}
    : ${CATALINA_CONNECTOR_SECURE:=false}

    : ${CATALINA_OPTS:=}

    CATALINA_OPTS="${CATALINA_OPTS} -DcatalinaConnectorProxyName=${CATALINA_CONNECTOR_PROXYNAME}"
    CATALINA_OPTS="${CATALINA_OPTS} -DcatalinaConnectorProxyPort=${CATALINA_CONNECTOR_PROXYPORT}"
    CATALINA_OPTS="${CATALINA_OPTS} -DcatalinaConnectorScheme=${CATALINA_CONNECTOR_SCHEME}"
    CATALINA_OPTS="${CATALINA_OPTS} -DcatalinaConnectorSecure=${CATALINA_CONNECTOR_SECURE}"

    export CATALINA_OPTS

    ARGS="-fg"

    # Start Jira as the correct user.
    if [ "${UID}" -eq 0 ]; then
        echo "User is currently root. Will change directory ownership to ${JIRA_USER}:${JIRA_GROUP}, then downgrade permission to ${JIRA_USER}"
        PERMISSIONS_SIGNATURE=$(stat -c "%u:%U:%a" "${JIRA_HOME}")
        EXPECTED_PERMISSIONS=$(id -u ${JIRA_USER}):${JIRA_USER}:700
        if [ "${PERMISSIONS_SIGNATURE}" != "${EXPECTED_PERMISSIONS}" ]; then
            echo "Updating permissions for JIRA_HOME"
            chmod -R 700 "${JIRA_HOME}"
            chown -R "${JIRA_USER}:${JIRA_GROUP}" "${JIRA_HOME}"
        fi
        # Now drop privileges
        exec su -s /bin/bash ${JIRA_USER} -c "${JIRA_INSTALL_DIR}/bin/start-jira.sh ${ARGS}"
    else
        exec "${JIRA_INSTALL_DIR}/bin/start-jira.sh ${ARGS}"
    fi
}

main "$@"

exit
