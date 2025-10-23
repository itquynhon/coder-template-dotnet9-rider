FROM mcr.microsoft.com/dotnet/sdk:9.0

RUN apt-get update && apt-get install -y \
    curl wget git unzip openssh-client sudo \
    libxext6 libxrender1 libxtst6 libxi6 libxrandr2 \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m coder && echo "coder ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
USER coder
WORKDIR /home/coder

# SSH deploy key
RUN mkdir -p /home/coder/.ssh && chmod 700 /home/coder/.ssh
COPY id_rsa /home/coder/.ssh/id_rsa
COPY id_rsa.pub /home/coder/.ssh/id_rsa.pub
RUN chmod 600 /home/coder/.ssh/id_rsa
RUN ssh-keyscan github.com >> /home/coder/.ssh/known_hosts

# JetBrains Gateway
RUN mkdir -p ~/.local/bin && \
    curl -fsSL https://download.jetbrains.com/idea/gateway/install-idea-gateway.sh | bash

EXPOSE 22
CMD ["bash"]
