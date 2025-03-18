#!/bin/bash
# Author: Pascal Haupt
# Script to stop the Typebot pod using Podman

echo "Stopping Typebot stack..."
podman pod stop typebot-pod

echo "Typebot stack has been stopped."
echo "To completely remove the pod: podman pod rm typebot-pod"
