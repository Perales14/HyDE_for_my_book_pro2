# Configuración Específica para Galaxy Book 2 Pro

## 🖥️ Especificaciones del Hardware

- **Modelo:** Samsung Galaxy Book 2 Pro
- **Procesador:** Intel Core i7-1260P (12th Gen Alder Lake)
- **Gráficos:** Intel Xe Graphics (96 EUs)
- **RAM:** 16GB LPDDR5 5200MT/s
- **Almacenamiento:** 500GB NVMe SSD
- **Pantalla:** 15.6" AMOLED FHD (1920x1080)
- **Distribución:** Arch Linux

---

## ✅ Modificaciones Aplicadas

### 1. Control de Brillo AMOLED

**Parámetro agregado:** `i915.enable_dpcd_backlight=3`

Este parámetro se ha agregado automáticamente a:
- `GRUB_CMDLINE_LINUX_DEFAULT` en `/etc/default/grub`
- Bootloader: systemd-boot (si está presente)

**Ubicación del cambio:**
- `Scripts/global_fn.sh` - Nueva función `intel_detect()`
- `Scripts/install_pre.sh` - Detección y configuración automática

**Verificación post-instalación:**
```bash
# Verificar que el parámetro está presente
cat /proc/cmdline | grep i915.enable_dpcd_backlight

# Debe mostrar: i915.enable_dpcd_backlight=3
```

---

## 📦 Paquetes Adicionales Recomendados

### Drivers Intel y Mesa
Estos paquetes ya están incluidos en Arch, pero asegúrate de tenerlos:

```bash
sudo pacman -S mesa lib32-mesa vulkan-intel lib32-vulkan-intel intel-media-driver
```

### Herramientas de Monitoreo Intel
```bash
sudo pacman -S intel-gpu-tools
```

**Uso:**
```bash
# Monitorear uso de GPU
intel_gpu_top

# Ver información de la GPU
intel_gpu_frequency
```

### Gestión de Energía para Laptop

```bash
# TLP - Optimización avanzada de batería
sudo pacman -S tlp tlp-rdw

# Habilitar servicios
sudo systemctl enable tlp.service
sudo systemctl enable NetworkManager-dispatcher.service
sudo systemctl mask systemd-rfkill.service
sudo systemctl mask systemd-rfkill.socket

# Herramientas adicionales
sudo pacman -S powertop thermald
sudo systemctl enable thermald.service
```

### Auto-rotación de Pantalla (si tu modelo lo soporta)
```bash
yay -S iio-sensor-proxy rot8
```

### Touchpad Mejorado
```bash
sudo pacman -S libinput xf86-input-libinput
```

---

## ⚡ Optimizaciones Recomendadas

### 1. Parámetros de Kernel Adicionales para Intel

Edita `/etc/default/grub` y agrega estos parámetros adicionales (ya incluye el de backlight):

```bash
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash i915.enable_dpcd_backlight=3 i915.enable_fbc=1 i915.enable_psr=2 i915.fastboot=1"
```

**Explicación:**
- `i915.enable_dpcd_backlight=3` - Control de brillo AMOLED ✅ (ya aplicado)
- `i915.enable_fbc=1` - Frame Buffer Compression (ahorro de energía)
- `i915.enable_psr=2` - Panel Self Refresh (ahorro de energía en pantalla)
- `i915.fastboot=1` - Boot más rápido manteniendo modo de video del BIOS

Después de modificar:
```bash
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

### 2. Habilitar GuC/HuC Firmware (12th Gen)

El i7-1260P soporta GuC/HuC para mejor eficiencia:

```bash
# Editar /etc/modprobe.d/i915.conf
sudo mkdir -p /etc/modprobe.d
echo "options i915 enable_guc=3" | sudo tee /etc/modprobe.d/i915.conf
```

Regenerar initramfs:
```bash
sudo mkinitcpio -P
```

### 3. Configuración de TLP para Galaxy Book 2 Pro

Edita `/etc/tlp.conf`:

```bash
# Procesador
CPU_SCALING_GOVERNOR_ON_AC=performance
CPU_SCALING_GOVERNOR_ON_BAT=powersave
CPU_ENERGY_PERF_POLICY_ON_AC=performance
CPU_ENERGY_PERF_POLICY_ON_BAT=power

