FROM ubuntu:20.04
ENV DEBIAN_FRONTEND=noninteractive

# Install prerequisites
RUN apt-get update && apt-get install -y \
    fortune-mod \
    cowsay \
    netcat \
    && rm -rf /var/lib/apt/lists/*

# Add /usr/games to PATH (where fortune & cowsay are installed)
ENV PATH="/usr/games:${PATH}"

WORKDIR /app
COPY wisecow.sh .
RUN chmod +x wisecow.sh

EXPOSE 4499
CMD ["./wisecow.sh"]

