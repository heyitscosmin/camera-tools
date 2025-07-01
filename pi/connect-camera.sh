#!/bin/bash
echo "Connecting Sony A6400 camera..."
if mount | grep -q "/mnt/camera"; then
    echo "✓ Camera already mounted"
else
    if sudo mount UUID=C493-964A /mnt/camera 2>/dev/null; then
        echo "✓ Camera mounted successfully"
    else
        echo "✗ Camera not found or already mounted"
    fi
fi
ls -la /mnt/camera 2>/dev/null | head -10