# CPU Boost (Turbo)
CPU_BOOST_ON_AC=1
CPU_BOOST_ON_BAT=0

# HWP (Hardware P-States)
CPU_HWP_DYN_BOOST_ON_AC=1
CPU_HWP_DYN_BOOST_ON_BAT=0

# Intel GPU
INTEL_GPU_MIN_FREQ_ON_AC=0
INTEL_GPU_MIN_FREQ_ON_BAT=0
INTEL_GPU_MAX_FREQ_ON_AC=0
INTEL_GPU_MAX_FREQ_ON_BAT=0
INTEL_GPU_BOOST_FREQ_ON_AC=0
INTEL_GPU_BOOST_FREQ_ON_BAT=0

# NVMe SSD
AHCI_RUNTIME_PM_ON_AC=auto
AHCI_RUNTIME_PM_ON_BAT=auto

# Audio - importante para el codec Realtek
SOUND_POWER_SAVE_ON_AC=0
SOUND_POWER_SAVE_ON_BAT=1

# WiFi (Intel AX211 probablemente)
WIFI_PWR_ON_AC=off
WIFI_PWR_ON_BAT=on
```

### 4. Optimización de Hyprland para Intel

Crea o edita `~/.config/hypr/intel.conf`:

```bash
# Optimizaciones para Intel Xe Graphics
env = WLR_DRM_NO_ATOMIC,1
env = WLR_RENDERER_ALLOW_SOFTWARE,1

# Variables para mejor rendimiento con Intel
env = LIBVA_DRIVER_NAME,iHD
env = VDPAU_DRIVER,va_gl
env = QT_QPA_PLATFORM,wayland
env = GDK_BACKEND,wayland
env = MOZ_ENABLE_WAYLAND,1

# OpenGL/Vulkan
env = __GLX_VENDOR_LIBRARY_NAME,mesa
env = MESA_LOADER_DRIVER_OVERRIDE,iris
```

Luego incluye este archivo en tu `hyprland.conf`:
```bash
source = ~/.config/hypr/intel.conf
```

---

## 🔋 Configuración de Batería y Rendimiento

### 1. Límite de Carga de Batería (80% recomendado)

```bash
# Verificar si está disponible
ls /sys/class/power_supply/BAT*/charge_control_end_threshold

# Si existe, configurar límite al 80%
echo 80 | sudo tee /sys/class/power_supply/BAT0/charge_control_end_threshold

# Hacer permanente creando servicio systemd
sudo tee /etc/systemd/system/battery-charge-threshold.service << 'EOF'
[Unit]
Description=Set battery charge threshold
After=multi-user.target

[Service]
Type=oneshot
ExecStart=/bin/bash -c 'echo 80 > /sys/class/power_supply/BAT0/charge_control_end_threshold'
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl enable battery-charge-threshold.service
```

### 2. Monitoreo de Temperatura

```bash
# Instalar sensores
sudo pacman -S lm_sensors

# Detectar sensores
sudo sensors-detect

# Ver temperaturas
sensors
```

---

## 🎨 Pantalla AMOLED - Recomendaciones

### 1. Protector de Pantalla Oscuro

Para pantallas AMOLED es mejor usar temas oscuros para:
- Reducir consumo de energía
- Evitar burn-in
- Reducir fatiga visual

```bash
# Aplicar tema oscuro en HyDE
hyde theme select
# Selecciona un tema oscuro
```

### 2. Reducir Burn-in

```bash
# Auto-hide para Waybar
# Edita ~/.config/waybar/config.jsonc
# Agrega en la configuración principal:
"layer": "top",
"margin-top": 5,
"margin-bottom": 0,
"mode": "hide"  # Auto-ocultar cuando no se usa
```

### 3. Filtro de Luz Azul (hyprsunset)

Ya incluido en HyDE. Configurar:

```bash
# hyprsunset ya está en los paquetes core
# Usar con un atajo de teclado o automáticamente

# Ejemplo de uso manual (3400K al atardecer)
hyprsunset -t 3400
```

---

## 🔊 Audio Configuration

Tu Galaxy Book 2 Pro probablemente tiene un codec Realtek ALC298.

### SOF Firmware (Sound Open Firmware)

```bash
sudo pacman -S sof-firmware alsa-ucm-conf
```

### Probar Audio

```bash
# Ver dispositivos
aplay -l

