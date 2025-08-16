# Path of Exile 2 DirectX Factory Error Fix for NixOS

## Quick Fix Steps

1. **Rebuild your NixOS system with the updated configuration:**
   ```bash
   sudo nixos-rebuild switch --flake .#sinistercat
   ```

2. **After rebuild, run the fix script:**
   ```bash
   sudo /etc/poe2-fix.sh
   ```

3. **Install Proton GE (recommended):**
   - Launch `protonup-qt` from your applications
   - Download GE-Proton9-20 or newer
   - Close protonup-qt

4. **Configure Steam for PoE2:**
   - Right-click Path of Exile 2 → Properties
   - Go to Compatibility tab
   - Enable "Force the use of a specific Steam Play compatibility tool"
   - Select "GE-Proton9-20" (or newer)

5. **Set Launch Options:**
   - Still in Properties, go to General → Launch Options
   - Add this (all one line):
   ```
   PROTON_USE_WINED3D=0 PROTON_ENABLE_NVAPI=1 DXVK_ASYNC=1 VKD3D_CONFIG=dxr,dxr11 DXVK_STATE_CACHE=1 __GL_SHADER_DISK_CACHE=1 gamemoderun %command% --nologo --waitforpreload -dx11
   ```

6. **Verify Game Files:**
   - Properties → Installed Files
   - Click "Verify integrity of game files"

## What Was Fixed

### 1. **DirectX/Vulkan Translation Layers**
   - Added proper DXVK and VKD3D-Proton support
   - Fixed Vulkan ICD configuration for NVIDIA
   - Added missing 32-bit libraries

### 2. **NVIDIA Driver Configuration**
   - Explicitly set Vulkan ICD paths
   - Configured proper DirectX DLL overrides
   - Enabled NVIDIA API support in Proton

### 3. **Wine/Proton Environment**
   - Added missing system libraries (Kerberos, 32-bit TLS)
   - Configured shader caching
   - Set proper DirectX compatibility modes

### 4. **System-Level Optimizations**
   - Configured ESYNC/FSYNC support
   - Increased file descriptor limits
   - Enabled GameMode integration

## Troubleshooting

### If the error persists:

1. **Try Vulkan mode instead:**
   - Change `-dx11` to `-vulkan` in launch options

2. **Clear all caches:**
   ```bash
   rm -rf ~/.steam/steam/steamapps/shadercache/2694490/
   rm -rf ~/.cache/dxvk/
   rm -rf ~/.cache/nvidia/GLCache/
   ```

3. **Check Vulkan support:**
   ```bash
   vulkaninfo --summary | grep NVIDIA
   ```

4. **Try different Proton versions:**
   - Proton Experimental
   - GE-Proton9-20 or newer
   - Proton 9.0-4

5. **Debug mode:**
   Add to launch options:
   ```
   PROTON_LOG=1 DXVK_LOG_LEVEL=info DXVK_HUD=devinfo,fps,version,api
   ```
   Then check logs in: `~/.steam/steam/logs/`

## Files Created/Modified

- `/home/aural/Code/nixos/modules/desktop/gaming.nix` - Enhanced gaming configuration
- `/home/aural/Code/nixos/modules/hardware/gpu-acceleration.nix` - Fixed NVIDIA Vulkan setup
- `/etc/poe2-launch-options.txt` - Launch option reference (after rebuild)
- `/etc/poe2-fix.sh` - Automated fix script (after rebuild)

## Important Notes

- The configuration now includes all necessary DirectX compatibility layers
- NVIDIA Vulkan ICD is explicitly configured to prevent factory errors
- Shader caching is enabled for better performance
- The fix script can be run multiple times safely

## Additional Resources

- More launch options: `cat /etc/poe2-launch-options.txt`
- Run fix script: `sudo /etc/poe2-fix.sh`
- Monitor GPU: `nvidia-smi` or `nvtop`
- Test Vulkan: `vkcube` or `vulkaninfo`