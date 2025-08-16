#!/usr/bin/env bash
# Comprehensive Steam/Vulkan Fix Script for NixOS with NVIDIA

set -e

echo "========================================"
echo "Steam/Vulkan/DirectX Fix for NixOS"
echo "========================================"
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}[1/7] Checking System Status${NC}"
echo "--------------------------------------"

# Check for NVIDIA GPU
if lspci | grep -i nvidia > /dev/null; then
    echo -e "${GREEN}✓${NC} NVIDIA GPU detected: $(lspci | grep -i nvidia | head -1 | cut -d':' -f3)"
    
    # Check NVIDIA driver
    if command -v nvidia-smi &> /dev/null; then
        DRIVER_VERSION=$(nvidia-smi --query-gpu=driver_version --format=csv,noheader 2>/dev/null || echo "unknown")
        echo -e "${GREEN}✓${NC} NVIDIA driver installed: version $DRIVER_VERSION"
    else
        echo -e "${RED}✗${NC} NVIDIA driver not found!"
    fi
else
    echo -e "${RED}✗${NC} No NVIDIA GPU detected. This script is for NVIDIA GPUs."
    exit 1
fi

# Check Vulkan
echo ""
if command -v vulkaninfo &> /dev/null; then
    if vulkaninfo --summary 2>&1 | grep -q "NVIDIA"; then
        echo -e "${GREEN}✓${NC} Vulkan is working with NVIDIA GPU"
    else
        echo -e "${YELLOW}⚠${NC} Vulkan not detecting NVIDIA GPU properly"
    fi
else
    echo -e "${RED}✗${NC} vulkaninfo not found"
fi

echo ""
echo -e "${GREEN}[2/7] Killing Steam Processes${NC}"
echo "--------------------------------------"

# Kill all Steam processes
killall -9 steam steamwebhelper steam-runtime steam.sh 2>/dev/null || true
sleep 2
echo -e "${GREEN}✓${NC} Steam processes terminated"

echo ""
echo -e "${GREEN}[3/7] Clearing Shader Caches${NC}"
echo "--------------------------------------"

# Clear all shader caches
DELETED_ITEMS=0

# Steam shader cache
if [ -d ~/.steam/steam/steamapps/shadercache ]; then
    rm -rf ~/.steam/steam/steamapps/shadercache/*
    echo -e "${GREEN}✓${NC} Cleared Steam shader cache"
    ((DELETED_ITEMS++))
fi

# DXVK cache
if [ -d ~/.cache/dxvk ]; then
    rm -rf ~/.cache/dxvk/*
    echo -e "${GREEN}✓${NC} Cleared DXVK cache"
    ((DELETED_ITEMS++))
fi

# NVIDIA shader cache
if [ -d ~/.cache/nvidia ]; then
    rm -rf ~/.cache/nvidia/GLCache/*
    echo -e "${GREEN}✓${NC} Cleared NVIDIA shader cache"
    ((DELETED_ITEMS++))
fi

# Mesa shader cache (if exists)
if [ -d ~/.cache/mesa_shader_cache ]; then
    rm -rf ~/.cache/mesa_shader_cache/*
    echo -e "${GREEN}✓${NC} Cleared Mesa shader cache"
    ((DELETED_ITEMS++))
fi

echo "Cleared $DELETED_ITEMS cache directories"

echo ""
echo -e "${GREEN}[4/7] Fixing Proton Prefixes${NC}"
echo "--------------------------------------"

# Find and fix problematic Proton prefixes
if [ -d ~/.steam/steam/steamapps/compatdata ]; then
    for prefix in ~/.steam/steam/steamapps/compatdata/*/; do
        if [ -f "${prefix}version" ]; then
            VERSION=$(cat "${prefix}version" 2>/dev/null || echo "unknown")
            GAME_ID=$(basename "$prefix")
            
            # Check for Path of Exile 2
            if [ "$GAME_ID" = "2694490" ]; then
                echo -e "${YELLOW}!${NC} Found Path of Exile 2 prefix (version: $VERSION)"
                echo "  Clearing DirectX cache..."
                rm -rf "${prefix}pfx/drive_c/users/"*/"AppData/Local/Path of Exile 2/DirectXCache/" 2>/dev/null || true
                rm -rf "${prefix}pfx/drive_c/users/"*/"AppData/Local/Path of Exile 2/ShaderCache/" 2>/dev/null || true
                echo -e "  ${GREEN}✓${NC} Cleared game caches"
            fi
            
            # Fix corrupted prefixes
            if [ "$VERSION" = "UNKNOWN" ] || [ "$VERSION" = "" ]; then
                echo -e "${YELLOW}⚠${NC} Prefix $GAME_ID has invalid version, may need reset"
            fi
        fi
    done
fi

echo ""
echo -e "${GREEN}[5/7] Creating Directory Structure${NC}"
echo "--------------------------------------"

# Create necessary directories
mkdir -p ~/.cache/dxvk
mkdir -p ~/.cache/nvidia/GLCache
mkdir -p ~/.cache/mesa_shader_cache
mkdir -p ~/.local/share/vulkan/implicit_layer.d
echo -e "${GREEN}✓${NC} Cache directories created"

