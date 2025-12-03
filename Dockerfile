# Use Kali Linux as the base image
FROM kalilinux/kali-rolling:latest

# Set environment variables to avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Update and install required packages
RUN apt-get update && \
    apt-get install -y \
    openssh-server \
    tor \
    sudo \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create SSH directory and configure SSH
RUN mkdir /var/run/sshd && \
    mkdir -p /root/.ssh && \
    chmod 700 /root/.ssh

# Configure SSH to allow root login (can be changed based on security requirements)
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Set a default root password (CHANGE THIS IN PRODUCTION!)
RUN echo 'root:toor' | chpasswd

# Create Tor configuration directory
RUN mkdir -p /var/lib/tor/hidden_service && \
    chown -R debian-tor:debian-tor /var/lib/tor/hidden_service && \
    chmod 700 /var/lib/tor/hidden_service

# Configure Tor hidden service for SSH
RUN echo "HiddenServiceDir /var/lib/tor/hidden_service/" >> /etc/tor/torrc && \
    echo "HiddenServicePort 22 127.0.0.1:22" >> /etc/tor/torrc

# Expose SSH port (only accessible via Tor hidden service)
EXPOSE 22

# Copy entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set the entrypoint
ENTRYPOINT ["/entrypoint.sh"]

# Keep container running
CMD ["tail", "-f", "/dev/null"]
