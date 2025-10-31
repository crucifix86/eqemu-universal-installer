#!/usr/bin/env bash

#########################################################
# EverQuest Emulator Universal Installer
# Main Installation Script
#########################################################

echo "##########################################################"
echo "#  EverQuest Emulator Universal Installer               #"
echo "#  Supporting Windows and Linux platforms               #"
echo "##########################################################"
echo ""

# Check if running as root on Linux
if [[ "$OSTYPE" == "linux-gnu"* ]] || [[ "$OSTYPE" == "darwin"* ]]; then
    if [[ $EUID -ne 0 ]]; then
        echo "ERROR: This script must be run as root on Linux/Unix systems"
        echo "Please run: sudo ./install.sh"
        exit 1
    fi
fi

# Detect operating system
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "Detected Operating System: Linux"
    echo "Launching Linux installer..."
    echo ""
    bash ./scripts/install_linux.sh
elif [[ "$OSTYPE" == "darwin"* ]]; then
    echo "Detected Operating System: macOS"
    echo "Note: macOS is not officially supported, but Linux installer will be attempted"
    echo ""
    bash ./scripts/install_linux.sh
elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]] || [[ "$OSTYPE" == "win32" ]]; then
    echo "Detected Operating System: Windows"
    echo "Please run install.bat or install.ps1 instead"
    exit 1
else
    echo "ERROR: Unsupported operating system: $OSTYPE"
    exit 1
fi
