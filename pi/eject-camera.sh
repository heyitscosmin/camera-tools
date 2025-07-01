#!/bin/bash
echo "Safely ejecting Sony A6400 camera..."

# Check if camera is mounted
if ! mount | grep -q "/mnt/camera"; then
    echo "⚠ Camera not mounted"
    exit 0
fi

# Sync data
sync
echo "Syncing data..."

# Try to unmount
if sudo umount /mnt/camera 2>/dev/null; then
    echo "✓ Camera safely ejected. You can now disconnect it."
else
    echo "⚠ Camera is busy. Checking what's using it..."
    
    # Check what's using the mount point
    if command -v fuser >/dev/null; then
        echo "Processes using the camera:"
        sudo fuser -m /mnt/camera 2>/dev/null || echo "No processes found"
    fi
    
    echo ""
    echo "Options:"
    echo "1. Close any file managers or terminals accessing /mnt/camera"
    echo "2. Run: sudo umount -l /mnt/camera (lazy unmount)"
    echo "3. Wait a moment and try again"
    
    read -p "Try lazy unmount now? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        if sudo umount -l /mnt/camera; then
            echo "✓ Camera safely ejected with lazy unmount. You can disconnect it."
        else
            echo "✗ Failed to unmount. Check for processes using the camera."
        fi
    fi
fi
