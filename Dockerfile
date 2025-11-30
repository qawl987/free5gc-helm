FROM bitnamilegacy/mongodb:7.0.9-debian-12-r4
USER root
RUN apt-get update && apt-get install -y tini