# Quick Start Examples

## Using Docker

Build and run:
```bash
docker build -t kali-tor-ssh .
docker run -d --name kali-tor-ssh kali-tor-ssh
docker logs kali-tor-ssh
```

Get your .onion address:
```bash
docker exec kali-tor-ssh cat /var/lib/tor/hidden_service/hostname
```

## Using Docker Compose

Start the service:
```bash
docker-compose up -d
```

View logs:
```bash
docker-compose logs
```

Get your .onion address:
```bash
docker-compose exec kali-tor-ssh cat /var/lib/tor/hidden_service/hostname
```

Stop the service:
```bash
docker-compose down
```

## Connecting via SSH

With torsocks:
```bash
torify ssh root@your-onion-address.onion
```

With SSH proxy command:
```bash
ssh -o ProxyCommand="nc -X 5 -x 127.0.0.1:9050 %h %p" root@your-onion-address.onion
```

Default password: `toor` (change immediately!)

## Troubleshooting

Check if services are running:
```bash
docker exec kali-tor-ssh service ssh status
docker exec kali-tor-ssh service tor status
```

View all logs:
```bash
docker logs -f kali-tor-ssh
```

Restart the container:
```bash
docker restart kali-tor-ssh
```
