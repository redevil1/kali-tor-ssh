# kali-tor-ssh

Run Kali Linux Docker container with SSH accessible through the Tor network as a hidden service.

## Overview

This Docker container provides a Kali Linux environment with SSH server exposed through Tor network, making it accessible via a .onion address without exposing your real IP address.

## Features

- **Kali Linux Rolling**: Latest Kali Linux base image
- **SSH Server**: OpenSSH server pre-configured
- **Tor Hidden Service**: SSH accessible through Tor network
- **Privacy**: Your SSH service is accessible only through Tor, hiding your real IP

## Prerequisites

- Docker installed on your system
- Tor Browser or `torsocks`/`torify` for connecting to the hidden service

## Building the Docker Image

```bash
docker build -t kali-tor-ssh .
```

## Running the Container

```bash
docker run -d --name kali-tor-ssh kali-tor-ssh
```

## Getting Your .onion Address

After starting the container, retrieve your unique .onion address:

```bash
docker logs kali-tor-ssh
```

Look for output similar to:
```
==========================================
Tor Hidden Service is ready!
Your SSH .onion address is:
xxxxxxxxxxxxxxxx.onion
==========================================
```

You can also retrieve it later:

```bash
docker exec kali-tor-ssh cat /var/lib/tor/hidden_service/hostname
```

## Connecting to the SSH Service

### Using torify (Linux/Mac)

Install `torsocks` if not already installed:

```bash
# On Debian/Ubuntu
sudo apt-get install torsocks

# On macOS with Homebrew
brew install torsocks
```

Connect to your container:

```bash
torify ssh root@your-onion-address.onion
```

### Using Tor Browser's SOCKS5 Proxy

Configure SSH to use Tor's SOCKS5 proxy:

```bash
ssh -o ProxyCommand="nc -X 5 -x 127.0.0.1:9050 %h %p" root@your-onion-address.onion
```

Note: Tor Browser must be running for this to work.

## Default Credentials

- **Username**: root
- **Password**: toor

⚠️ **IMPORTANT**: Change the default password immediately after first login!

```bash
# Inside the container
passwd root
```

## Security Considerations

1. **Change Default Password**: The default password `toor` is well-known and insecure.
2. **Use SSH Keys**: Consider using SSH key authentication instead of passwords.
3. **Keep Updated**: Regularly update the container with security patches.
4. **Restrict Access**: The root login is enabled by default; consider creating a non-root user.

## Customization

### Changing the Root Password

Edit the Dockerfile and change this line:

```dockerfile
RUN echo 'root:toor' | chpasswd
```

Replace `toor` with your desired password.

### Adding SSH Keys

You can add your SSH public key to the container:

```bash
docker exec kali-tor-ssh bash -c "echo 'your-public-key-here' >> /root/.ssh/authorized_keys"
```

Or build a custom image with your key:

```dockerfile
# Add this to Dockerfile
COPY your_public_key.pub /root/.ssh/authorized_keys
RUN chmod 600 /root/.ssh/authorized_keys
```

## Persistence

To persist the Tor hidden service (keep the same .onion address):

```bash
docker run -d --name kali-tor-ssh \
  -v tor-hidden-service:/var/lib/tor/hidden_service \
  kali-tor-ssh
```

## Stopping the Container

```bash
docker stop kali-tor-ssh
```

## Removing the Container

```bash
docker rm kali-tor-ssh
```

## Troubleshooting

### Container doesn't start
Check the logs:
```bash
docker logs kali-tor-ssh
```

### Can't connect via SSH
1. Ensure Tor is running on your client machine
2. Verify the .onion address is correct
3. Check if the container is running: `docker ps`
4. Verify services inside the container:
   ```bash
   docker exec kali-tor-ssh service ssh status
   docker exec kali-tor-ssh service tor status
   ```

### .onion address not generated
Wait a few moments and check again. Tor needs time to establish circuits and generate the hidden service.

```bash
docker exec kali-tor-ssh cat /var/lib/tor/hidden_service/hostname
```

## Advanced Usage

### Running Interactive Shell

```bash
docker exec -it kali-tor-ssh /bin/bash
```

### Installing Additional Tools

```bash
docker exec -it kali-tor-ssh apt-get update
docker exec -it kali-tor-ssh apt-get install <package-name>
```

## License

This project is provided as-is for educational and legitimate security research purposes only.

## Disclaimer

This tool is intended for authorized security testing and research purposes only. Users are responsible for ensuring their usage complies with applicable laws and regulations. The authors assume no liability for misuse of this software.
