#!/usr/bin/env bash
#|---/ /+--------------------------------------------+---/ /|#
#|--/ /-| Galaxy Book 2 Pro Post-Installation Setup |--/ /-|#
#|-/ /--| Configuración específica para Intel i7-1260P |-/ /--|#
#|/ /---+--------------------------------------------+/ /---|#

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}"
cat << "EOF"
╔═══════════════════════════════════════════════════════════╗
║   Galaxy Book 2 Pro - Post Installation Configuration    ║
║   Intel Core i7-1260P + Intel Xe Graphics                ║
╚═══════════════════════════════════════════════════════════╝
EOF
echo -e "${NC}"

# Verificar que se ejecuta después de HyDE
if [ ! -d ~/.config/hypr ]; then
    echo -e "${RED}[ERROR]${NC} HyDE no está instalado. Por favor instala HyDE primero."
    exit 1
fi

echo -e "${GREEN}[INFO]${NC} Iniciando configuración específica para Galaxy Book 2 Pro...\n"

# ============================================================================
# 1. VERIFICAR PARÁMETROS DEL KERNEL
# ============================================================================
echo -e "${BLUE}[1/10]${NC} Verificando parámetros del kernel..."

if grep -q "i915.enable_dpcd_backlight=3" /proc/cmdline; then
    echo -e "${GREEN}  ✓${NC} Parámetro de brillo AMOLED detectado correctamente"
else
    echo -e "${YELLOW}  ⚠${NC} Parámetro de brillo no detectado en kernel"
    echo -e "      Verifica que /etc/default/grub tiene: i915.enable_dpcd_backlight=3"
fi

# ============================================================================
# 2. CONFIGURAR GuC/HuC FIRMWARE
# ============================================================================
echo -e "\n${BLUE}[2/10]${NC} Configurando GuC/HuC firmware para Intel Gen 12..."

sudo mkdir -p /etc/modprobe.d

if [ -f /etc/modprobe.d/i915.conf ]; then
    echo -e "${YELLOW}  ⚠${NC} /etc/modprobe.d/i915.conf ya existe, haciendo backup..."
    sudo cp /etc/modprobe.d/i915.conf /etc/modprobe.d/i915.conf.bak
fi

echo "options i915 enable_guc=3" | sudo tee /etc/modprobe.d/i915.conf > /dev/null
echo -e "${GREEN}  ✓${NC} GuC/HuC habilitado (enable_guc=3)"

# ============================================================================
# 3. CONFIGURAR VARIABLES DE ENTORNO PARA INTEL GRAPHICS
# ============================================================================
echo -e "\n${BLUE}[3/10]${NC} Configurando variables de entorno para Wayland + Intel..."

INTEL_CONF=~/.config/hypr/intel.conf

cat > "$INTEL_CONF" << 'EOF'
# ============================================================================
# Configuración Intel Xe Graphics para Hyprland
# Galaxy Book 2 Pro - Intel Core i7-1260P
# ============================================================================

# Wayland optimizations
env = WLR_DRM_NO_ATOMIC,1
env = WLR_RENDERER_ALLOW_SOFTWARE,1

# Intel Graphics específico
env = LIBVA_DRIVER_NAME,iHD
env = VDPAU_DRIVER,va_gl

# Mesa/OpenGL
env = __GLX_VENDOR_LIBRARY_NAME,mesa
env = MESA_LOADER_DRIVER_OVERRIDE,iris

# Wayland para todas las aplicaciones
env = QT_QPA_PLATFORM,wayland
env = GDK_BACKEND,wayland
env = MOZ_ENABLE_WAYLAND,1
env = SDL_VIDEODRIVER,wayland
env = CLUTTER_BACKEND,wayland

# XDG
env = XDG_CURRENT_DESKTOP,Hyprland
env = XDG_SESSION_TYPE,wayland
env = XDG_SESSION_DESKTOP,Hyprland

# Qt
env = QT_AUTO_SCREEN_SCALE_FACTOR,1
env = QT_WAYLAND_DISABLE_WINDOWDECORATION,1

# Cursor
env = XCURSOR_SIZE,24
EOF

echo -e "${GREEN}  ✓${NC} Creado: ~/.config/hypr/intel.conf"

# Incluir en hyprland.conf si no está ya
if ! grep -q "source.*intel.conf" ~/.config/hypr/hyprland.conf 2>/dev/null; then
    echo -e "\n# Intel Graphics Configuration\nsource = ~/.config/hypr/intel.conf" >> ~/.config/hypr/hyprland.conf
    echo -e "${GREEN}  ✓${NC} Agregado source a hyprland.conf"
else
    echo -e "${YELLOW}  ℹ${NC} intel.conf ya está incluido en hyprland.conf"
fi

# ============================================================================
# 4. INSTALAR Y CONFIGURAR TLP
# ============================================================================
echo -e "\n${BLUE}[4/10]${NC} Configurando TLP para optimización de batería..."

if ! command -v tlp &> /dev/null; then
    echo -e "${YELLOW}  ⚠${NC} TLP no instalado, instalando..."
    sudo pacman -S --needed --noconfirm tlp tlp-rdw