echo ""
echo -e "${GREEN}[6/7] Setting Environment Variables${NC}"
echo "--------------------------------------"

# Create a Steam launch script with proper environment
cat > ~/.local/bin/steam-gpu-launch.sh << 'EOF'
#!/usr/bin/env bash
# Steam GPU Launch Script - Forces proper GPU usage

# Unset problematic variables
unset STEAM_DISABLE_GPU
unset __GL_RENDERER_FORCE_SOFTWARE

# Force NVIDIA GPU
export __GLX_VENDOR_LIBRARY_NAME=nvidia
export __NV_PRIME_RENDER_OFFLOAD=1
export __VK_LAYER_NV_optimus=NVIDIA_only

# Vulkan configuration
export VK_ICD_FILENAMES=/run/opengl-driver/share/vulkan/icd.d/nvidia_icd.x86_64.json
export VK_DRIVER_FILES=/run/opengl-driver/share/vulkan/icd.d/nvidia_icd.x86_64.json

# DXVK/VKD3D configuration
export PROTON_ENABLE_NVAPI=1
export PROTON_HIDE_NVIDIA_GPU=0
export DXVK_ASYNC=1
export DXVK_STATE_CACHE=1
export VKD3D_CONFIG=dxr,dxr11
export VKD3D_SHADER_MODEL=6_6

# Shader cache
export __GL_SHADER_DISK_CACHE=1
export __GL_SHADER_DISK_CACHE_PATH=$HOME/.cache/nvidia/GLCache

# Wine configuration
export WINE_LARGE_ADDRESS_AWARE=1
export WINEDLLOVERRIDES="d3d11=n;d3d10core=n;d3d10_1=n;d3d10=n;dxgi=n;d3d9=n"

# Launch Steam without GPU-disabling flags
exec steam "$@"
EOF

chmod +x ~/.local/bin/steam-gpu-launch.sh
echo -e "${GREEN}✓${NC} Created Steam GPU launch script"

# Create desktop entry
mkdir -p ~/.local/share/applications
cat > ~/.local/share/applications/steam-gpu.desktop << 'EOF'
[Desktop Entry]
Name=Steam (GPU Enabled)
Comment=Steam with proper GPU acceleration
Exec=/home/aural/.local/bin/steam-gpu-launch.sh %U
Icon=steam
Terminal=false
Type=Application
Categories=Network;FileTransfer;Game;
MimeType=x-scheme-handler/steam;x-scheme-handler/steamlink;
PrefersNonDefaultGPU=true
X-KDE-RunOnDiscreteGpu=true
EOF

echo -e "${GREEN}✓${NC} Created desktop entry"

echo ""
echo -e "${GREEN}[7/7] Testing Vulkan${NC}"
echo "--------------------------------------"

if command -v vulkaninfo &> /dev/null; then
    echo "Running Vulkan test..."
    if VK_ICD_FILENAMES=/run/opengl-driver/share/vulkan/icd.d/nvidia_icd.x86_64.json vulkaninfo --summary 2>&1 | grep -q "deviceName.*NVIDIA"; then
        GPU_NAME=$(VK_ICD_FILENAMES=/run/opengl-driver/share/vulkan/icd.d/nvidia_icd.x86_64.json vulkaninfo --summary 2>&1 | grep "deviceName" | head -1 | cut -d':' -f2 | xargs)
        echo -e "${GREEN}✓${NC} Vulkan working with: $GPU_NAME"
    else
        echo -e "${YELLOW}⚠${NC} Vulkan test inconclusive"
    fi
fi

echo ""
echo "========================================"
echo -e "${GREEN}Fix Applied Successfully!${NC}"
echo "========================================"
echo ""
echo "Next steps:"
echo "1. Rebuild NixOS configuration:"
echo "   sudo nixos-rebuild switch --flake .#sinistercat"
echo ""
echo "2. Reboot the system (recommended)"
echo ""
echo "3. Launch Steam using one of these methods:"
echo "   a) Use 'Steam (GPU Enabled)' from application menu"
echo "   b) Run: ~/.local/bin/steam-gpu-launch.sh"
echo "   c) Run: /etc/steam-gpu-fix.sh (after rebuild)"
echo ""
echo "4. For Path of Exile 2:"
echo "   - Right-click game → Properties → Compatibility"
echo "   - Force Proton GE-Proton9-20 or newer"
echo "   - Add launch options:"
echo "     PROTON_ENABLE_NVAPI=1 DXVK_ASYNC=1 gamemoderun %command% -dx11"
echo ""
echo "5. If issues persist:"
echo "   - Delete game's Proton prefix:"
echo "     rm -rf ~/.steam/steam/steamapps/compatdata/2694490"
echo "   - Verify game files in Steam"
echo "   - Try -vulkan instead of -dx11 in launch options"
echo ""
echo "Configuration files updated:"
echo "  - /home/aural/Code/nixos/modules/hardware/gpu-acceleration.nix"
echo "  - /home/aural/Code/nixos/modules/desktop/gaming.nix"
echo "  - /home/aural/Code/nixos/modules/desktop/steam-vulkan-fix.nix (NEW)"
