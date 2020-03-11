#!/bin/bash
export DEBIAN_FRONTEND=noninteractive
apt-key adv --keyserver keyserver.ubuntu.com --recv 38E2F5F39FF90BDA
echo "deb https://downloads.cloudbees.com/cloudbees-core/traditional/client-master/rolling/debian binary/" >> /etc/apt/sources.list

apt-get update
apt-get upgrade -y
apt-get install openjdk-8-jre git -y
apt-get install cloudbees-core-cm -y


echo "cloudbees-core-cm soft core unlimited" >> /etc/security/limits.d/30-cloudbees.conf
echo "cloudbees-core-cm hard core unlimited" >> /etc/security/limits.d/30-cloudbees.conf
echo "cloudbees-core-cm soft fsize unlimited" >> /etc/security/limits.d/30-cloudbees.conf
echo "cloudbees-core-cm hard fsize unlimited" >> /etc/security/limits.d/30-cloudbees.conf
echo "cloudbees-core-cm soft nofile 4096" >> /etc/security/limits.d/30-cloudbees.conf
echo "cloudbees-core-cm hard nofile 8192" >> /etc/security/limits.d/30-cloudbees.conf
echo "cloudbees-core-cm soft nproc 30654" >> /etc/security/limits.d/30-cloudbees.conf
echo "cloudbees-core-cm hard nproc 30654" >> /etc/security/limits.d/30-cloudbees.conf

#reboot needed

mkdir -p /var/cache/cloudbees-core-cm/tmp
chown -R cloudbees-core-cm:cloudbees-core-cm /var/cache/cloudbees-core-cm

sed -i 's/HTTP_PORT=8888/HTTP_PORT=8080/g' /etc/default/cloudbees-core-cm
sed -i 's/JENKINS_ARGS="--webroot=/var/cache/$NAME/war --httpPort=$HTTP_PORT"/JENKINS_ARGS="--webroot=/var/cache/$NAME/war --httpPort=$HTTP_PORT --pluginroot=/var/cache/cloudbees-core-cm/plugins"/g' /etc/default/cloudbees-core-cm

echo 'JENKIN_JAVA_HOME="/home/ubuntu"' >> /etc/default/cloudbees-core-cm #with a large local disk area

echo 'JENKINS_JAVA_OPTIONS="-Xms3g -Xmx3g -Djava.awt.headless=true -XX:+AlwaysPreTouch -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=$JENKIN_JAVA_HOME -XX:ErrorFile=$JENKIN_JAVA_HOME/hs_err_%p.log -verbose:gc -Xloggc:$JENKIN_JAVA_HOME/gc-%t.log -XX:NumberOfGCLogFiles=2 -XX:+UseGCLogFileRotation -XX:GCLogFileSize=100m -XX:+PrintGC -XX:+PrintGCDateStamps -XX:+PrintGCDetails -XX:+PrintHeapAtGC -XX:+PrintGCCause -XX:+PrintTenuringDistribution -XX:+PrintReferenceGC -XX:+PrintAdaptiveSizePolicy -XX:+UnlockDiagnosticVMOptions -XX:+LogVMOutput -XX:LogFile=$JENKIN_JAVA_HOME/jvm.log -XX:+UseG1GC -XX:+UseStringDeduplication -XX:+ParallelRefProcEnabled -XX:+DisableExplicitGC -XX:+UnlockExperimentalVMOptions -Dcom.cloudbees.jenkins.ha=false -Dhudson.TcpSlaveAgentListener.hostName=<HOSTNAME> -Dhudson.TcpSlaveAgentListener.port=50000 -Djenkins.model.Jenkins.logStartupPerformance=true -Djava.io.tmpdir=/var/cache/cloudbees-core-cm/tmp -Dcb.BeekeeperProp.noFullUpgrade=true"' >> /etc/default/cloudbees-core-cm

sed -i "s/<HOSTNAME>$HOSTNAME/g" /etc/default/cloudbees-core-cm

reboot
