# Stage 0: Get the docker binary (docker:29.1.3-cli 2025-12-18)
FROM docker:29.1.3-cli AS docker_cli

# Stage 1: Build the Jenkins agent image
FROM jenkins/ssh-agent:jdk17

USER root


# SSH home directory setup (permissions look good)
RUN mkdir -p /home/jenkins/.ssh && \
    chown -R jenkins:jenkins /home/jenkins && \
    chmod 700 /home/jenkins/.ssh


# Copy the docker CLI binary from Stage 0 into this image
COPY --from=docker_cli /usr/local/bin/docker /usr/local/bin/docker


# SSH hardening (тільки ключі, root не логіниться)
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config


USER jenkins
