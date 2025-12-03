#!/bin/bash

# Start SSH service using daemon directly
echo "Starting SSH service..."
/usr/sbin/sshd

# Start Tor service in background as the debian-tor user (fixes ownership warnings)
echo "Starting Tor service as debian-tor..."
# Use su to run tor under the debian-tor account so the hidden_service dir
# (owned by debian-tor) is writable and ownership checks pass.
su -s /bin/sh -c "/usr/bin/tor" debian-tor &

# Wait for Tor to generate the hidden service hostname with retry logic
echo "Waiting for Tor to generate hidden service..."
HOSTNAME_FILE="/var/lib/tor/hidden_service/hostname"
MAX_ATTEMPTS=30
ATTEMPT=0

while [ ! -f "$HOSTNAME_FILE" ] && [ $ATTEMPT -lt $MAX_ATTEMPTS ]; do
    sleep 2
    ATTEMPT=$((ATTEMPT + 1))
    if [ $((ATTEMPT % 5)) -eq 0 ]; then
        echo "Still waiting... (attempt $ATTEMPT/$MAX_ATTEMPTS)"
    fi
done

# Display the onion address
if [ -f "$HOSTNAME_FILE" ]; then
    echo "=========================================="
    echo "Tor Hidden Service is ready!"
    echo "Your SSH .onion address is:"
    cat "$HOSTNAME_FILE"
    echo "=========================================="
    echo "Connect using: torify ssh root@$(cat $HOSTNAME_FILE)"
    echo "Default password: toor (PLEASE CHANGE THIS!)"
    echo "=========================================="
else
    echo "Warning: Hidden service hostname not generated within timeout."
    echo "Check Tor logs for issues: docker exec <container> cat /var/log/tor/log"
fi

# Execute the CMD from Dockerfile or any passed arguments
exec "$@"
