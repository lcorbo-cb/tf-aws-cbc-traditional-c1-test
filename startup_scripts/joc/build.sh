#!/bin/bash
export DEBIAN_FRONTEND=noninteractive
apt-key adv --keyserver keyserver.ubuntu.com --recv 38E2F5F39FF90BDA
echo "deb https://downloads.cloudbees.com/cloudbees-core/traditional/operations-center/rolling/debian binary/" >> /etc/apt/sources.list

apt-get update
apt-get upgrade -y
apt-get install openjdk-8-jre git -y
apt-get install cloudbees-core-oc -y

echo "cloudbees-core-oc soft core unlimited" >> /etc/security/limits.d/30-cloudbees.conf
echo "cloudbees-core-oc hard core unlimited" >> /etc/security/limits.d/30-cloudbees.conf
echo "cloudbees-core-oc soft fsize unlimited" >> /etc/security/limits.d/30-cloudbees.conf
echo "cloudbees-core-oc hard fsize unlimited" >> /etc/security/limits.d/30-cloudbees.conf
echo "cloudbees-core-oc soft nofile 4096" >> /etc/security/limits.d/30-cloudbees.conf
echo "cloudbees-core-oc hard nofile 8192" >> /etc/security/limits.d/30-cloudbees.conf
echo "cloudbees-core-oc soft nproc 30654" >> /etc/security/limits.d/30-cloudbees.conf
echo "cloudbees-core-oc hard nproc 30654" >> /etc/security/limits.d/30-cloudbees.conf

#reboot needed

mkdir -p /var/cache/cloudbees-core-oc/tmp
chown -R cloudbees-core-oc:cloudbees-core-oc /var/cache/cloudbees-core-oc

sed -i 's/HTTP_PORT=8888/HTTP_PORT=8080/g' /etc/default/cloudbees-core-oc
sed -i 's/JENKINS_ARGS="--webroot=/var/cache/$NAME/war --httpPort=$HTTP_PORT"/JENKINS_ARGS="--webroot=/var/cache/$NAME/war --httpPort=$HTTP_PORT --pluginroot=/var/cache/cloudbees-core-oc/plugins"/g' /etc/default/cloudbees-core-oc

echo 'JENKIN_JAVA_HOME="/home/ubuntu"' >> /etc/default/cloudbees-core-oc #with a large local disk area

echo 'JENKINS_JAVA_OPTIONS="-Xms3g -Xmx3g -Djava.awt.headless=true -XX:+AlwaysPreTouch -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=$JENKIN_JAVA_HOME -XX:ErrorFile=$JENKIN_JAVA_HOME/hs_err_%p.log -verbose:gc -Xloggc:$JENKIN_JAVA_HOME/gc-%t.log -XX:NumberOfGCLogFiles=2 -XX:+UseGCLogFileRotation -XX:GCLogFileSize=100m -XX:+PrintGC -XX:+PrintGCDateStamps -XX:+PrintGCDetails -XX:+PrintHeapAtGC -XX:+PrintGCCause -XX:+PrintTenuringDistribution -XX:+PrintReferenceGC -XX:+PrintAdaptiveSizePolicy -XX:+UnlockDiagnosticVMOptions -XX:+LogVMOutput -XX:LogFile=$JENKIN_JAVA_HOME/jvm.log -XX:+UseG1GC -XX:+UseStringDeduplication -XX:+ParallelRefProcEnabled -XX:+DisableExplicitGC -XX:+UnlockExperimentalVMOptions -Dcom.cloudbees.jenkins.ha=false -Dhudson.TcpSlaveAgentListener.hostName=<HOSTNAME> -Dhudson.TcpSlaveAgentListener.port=50000 -Djenkins.model.Jenkins.logStartupPerformance=true -Djava.io.tmpdir=/var/cache/cloudbees-core-oc/tmp -Dcb.BeekeeperProp.noFullUpgrade=true"' >> /etc/default/cloudbees-core-oc

sed -i "s/<HOSTNAME>$HOSTNAME/g" /etc/default/cloudbees-core-oc

reboot
