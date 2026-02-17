# 🚀 Instalación Rápida - Galaxy Book 2 Pro

## 📋 Modificaciones Realizadas

Este fork de HyDE ha sido personalizado específicamente para **Samsung Galaxy Book 2 Pro** con:
- ✅ Intel Core i7-1260P
- ✅ Intel Xe Graphics (96 EUs)
- ✅ Pantalla AMOLED
- ✅ 16GB LPDDR5
- ✅ Arch Linux

---

## 🔧 Cambios Aplicados Automáticamente

### 1. **Control de Brillo AMOLED**
- Parámetro del kernel: `i915.enable_dpcd_backlight=3` 
- Se aplica automáticamente en GRUB y systemd-boot
- **Archivos modificados:**
  - `Scripts/global_fn.sh` - Nueva función `intel_detect()`
  - `Scripts/install_pre.sh` - Detección y configuración automática

### 2. **Detección de Intel Graphics**
- Similar a la detección de NVIDIA pero para Intel
- Se ejecuta automáticamente durante la instalación

---

## 📦 Instalación Paso a Paso

### Paso 1: Preparar el sistema base

```bash
# En Arch Linux recién instalado
sudo pacman -Syu
sudo pacman -S --needed git base-devel
```

### Paso 2: Clonar este repositorio

```bash
git clone --depth 1 https://github.com/TU_USUARIO/HyDE_for_my_book_pro2 ~/HyDE
cd ~/HyDE/Scripts
```

### Paso 3: Instalar HyDE con paquetes personalizados

**Opción A: Instalación con paquetes específicos de Galaxy Book 2 Pro**
```bash
chmod +x install.sh
./install.sh pkg_user_galaxybook2pro.lst
```

**Opción B: Instalación estándar (solo paquetes core)**
```bash
./install.sh
```

> ⚠️ **IMPORTANTE:** NO uses el flag `-n` (no-nvidia) ya que la detección de Intel es automática.

### Paso 4: Configuración post-instalación específica

Después de que HyDE termine de instalarse, ejecuta:

```bash
chmod +x galaxybook2pro_setup.sh
./galaxybook2pro_setup.sh
```

Este script configurará:
- ✅ GuC/HuC firmware para Intel Gen 12
- ✅ Variables de entorno optimizadas para Wayland + Intel
- ✅ TLP con perfil específico para i7-1260P
- ✅ thermald para control de temperatura
- ✅ Límite de carga de batería al 80%
- ✅ Optimización de WiFi Intel AX211
- ✅ Gestos de touchpad
- ✅ Regeneración de initramfs

### Paso 5: Reiniciar

```bash
sudo reboot
```

---

## 📁 Archivos Personalizados Incluidos

| Archivo | Descripción |
|---------|-------------|
| `GALAXY_BOOK_2_PRO_SETUP.md` | Guía completa de configuración y optimización |
| `Scripts/pkg_user_galaxybook2pro.lst` | Lista de paquetes específicos para Intel |
| `Scripts/galaxybook2pro_setup.sh` | Script de configuración post-instalación |
| `Scripts/global_fn.sh` | **MODIFICADO** - Agrega función `intel_detect()` |
| `Scripts/install_pre.sh` | **MODIFICADO** - Configuración de bootloader para Intel |
| `README_GALAXYBOOK.md` | Este archivo |

---

## ✅ Verificación Post-Instalación

### 1. Verificar parámetro de brillo

```bash
cat /proc/cmdline | grep i915.enable_dpcd_backlight
# Debe mostrar: i915.enable_dpcd_backlight=3
```

### 2. Probar control de brillo

```bash
brightnessctl set 50%
brightnessctl set 100%
brightnessctl set 25%
```

### 3. Verificar GuC/HuC

```bash
sudo dmesg | grep -i guc
sudo dmesg | grep -i huc
# Debe mostrar: GuC firmware i915/adlp_guc_*.bin version x.x
```

### 4. Verificar aceleración de hardware (VA-API)

```bash
vainfo
# Debe mostrar: Driver version: Intel iHD driver
```

### 5. Verificar GPU

```bash
sudo intel_gpu_top
# Muestra uso en tiempo real de la GPU
```

### 6. Verificar TLP

```bash
sudo tlp-stat -s
# Debe mostrar: TLP started in AC/battery mode
```

---

## 🎯 Paquetes Críticos Instalados

### GPU Intel
- `mesa` - OpenGL/Vulkan
- `vulkan-intel` - Vulkan para Intel Xe
- `intel-media-driver` - VA-API (iHD)
- `intel-gpu-tools` - Herramientas de diagnóstico

