#!/bin/bash
echo "Safely ejecting Sony A6400 camera (with Samba handling)..."

# Check if camera is mounted
if ! mount | grep -q "/mnt/camera"; then
    echo "⚠ Camera not mounted"
    exit 0
fi

# Sync data
sync
echo "Syncing data..."

# Stop Samba temporarily to release the camera
echo "Temporarily stopping Samba..."
sudo systemctl stop smbd

# Try to unmount
if sudo umount /mnt/camera; then
    echo "✓ Camera safely ejected. You can now disconnect it."
    echo "Restarting Samba..."
    sudo systemctl start smbd
    echo "✓ Samba restarted"
else
    echo "✗ Still couldn't unmount. Using lazy unmount..."
    sudo umount -l /mnt/camera
    echo "✓ Camera ejected with lazy unmount. You can disconnect it."
    echo "Restarting Samba..."
    sudo systemctl start smbd
fi
