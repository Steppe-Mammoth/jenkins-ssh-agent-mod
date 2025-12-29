# mod-jenkins-ssh-agent
- added docker


## docker-compose.yml
```yml
services:
  
  jenkins:
    container_name: jenkins-master
    image: jenkins/jenkins:lts-jdk17
    restart: on-failure
    ports:
      - 127.0.0.1:8080:8080
    volumes:
      - ./jenkins_home:/var/jenkins_home
    networks:
      - jenkins
    deploy:
      resources:
        limits:
          memory: 1.5g

  jenkins-agent-1:
    container_name: jenkins-agent-1
    image: <jenkins-ssh-agent-mod>
    restart: on-failure
    depends_on:
      - jenkins
    environment:
      JENKINS_AGENT_SSH_PUBKEY: <SSH_PUBKEY>  #  PUBKEY мастер ноди, буде збережно в /home/jenkins/.ssh/authorized_keys
    volumes:
      - ./agent_home:/home/jenkins
      - /var/run/docker.sock:/var/run/docker.sock
    networks:
      - jenkins
    # Якщо хостовий docker працює через групу docker - додаємо хостову групу docker до jenkins юзера.
    group_add:
      - "$DOCKER_GID"  # DOCKER_GID=$(getent group docker | cut -d: -f3)
    deploy:
      resources:
        limits:
          memory: 1.5g

networks:
  jenkins:
    driver: bridge
```

## docker login
Увага! Необхідно виконати ручний логін до docker repo
`docker login`