fi

# Habilitar servicios TLP
sudo systemctl enable tlp.service
sudo systemctl mask systemd-rfkill.service
sudo systemctl mask systemd-rfkill.socket

# Configuración personalizada
sudo tee /etc/tlp.d/50-galaxybook2pro.conf > /dev/null << 'EOF'
# ============================================================================
# TLP Configuration for Samsung Galaxy Book 2 Pro
# Intel Core i7-1260P (Alder Lake - 12th Gen)
# ============================================================================

# CPU Frequency Scaling
CPU_SCALING_GOVERNOR_ON_AC=performance
CPU_SCALING_GOVERNOR_ON_BAT=powersave

# CPU Energy/Performance Policy
CPU_ENERGY_PERF_POLICY_ON_AC=performance
CPU_ENERGY_PERF_POLICY_ON_BAT=power

# CPU Boost
CPU_BOOST_ON_AC=1
CPU_BOOST_ON_BAT=0

# Intel P-State HWP
CPU_HWP_DYN_BOOST_ON_AC=1
CPU_HWP_DYN_BOOST_ON_BAT=0

# Platform Profile
PLATFORM_PROFILE_ON_AC=performance
PLATFORM_PROFILE_ON_BAT=low-power

# Intel GPU
INTEL_GPU_MIN_FREQ_ON_AC=300
INTEL_GPU_MIN_FREQ_ON_BAT=300
INTEL_GPU_MAX_FREQ_ON_AC=1400
INTEL_GPU_MAX_FREQ_ON_BAT=800
INTEL_GPU_BOOST_FREQ_ON_AC=1400
INTEL_GPU_BOOST_FREQ_ON_BAT=800

# WiFi Power Save
WIFI_PWR_ON_AC=off
WIFI_PWR_ON_BAT=on

# Audio Power Save
SOUND_POWER_SAVE_ON_AC=0
SOUND_POWER_SAVE_ON_BAT=1

# Runtime PM
RUNTIME_PM_ON_AC=on
RUNTIME_PM_ON_BAT=auto

# PCIe ASPM
PCIE_ASPM_ON_AC=default
PCIE_ASPM_ON_BAT=powersupersave

# USB Autosuspend
USB_AUTOSUSPEND=1
USB_EXCLUDE_AUDIO=1
USB_EXCLUDE_BTUSB=1
USB_EXCLUDE_PHONE=1
USB_EXCLUDE_PRINTER=1
USB_EXCLUDE_WWAN=0
EOF

echo -e "${GREEN}  ✓${NC} TLP configurado para Galaxy Book 2 Pro"

# ============================================================================
# 5. CONFIGURAR THERMALD
# ============================================================================
echo -e "\n${BLUE}[5/10]${NC} Configurando thermald..."

if ! command -v thermald &> /dev/null; then
    echo -e "${YELLOW}  ⚠${NC} thermald no instalado, instalando..."
    sudo pacman -S --needed --noconfirm thermald
fi

sudo systemctl enable thermald.service
echo -e "${GREEN}  ✓${NC} thermald habilitado"

# ============================================================================
# 6. CONFIGURAR LÍMITE DE CARGA DE BATERÍA (80%)
# ============================================================================
echo -e "\n${BLUE}[6/10]${NC} Configurando límite de carga de batería al 80%..."

# Buscar el path correcto de la batería
BAT_PATH=$(find /sys/class/power_supply/BAT* -name charge_control_end_threshold 2>/dev/null | head -n 1)

if [ -n "$BAT_PATH" ]; then
    BAT_DIR=$(dirname "$BAT_PATH")
    
    # Crear servicio systemd
    sudo tee /etc/systemd/system/battery-charge-threshold.service > /dev/null << EOF
[Unit]
Description=Set battery charge threshold to 80%
After=multi-user.target

[Service]
Type=oneshot
ExecStart=/bin/bash -c 'echo 80 > ${BAT_PATH}'
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF

    sudo systemctl enable battery-charge-threshold.service
    echo -e "${GREEN}  ✓${NC} Límite de carga al 80% configurado"
    echo -e "      Esto ayuda a prolongar la vida de la batería"
else
    echo -e "${YELLOW}  ⚠${NC} No se encontró soporte para límite de carga de batería"
    echo -e "      Esto es normal en algunos modelos"
fi

# ============================================================================
# 7. CONFIGURAR WIFI INTEL AX211
# ============================================================================
echo -e "\n${BLUE}[7/10]${NC} Optimizando WiFi Intel AX211..."

sudo tee /etc/modprobe.d/iwlwifi.conf > /dev/null << 'EOF'
# Intel WiFi AX211 Optimization
options iwlwifi power_save=1
options iwlwifi 11n_disable=0
options iwlwifi swcrypto=0
options iwlwifi bt_coex_active=1
options iwlwifi led_mode=2
EOF

echo -e "${GREEN}  ✓${NC} WiFi optimizado para AX211"

# ============================================================================
# 8. CONFIGURAR GESTOS DE TOUCHPAD
# ============================================================================
echo -e "\n${BLUE}[8/10]${NC} Configurando gestos de touchpad..."