### Gestión de Energía
- `tlp` + `tlp-rdw` - Optimización de batería
- `powertop` - Monitoreo de consumo
- `thermald` - Control de temperatura Intel

### Audio
- `sof-firmware` - Sound Open Firmware
- `alsa-ucm-conf` - Configuraciones ALSA

### Sistema
- `linux-firmware` - Incluye firmware WiFi Intel AX211

---

## ⚡ Optimizaciones Aplicadas

### Kernel Parameters
```
i915.enable_dpcd_backlight=3   # Control de brillo AMOLED
```

### GuC/HuC Firmware
```
# /etc/modprobe.d/i915.conf
options i915 enable_guc=3
```

### Variables de Entorno
```bash
# ~/.config/hypr/intel.conf
env = LIBVA_DRIVER_NAME,iHD
env = MESA_LOADER_DRIVER_OVERRIDE,iris
env = WLR_DRM_NO_ATOMIC,1
```

### TLP Profile
```bash
# /etc/tlp.d/50-galaxybook2pro.conf
CPU_SCALING_GOVERNOR_ON_BAT=powersave
INTEL_GPU_MAX_FREQ_ON_BAT=800
WIFI_PWR_ON_BAT=on
```

---

## 🔧 Solución de Problemas

### Brillo no funciona
```bash
# Verificar que el parámetro está en el kernel
cat /proc/cmdline | grep i915

# Si no está, regenerar GRUB
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

### Tearing en videos
```bash
# Agregar en ~/.config/hypr/hyprland.conf
env = WLR_DRM_NO_ATOMIC,1
```

### Rendimiento bajo de GPU
```bash
# Verificar que GuC está activo
sudo dmesg | grep GuC

# Verificar frecuencia de GPU
cat /sys/class/drm/card0/gt_max_freq_mhz
cat /sys/class/drm/card0/gt_min_freq_mhz
```

### Batería se drena rápido
```bash
# Verificar que TLP está activo
sudo systemctl status tlp

# Ver consumo actual
sudo powertop
```

---

## 📚 Documentación Completa

Para optimizaciones avanzadas, troubleshooting detallado y configuraciones adicionales, consulta:

👉 **[GALAXY_BOOK_2_PRO_SETUP.md](GALAXY_BOOK_2_PRO_SETUP.md)**

---

## 🆘 Soporte

- **HyDE Original:** [GitHub - HyDE Project](https://github.com/HyDE-Project/HyDE)
- **Discord HyDE:** [The HyDE Project](https://discord.gg/qWehcFJxPa)
- **Arch Wiki Intel:** [Intel Graphics](https://wiki.archlinux.org/title/Intel_graphics)
- **Arch Wiki TLP:** [TLP](https://wiki.archlinux.org/title/TLP)

---

## ⚠️ Notas Importantes

1. ❌ **NO instales drivers NVIDIA** - Tu laptop solo tiene Intel Graphics
2. ✅ **Usa temas oscuros** - Mejor para AMOLED y ahorro de batería
3. ✅ **TLP es crítico** - Instalarlo y configurarlo mejora mucho la batería
4. ✅ **Límite de carga al 80%** - Ya está configurado automáticamente
5. ✅ **GuC/HuC mejora eficiencia** - Ya está habilitado

---

## 🎨 Temas Recomendados para AMOLED

Para maximizar vida de batería y evitar burn-in en pantalla AMOLED:

- **Catppuccin Mocha** - Oscuro, colores suaves
- **Tokyo Night** - Oscuro con buenos contrastes
- **Gruvbox Dark** - Oscuro clásico
- **Nord** - Oscuro azulado

Evita temas muy brillantes o con mucho blanco.

---

## 📊 Rendimiento Esperado

Con tu configuración deberías obtener:

- ✅ **Animaciones fluidas:** 60 FPS en Hyprland
- ✅ **Navegación web:** Sin problemas
- ✅ **Videos 4K:** Reproducción fluida con aceleración HW
- ✅ **Batería:** 6-8 horas uso normal con TLP
- ✅ **Juegos ligeros:** 30-60 FPS en títulos indie/2D

---

## 🔄 Actualizaciones Futuras

Este fork mantiene las modificaciones específicas para Galaxy Book 2 Pro mientras permite actualizar desde el repositorio original de HyDE.

```bash
# Actualizar HyDE (manteniendo modificaciones)
cd ~/HyDE/Scripts
./install.sh -r  # Solo restaurar configs sin reinstalar
```

---

**Fecha:** Febrero 2026  
**Compatible con:** HyDE v26.x  
**Hardware:** Samsung Galaxy Book 2 Pro (Intel i7-1260P)
