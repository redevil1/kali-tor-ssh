#!/bin/bash

# Start SSH service
echo "Starting SSH service..."
service ssh start

# Start Tor service
echo "Starting Tor service..."
service tor start

# Wait for Tor to generate the hidden service hostname
echo "Waiting for Tor to generate hidden service..."
sleep 10

# Display the onion address
if [ -f /var/lib/tor/hidden_service/hostname ]; then
    echo "=========================================="
    echo "Tor Hidden Service is ready!"
    echo "Your SSH .onion address is:"
    cat /var/lib/tor/hidden_service/hostname
    echo "=========================================="
    echo "Connect using: torify ssh root@$(cat /var/lib/tor/hidden_service/hostname)"
    echo "Default password: toor (PLEASE CHANGE THIS!)"
    echo "=========================================="
else
    echo "Warning: Hidden service hostname not found yet. It may take a few moments to generate."
fi

# Execute the CMD from Dockerfile or any passed arguments
exec "$@"