# Crear configuración de libinput-gestures si existe
if [ -f ~/.config/libinput-gestures.conf ]; then
    echo -e "${YELLOW}  ℹ${NC} libinput-gestures.conf ya existe"
else
    mkdir -p ~/.config
    cat > ~/.config/libinput-gestures.conf << 'EOF'
# Gestos para Galaxy Book 2 Pro
# 3 dedos arriba/abajo = cambiar workspace
gesture swipe up 3 hyprctl dispatch workspace e+1
gesture swipe down 3 hyprctl dispatch workspace e-1

# 3 dedos izquierda/derecha = navegar apps
gesture swipe left 3 hyprctl dispatch cyclenext
gesture swipe right 3 hyprctl dispatch cyclenext prev

# 4 dedos arriba = mostrar todas las ventanas
gesture swipe up 4 hyprctl dispatch overview:toggle

# Pinch = zoom (si está soportado por la app)
gesture pinch in xdotool key ctrl+minus
gesture pinch out xdotool key ctrl+plus
EOF
    echo -e "${GREEN}  ✓${NC} Gestos de touchpad configurados"
fi

# ============================================================================
# 9. REGENERAR INITRAMFS
# ============================================================================
echo -e "\n${BLUE}[9/10]${NC} Regenerando initramfs con nuevos módulos..."

sudo mkinitcpio -P
echo -e "${GREEN}  ✓${NC} initramfs regenerado"

# ============================================================================
# 10. VERIFICAR CONFIGURACIÓN
# ============================================================================
echo -e "\n${BLUE}[10/10]${NC} Verificando configuración..."

echo -e "\n${GREEN}═══════════════════════ RESUMEN ═══════════════════════${NC}"

# Verificar drivers
if lspci | grep -i "VGA" | grep -qi "Intel"; then
    echo -e "${GREEN}  ✓${NC} GPU Intel detectada correctamente"
fi

# Verificar Mesa
if pacman -Q mesa &>/dev/null; then
    MESA_VER=$(pacman -Q mesa | awk '{print $2}')
    echo -e "${GREEN}  ✓${NC} Mesa instalado (v${MESA_VER})"
fi

# Verificar TLP
if systemctl is-enabled tlp.service &>/dev/null; then
    echo -e "${GREEN}  ✓${NC} TLP habilitado"
fi

# Verificar thermald
if systemctl is-enabled thermald.service &>/dev/null; then
    echo -e "${GREEN}  ✓${NC} thermald habilitado"
fi

echo -e "\n${GREEN}═══════════════════════════════════════════════════════${NC}\n"

# ============================================================================
# INSTRUCCIONES FINALES
# ============================================================================
echo -e "${YELLOW}╔═══════════════════════════════════════════════════════════╗${NC}"
echo -e "${YELLOW}║              INSTRUCCIONES POST-INSTALACIÓN              ║${NC}"
echo -e "${YELLOW}╚═══════════════════════════════════════════════════════════╝${NC}\n"

echo -e "${BLUE}1.${NC} ${GREEN}REINICIAR EL SISTEMA${NC} para aplicar todos los cambios:"
echo -e "   ${YELLOW}sudo reboot${NC}\n"

echo -e "${BLUE}2.${NC} Después del reinicio, verifica el control de brillo:"
echo -e "   ${YELLOW}brightnessctl set 50%${NC}\n"

echo -e "${BLUE}3.${NC} Verifica que GuC/HuC está activo:"
echo -e "   ${YELLOW}sudo cat /sys/kernel/debug/dri/0/gt/uc/guc_info${NC}"
echo -e "   ${YELLOW}sudo cat /sys/kernel/debug/dri/0/gt/uc/huc_info${NC}\n"

echo -e "${BLUE}4.${NC} Monitorea el rendimiento de la GPU:"
echo -e "   ${YELLOW}sudo intel_gpu_top${NC}\n"

echo -e "${BLUE}5.${NC} Verifica el estado de TLP:"
echo -e "   ${YELLOW}sudo tlp-stat -b${NC} (batería)"
echo -e "   ${YELLOW}sudo tlp-stat -t${NC} (temperatura)"
echo -e "   ${YELLOW}sudo tlp-stat -p${NC} (procesador)\n"

echo -e "${BLUE}6.${NC} Prueba la aceleración de hardware de video:"
echo -e "   ${YELLOW}vainfo${NC} (debería mostrar iHD driver)\n"

echo -e "${BLUE}7.${NC} Para máxima duración de batería, usa Hyprland con:"
echo -e "   - Temas oscuros (mejor para AMOLED)"
echo -e "   - Reduce animaciones si necesitas más batería"
echo -e "   - El límite de carga al 80% ya está activo\n"

echo -e "${GREEN}═══════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}  Configuración completada para Galaxy Book 2 Pro!${NC}"
echo -e "${GREEN}═══════════════════════════════════════════════════════════${NC}\n"

echo -e "${YELLOW}Documentación completa en:${NC} GALAXY_BOOK_2_PRO_SETUP.md\n"
