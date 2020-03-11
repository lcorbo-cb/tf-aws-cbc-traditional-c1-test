#!/usr/bin/env bash


export DEBIAN_FRONTEND=noninteractive
apt-get update

#Install Java
apt-get install openjdk-8-jre git -y

# Create Jenkins Account
useradd -m jenkins
echo -e "jenkins\njenkins\n" | passwd jenkins

# Add SSH key
mkdir /home/jenkins/.ssh
chown jenkins.jenkins /home/jenkins/.ssh/

echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCkU+BRrmVvTOeSj8Uv0bc+h/39eQMvKOjfGcJ0wpOx3AUeH7Xklxh+Gc+/fMCIAIX7I+nQbGdW44yMGVPxzuTl5BT0PXo3AMAAYisS9NB/2bAuf2UYIpetGe1Po5j+U77uYFAOrv1Op6Cq3mjajKDIpvIJh5izqV4no6ZYEFjD6PEd9ouvzeIlCrgsqr/d+NRHmLCLUqWlwxesSSxsPgUU5JYqw7jyZFqOvooQEVuJsV19efx8esF+XA1rCRj5tdVJ+qN4kAllRCvPN5nf7pdrhBMsyl1YKYrlkDExVb9yuwy6hoOUSl5fEJojRoaANhzIHAiQq7Y14Z5Eip7ZgZDy3P9ePfzwoDTdu7AtWDM6ALju6PeI3pbHmrQvxEnqO1uz8SNM9g77ba7LHkSRZmEZHbUTarhdDEoAYux50Bpcy1J5M4lgy+I13j0j4L6zrhSEwxBBzZyk7vjxglHqESrdQGwiZ7afEAQaOWlI9TLiWBCg4pIXEvAFIOck5xeE/iDrvpJGFBahLqRfSNn1r68TA0ms6lDxxWuRrCgpS5VUjEzQ7yc6nrbKgaa1tg1Es+JE4v10qg3rb3fqqYg6L98YjbmqQixfQMkGF3iwNRa/RIbL+FtoFmLI4zykIvMSXQqkKyUYPDYgHMA/7IrmMdD8mTVF+0TkkTHTsvn6FfPnJw== lcorbo@corbo-agent-share-01" >> /home/jenkins/.ssh/authorized_keys
sudo chmod 700 /home/jenkins/.ssh/
sudo chmod 400 /home/jenkins/.ssh/*
chown jenkins:jenkins /home/jenkins/.ssh/authorized_keys
