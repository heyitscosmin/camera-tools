#!/bin/bash

# Remote Camera Ejection Script for Mac mini
# This script connects to Raspberry Pi and executes eject-camera.sh

# Configuration - Update these values for your setup
PI_USER="cosmin"
PI_HOST="192.168.1.3"  # Your Raspberry Pi's IP address
PI_PORT="22"             # SSH port (default is 22)

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}🔌 Remote Camera Ejection Script${NC}"
echo "Connecting to Raspberry Pi to eject Sony A6400 camera..."
echo ""

# Check if SSH key exists, if not, warn about password requirement
if [ ! -f ~/.ssh/id_rsa ] && [ ! -f ~/.ssh/id_ed25519 ]; then
    echo -e "${YELLOW}⚠️  No SSH key found. You may need to enter your password.${NC}"
    echo ""
fi

# Function to check if Pi is reachable
check_pi_connection() {
    echo "Checking connection to Raspberry Pi..."
    if ping -c 1 -W 3000 "$PI_HOST" > /dev/null 2>&1; then
        echo -e "${GREEN}✓ Raspberry Pi is reachable${NC}"
        return 0
    else
        echo -e "${RED}✗ Cannot reach Raspberry Pi at $PI_HOST${NC}"
        return 1
    fi
}

# Function to execute remote command
execute_remote_command() {
    echo "Executing eject-camera.sh on Raspberry Pi..."
    echo "----------------------------------------"
    
    # Execute the remote command
    ssh -p "$PI_PORT" -o ConnectTimeout=10 -o StrictHostKeyChecking=no "$PI_USER@$PI_HOST" '~/eject-camera.sh'
    
    local exit_code=$?
    echo "----------------------------------------"
    
    if [ $exit_code -eq 0 ]; then
        echo -e "${GREEN}✓ Command executed successfully${NC}"
        echo ""
        echo "Your Sony A6400 camera has been ejected."
    else
        echo -e "${RED}✗ Command failed with exit code $exit_code${NC}"
        echo ""
        echo "Possible issues:"
        echo "• Camera not connected to Raspberry Pi"
        echo "• SSH connection failed"
        echo "• eject-camera.sh script not found"
    fi
    
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
    echo -e "${RED}Please check:${NC}"
    echo "• Raspberry Pi is powered on"
    echo "• Network connection is working"
    echo "• IP address is correct: $PI_HOST"
    echo ""
    echo "To update the IP address, edit this script and change PI_HOST variable"
    exit 1
fi

echo ""
echo -e "${YELLOW}💡 Tip: You can also create SSH key for passwordless login:${NC}"
echo "ssh-keygen -t ed25519 -C 'your_email@example.com'"
echo "ssh-copy-id $PI_USER@$PI_HOST"

