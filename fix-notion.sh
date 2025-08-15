#!/usr/bin/env bash
# Fix for Notion blank window issue on NixOS
# This script provides debugging information and testing for Notion

echo "=== NixOS Notion Fix Diagnostic ==="
echo ""

echo "1. Checking current Notion installation..."
if command -v notion-app &> /dev/null; then
    echo "✓ notion-app is installed"
    notion-app --version 2>/dev/null || echo "  (Version info not available)"
elif command -v notion-app-enhanced &> /dev/null; then
    echo "⚠ notion-app-enhanced is installed (problematic version)"
    echo "  This version is known to have blank window issues"
else
    echo "✗ No Notion app found"
fi

echo ""
echo "2. Checking GPU and hardware acceleration..."
if [ -e /dev/dri/card0 ]; then
    echo "✓ GPU device found: /dev/dri/card0"
else
    echo "✗ No GPU device found"
fi

if [ -e /dev/dri/renderD128 ]; then
    echo "✓ Render device found: /dev/dri/renderD128"
else
    echo "✗ No render device found"
fi

echo ""
echo "3. Checking VA-API support..."
if command -v vainfo &> /dev/null; then
    echo "✓ vainfo command available"
    vainfo 2>/dev/null | head -5 || echo "  VA-API info not available"
else
    echo "⚠ vainfo not found (install libva-utils)"
fi

echo ""
echo "4. Environment variables for Electron apps:"
echo "LIBVA_DRIVER_NAME: ${LIBVA_DRIVER_NAME:-not set}"
echo "ELECTRON_IS_DEV: ${ELECTRON_IS_DEV:-not set}"

echo ""
echo "5. Testing Notion launch..."
if command -v notion-app &> /dev/null; then
    echo "Attempting to launch Notion with fix flags..."
    echo "Command: notion-app --no-sandbox --disable-gpu-sandbox --disable-dev-shm-usage --disable-software-rasterizer --disable-features=VizDisplayCompositor"
    echo ""
    echo "If Notion shows a blank window, this should fix it."
    echo "Press Ctrl+C to cancel, or Enter to test launch..."
    read -r
    notion-app --no-sandbox --disable-gpu-sandbox --disable-dev-shm-usage --disable-software-rasterizer --disable-features=VizDisplayCompositor &
    NOTION_PID=$!
    echo "Notion launched with PID: $NOTION_PID"
    echo "Check if the window displays content properly."
    echo "Press Enter to kill the test instance..."
    read -r
    kill $NOTION_PID 2>/dev/null
else
    echo "notion-app not found. Apply the NixOS configuration first."
fi

echo ""
echo "=== Instructions ==="
echo "1. Apply the NixOS configuration changes:"
echo "   cd /home/aural/Code/nixos"
echo "   sudo nixos-rebuild switch"
echo ""
echo "2. Apply home-manager changes:"
echo "   home-manager switch"
echo ""
echo "3. Restart your desktop session or reboot"
echo ""
echo "4. Launch Notion from the application menu"
echo ""
echo "The key fixes applied:"
echo "- Switched from notion-app-enhanced to notion-app (more stable)"
echo "- Added Electron launch flags to disable problematic GPU features"
echo "- Set proper environment variables for AMD GPU"
echo "- Added VA-API libraries for hardware acceleration"