# Test de sonido
speaker-test -c 2
```

---

## 🌐 WiFi Intel AX211

El Galaxy Book 2 Pro viene con Intel AX211. Configuración:

```bash
# El firmware ya debería estar en linux-firmware
# Si tienes problemas:
sudo pacman -S linux-firmware

# Para mejor estabilidad en algunos casos:
sudo tee /etc/modprobe.d/iwlwifi.conf << EOF
options iwlwifi power_save=0
options iwlwifi 11n_disable=0
options iwlwifi swcrypto=0
options iwlwifi bt_coex_active=1
EOF
```

---

## 📝 Lista de Verificación Post-Instalación

- [ ] Verificar que `i915.enable_dpcd_backlight=3` está en `/proc/cmdline`
- [ ] Control de brillo funciona correctamente (`brightnessctl`)
- [ ] TLP instalado y habilitado
- [ ] Thermald instalado y habilitado
- [ ] GuC/HuC habilitado para Intel
- [ ] Límite de carga de batería configurado (opcional)
- [ ] Drivers de Mesa e Intel instalados
- [ ] Variables de entorno de Wayland configuradas
- [ ] Audio funciona correctamente
- [ ] WiFi estable y funcionando
- [ ] Suspender/Reanudar funciona
- [ ] Hibernación configurada (opcional)

---

## 🐛 Troubleshooting

### Problema: Brillo no funciona
```bash
# Verificar parámetro del kernel
cat /proc/cmdline | grep i915.enable_dpcd_backlight

# Si no está, agregar manualmente a GRUB y regenerar
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

### Problema: Pantalla parpadea
```bash
# Deshabilitar PSR temporalmente
echo 0 | sudo tee /sys/module/i915/parameters/enable_psr

# Si funciona, agregar i915.enable_psr=0 al kernel
```

### Problema: Rendimiento bajo
```bash
# Verificar governor de CPU
cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor

# Verificar frecuencia GPU
sudo intel_gpu_frequency

# Ver uso de GPU en tiempo real
sudo intel_gpu_top
```

### Problema: Tearing en videos
```bash
# En ~/.config/hypr/hyprland.conf agregar:
env = WLR_DRM_NO_ATOMIC,1

# O intentar con:
env = WLR_NO_HARDWARE_CURSORS,1
```

---

## 🔗 Recursos Útiles

- [Arch Wiki - Intel Graphics](https://wiki.archlinux.org/title/Intel_graphics)
- [Arch Wiki - TLP](https://wiki.archlinux.org/title/TLP)
- [Arch Wiki - Power Management](https://wiki.archlinux.org/title/Power_management)
- [Hyprland Wiki](https://wiki.hyprland.org/)
- [Intel Graphics for Linux](https://www.intel.com/content/www/us/en/support/articles/000005520/graphics.html)

---

## 📊 Benchmark Esperado

Con Intel Xe Graphics 96 EUs deberías tener:

- **Juegos ligeros:** 30-60 FPS en 1080p low-medium
- **Productividad:** Excelente (office, navegación, multimedia)
- **Edición de video:** 1080p sin problemas, 4K básico
- **Animaciones Wayland:** Fluidas a 60 FPS

---

## ⚠️ Notas Importantes

1. **No instales drivers NVIDIA** - Tu laptop solo tiene Intel Graphics
2. **Evita el flag `-n`** al instalar HyDE (deja que detecte Intel automáticamente)
3. **Usa temas oscuros** - Mejor para pantalla AMOLED y batería
4. **Límite de carga al 80%** - Prolonga la vida útil de la batería
5. **TLP es esencial** - Optimiza mucho la duración de batería en laptops

---

## 🎯 Comando de Instalación Recomendado

```bash
cd ~/HyDE/Scripts
./install.sh -irs
# No uses -n porque NO tienes NVIDIA
# Deja que detecte Intel automáticamente
```

---

**Fecha de documentación:** 17 de Febrero, 2026  
**Versión de HyDE:** Compatible con v26.x  
**Mantenedor:** Personalizado para Galaxy Book 2 Pro
