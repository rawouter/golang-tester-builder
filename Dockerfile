# Replacing the original centurylink/golang-builder build script to support debugger flags

FROM centurylink/golang-builder

RUN wget -nv https://get.docker.com/builds/Linux/x86_64/docker-1.8.3 -O /usr/bin/docker && \
  chmod +x /usr/bin/docker


COPY test_and_build.sh /

ENTRYPOINT ["/test_and_build.sh"]
