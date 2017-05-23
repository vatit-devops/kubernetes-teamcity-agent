# TeamCity Agent in Kubernetes

Author: Harry Lee

## Introduction

Work in progress!

The purpose of this project is to create a dockerized **TeamCity Agent** that can be deployed on **Kubernetes**. Included in the image is _aws-cli_ and _kubectl_. This project is adapted from the [Official TeamCity Docker Agent](https://github.com/JetBrains/teamcity-docker-agent). The instructions from the official repo is still applicable and should be followed before using this repo.

### Specific Use Case

- You want to implement **CI/CD** using TeamCity with the agent deployed in **Kubernetes**. 
- Your **Kubernetes** cluster is deployed on **AWS**. 
- You are running CI using **docker containers**.
- You want to **build docker images** in docker containers (_Docker in Docker_).
- You want to push docker images to **AWS ECR**.
- Your CI/CD workflow consists of **only** `bash/shell`, `docker`, `kubectl` and `awscli`.

## Included packages

This image differs from the official image in that it is based on the official [OpenJDK image: openjdk:8-jre](https://hub.docker.com/_/openjdk/).

Further, `kubectl` and `awscli` is installed in order to deploy to **Kubernetes** and push images to **AWS ECR**.

## Usage


1. Ensure that you have downloaded the _buildAgent.zip_ installation file following these [instructions](https://confluence.jetbrains.com/display/TCD10/Setting+up+and+Running+Additional+Build+Agents#SettingupandRunningAdditionalBuildAgents-InstallingviaZIPFile).

2. Extract the contents of _buildAgent.zip_ to `dist/buildagent/` in the current directory (where the Dockerfile is) using the following commands:
    ```bash
    mkdir dist
    unzip buildAgent.zip -d dist/buildagent
    mv dist/buildagent/conf dist/buildagent/conf_dist
    ```

3. Build the docker image using:
    ```bash
    docker build -t teamcity-agent .
    ```

4. To run and test the image on your local machine:
    ```bash
    docker run --name=teamcity-agent \
    -e SERVER_URL="http://<value>/" \
    -e DOCKER_IN_DOCKER="start" \
    -e AWS_ACCESS_KEY_ID=<value> \
    -e AWS_SECRET_ACCESS_KEY=<value> \
    -e CLUSTER_NAME=<value> \
    -e USER_NAME=<value> \
    -e MASTER_LOAD_BALANCER=<value> \
    -e S3_BUCKET=<value> \
    -e S3_KEY=<value> \
    --privileged \
    -d teamcity-agent
    ```

