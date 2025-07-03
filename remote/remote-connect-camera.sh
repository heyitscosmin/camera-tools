#!/bin/bash

# Remote Camera Connection Script for Mac mini
# This script connects to Raspberry Pi and executes connect-camera.sh

# Configuration - Update these values for your setup
PI_USER="cosmin"
PI_HOST="192.168.1.3"  # Your Raspberry Pi's IP address
PI_PORT="22"             # SSH port (default is 22)

# Remove color variables
# GREEN='\033[0;32m'
# RED='\033[0;31m'
# YELLOW='\033[1;33m'
# NC='\033[0m' # No Color

echo "🔌 Remote Camera Connection Script"
echo "Connecting to Raspberry Pi to mount Sony A6400 camera..."
echo ""

# Check if SSH key exists, if not, warn about password requirement
if [ ! -f ~/.ssh/id_rsa ] && [ ! -f ~/.ssh/id_ed25519 ]; then
    echo "⚠️  No SSH key found. You may need to enter your password."
    echo ""
fi

# Function to check if Pi is reachable
check_pi_connection() {
    echo "Checking connection to Raspberry Pi..."
    if ping -c 1 -W 3000 "$PI_HOST" > /dev/null 2>&1; then
        echo "✓ Raspberry Pi is reachable"
        return 0
    else
        echo "✗ Cannot reach Raspberry Pi at $PI_HOST"
        return 1
    fi
}

# Function to execute remote command
execute_remote_command() {
    echo "Executing connect-camera.sh on Raspberry Pi"
    echo "----------------------------------------"
    
    # Execute the remote command
    ssh -p "$PI_PORT" -o ConnectTimeout=10 -o StrictHostKeyChecking=no "$PI_USER@$PI_HOST" '~/connect-camera.sh'
    
    local exit_code=$?
    echo "----------------------------------------"    
    return $exit_code
}

# Main execution
echo "Configuration:"
echo "• Raspberry Pi: $PI_USER@$PI_HOST:$PI_PORT"
echo ""

# Check connection first
if check_pi_connection; then
    echo ""
    execute_remote_command
else
    echo ""
    echo "Please check:"
    echo "• Raspberry Pi is powered on"
    echo "• Network connection is working"
    echo "• IP address is correct: $PI_HOST"
    echo ""
    echo "To update the IP address, edit this script and change PI_HOST variable"
    exit 1
fi

echo ""
echo "💡 Tip: You can also create SSH key for passwordless login:"
echo "ssh-keygen -t ed25519 -C 'your_email@example.com'"
echo "ssh-copy-id $PI_USER@$PI_HOST"