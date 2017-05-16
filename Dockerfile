FROM openjdk:8-jre
MAINTAINER Harry Lee

VOLUME /data/teamcity_agent/conf
ENV CONFIG_FILE /data/teamcity_agent/conf/buildAgent.propertie
LABEL dockerImage.teamcity.version="latest" \
      dockerImage.teamcity.buildNumber="latest"

RUN apt-get update && \
    apt-get install -y software-properties-common && apt-get update && \
    apt-get install -y git apt-transport-https ca-certificates && \
    apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 9DC858229FC7DD38854AE2D88D81803C0EBFCD88 && \
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" && \
    apt-cache madison docker-ce && \
    apt-get update && \
    apt-get install -y docker-ce=17.03.0~ce-0~debian-jessie && \
    apt-get clean all

COPY run-agent.sh /run-agent.sh
COPY run-services.sh /run-services.sh

RUN useradd -m buildagent && \
    chmod +x /run-agent.sh /run-services.sh && sync
RUN usermod -aG docker buildagent

COPY services/run-docker.sh /services/run-docker.sh

COPY dist/buildagent /opt/buildagent

EXPOSE 9090

# Install AWS-CLI
RUN apt-get install -y python-pip && pip install --upgrade awscli

# Install Kubectl
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
COPY kube_tc_build_enroll.sh /kube_tc_build_enroll.sh && chmod +x /kube_tc_build_enroll.sh
COPY services/run-kubectl.sh /services/run-kubectl.sh

CMD ["/run-services.sh"]


# docker run -e SERVER_URL="http://52.51.194.183/" --privileged -e DOCKER_IN_DOCKER="start" -d halosan/teamcity-agent