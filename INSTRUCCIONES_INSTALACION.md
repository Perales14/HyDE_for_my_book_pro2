# 📖 Instrucciones de Instalación - HyDE para Galaxy Book 2 Pro

> **Dispositivo:** Samsung Galaxy Book 2 Pro  
> **Procesador:** Intel Core i7-1260P  
> **Gráficos:** Intel Xe Graphics (96 EUs)  
> **Pantalla:** AMOLED 15.6"  
> **Sistema:** Arch Linux

---

## ⚠️ REQUISITOS PREVIOS

Antes de comenzar, asegúrate de tener:

- ✅ **Arch Linux instalado** (instalación base completa)
- ✅ **Conexión a Internet** funcionando
- ✅ **Usuario con permisos sudo** configurado
- ✅ **Sistema actualizado** (`sudo pacman -Syu`)
- ✅ **Al menos 20GB de espacio libre** en disco

> **IMPORTANTE:** Esta instalación modificará:
> - Configuración de GRUB o systemd-boot
> - Archivos de configuración en `~/.config/`
> - Servicios del sistema
> - Shell (zsh o fish)
> - Display Manager (SDDM)

---

## 🚀 PROCESO DE INSTALACIÓN COMPLETO

### FASE 1: Preparación del Sistema Base

#### Paso 1.1 - Actualizar el Sistema

```bash
# Actualizar todo el sistema
sudo pacman -Syu

# Espera a que termine completamente
# Si hay actualizaciones de kernel, anota reiniciar después
```

**⏱️ Tiempo estimado:** 5-15 minutos dependiendo de la conexión

---

#### Paso 1.2 - Instalar Herramientas Básicas

```bash
# Instalar Git y herramientas de compilación
sudo pacman -S --needed git base-devel

# Verificar instalación
git --version
```

**✅ Verificación:** Deberías ver la versión de Git (ej: `git version 2.x.x`)

---

### FASE 2: Descargar HyDE Personalizado

#### Paso 2.1 - Clonar el Repositorio

```bash
# Ir al directorio home
cd ~

# Clonar el repositorio personalizado para Galaxy Book 2 Pro
# OPCIÓN A: Si tienes el repo en GitHub
git clone --depth 1 https://github.com/perales14/HyDE_for_my_book_pro2 ~/HyDE

# OPCIÓN B: Si lo tienes localmente, copia la carpeta
# cp -r /ruta/a/HyDE_for_my_book_pro2 ~/HyDE
```

---

#### Paso 2.2 - Verificar Archivos

```bash
# Entrar al directorio
cd ~/HyDE/Scripts

# Listar archivos importantes
ls -lh install.sh galaxybook2pro_setup.sh pkg_user_galaxybook2pro.lst

# Todos los archivos deben aparecer
```

**✅ Verificación:** Debes ver los tres archivos listados.

---

#### Paso 2.3 - Dar Permisos de Ejecución

```bash
# Hacer los scripts ejecutables
chmod +x install.sh
chmod +x galaxybook2pro_setup.sh
chmod +x restore_*.sh
chmod +x install_*.sh

# Verificar permisos
ls -l install.sh galaxybook2pro_setup.sh
```

**✅ Verificación:** Los archivos deben mostrar `-rwxr-xr-x` (la `x` indica ejecutable)

---

### FASE 3: Instalación de HyDE

> **⚠️ ATENCIÓN:** Esta es la parte principal y puede tomar 30-90 minutos dependiendo de tu conexión a Internet.

#### Paso 3.1 - Ejecutar el Instalador de HyDE

```bash
# Asegúrate de estar en el directorio correcto
cd ~/HyDE/Scripts

# Ejecutar instalación CON la lista de paquetes personalizados
./install.sh pkg_user_galaxybook2pro.lst
```

**🎯 QUÉ ESPERAR:**

El instalador te preguntará varias cosas. Aquí están las respuestas recomendadas:

---

#### 📝 Opciones Durante la Instalación

##### **1. AUR Helper (Gestor de AUR)**

```
AUR Helpers ::
[1] yay
[2] paru
[3] yay-bin
[4] paru-bin

Enter option number [default: yay-bin] | q to quit:
```

**Respuesta recomendada:** Presiona `Enter` (usa el default: yay-bin)  
**Alternativa:** Escribe `1` para yay (más popular pero tarda más en compilar)

---

##### **2. Shell (Intérprete de Comandos)**

```
Shell ::
[1] zsh
[2] fish

Enter option number [default: zsh] | q to quit:
```

**Respuesta recomendada:** Presiona `Enter` (usa zsh - más común)  
**Alternativa:** Escribe `2` si prefieres fish

---

##### **3. Tema de GRUB**

```
Select grub theme:
[1] Retroboot (dark)
[2] Pochita (light)

Press enter to skip grub theme <or> Enter option number:
```

**Respuesta recomendada:** Escribe `1` (Retroboot - mejor para AMOLED)  
**Razón:** Los temas oscuros ahorran batería en pantallas AMOLED

---

##### **4. Tema de SDDM (Display Manager)**

```
Select sddm theme:
[1] Candy
[2] Corners

Enter option number:
```

**Respuesta recomendada:** Escribe `2` (Corners - más moderno)  
**Alternativa:** Escribe `1` para Candy

---

##### **5. Chaotic AUR**

```
Would you like to install Chaotic AUR? [y/n] | q to quit
```

**Respuesta recomendada:** Escribe `y` (útil para paquetes pre-compilados)  
**Razón:** Acelera futuras instalaciones de algunos paquetes AUR

---

#### ⏱️ Tiempo de Instalación Esperado

| Fase | Tiempo Aprox. |
|------|---------------|
| Instalación de AUR helper | 2-5 min |
| Paquetes del sistema (pacman) | 10-20 min |
| Paquetes de AUR | 15-40 min |
| Configuración de dotfiles | 5 min |
| Temas e iconos | 5-10 min |

**Total:** 35-80 minutos (dependiendo de conexión y opción de AUR helper)

---

#### 🔍 Monitorear el Proceso

Durante la instalación verás:
- `✓` verde - Operación exitosa
- `⚠` amarillo - Advertencia (normal)
- `✗` rojo - Error (anotar para revisar después)

**NO INTERRUMPAS** el proceso a menos que:
- Veas errores críticos repetidos
- El sistema se congele completamente

---

#### Paso 3.2 - Finalización de la Instalación Principal

Al terminar verás:

```
═══════════════════════════════════════════════════════════
  Installation COMPLETED!
═══════════════════════════════════════════════════════════

Do you want to reboot the system? (y/N)
```

**⚠️ IMPORTANTE:** Escribe `N` (NO reinicies todavía)

**Razón:** Aún falta ejecutar el script de configuración específica para Galaxy Book 2 Pro.

---

### FASE 4: Configuración Específica para Galaxy Book 2 Pro

> Esta fase configura optimizaciones específicas para tu hardware Intel.

#### Paso 4.1 - Ejecutar Script de Configuración

```bash
# Ejecutar el script de configuración para Galaxy Book 2 Pro
./galaxybook2pro_setup.sh
```

**🎯 QUÉ HACE ESTE SCRIPT:**

1. ✅ Verifica que `i915.enable_dpcd_backlight=3` esté en el kernel
2. ✅ Configura GuC/HuC firmware para Intel Gen 12
3. ✅ Crea variables de entorno para Intel Graphics
4. ✅ Instala y configura TLP con perfil optimizado para i7-1260P
5. ✅ Configura thermald para control de temperatura
6. ✅ Establece límite de carga de batería al 80% (si es soportado)
7. ✅ Optimiza WiFi Intel AX211
8. ✅ Configura gestos de touchpad
9. ✅ Regenera initramfs con nuevos módulos
10. ✅ Muestra resumen de configuración

**⏱️ Tiempo estimado:** 3-5 minutos

---

#### Paso 4.2 - Verificar el Resultado

Al finalizar verás un resumen como este:

```
═══════════════════════ RESUMEN ═══════════════════════
  ✓ GPU Intel detectada correctamente
  ✓ Mesa instalado (vXX.X.X)
  ✓ TLP habilitado
  ✓ thermald habilitado
═══════════════════════════════════════════════════════
```

**✅ Verificación:** Todos los items deben tener ✓ verde

---

### FASE 5: Reinicio del Sistema

#### Paso 5.1 - Reiniciar

```bash
# Reiniciar el sistema para aplicar todos los cambios
sudo reboot
```

**⚠️ IMPORTANTE:** Este reinicio es **OBLIGATORIO** para que:
- Se carguen los parámetros del kernel de Intel
- Se active el nuevo bootloader con tema
- Se carguen los módulos GuC/HuC
- TLP y thermald se inicien correctamente
- SDDM se active como display manager

---

### FASE 6: Primer Inicio con HyDE

#### Paso 6.1 - Iniciar Sesión

Al reiniciar verás:

1. **GRUB con tema Retroboot** (si elegiste ese tema)
2. **SDDM con tema Corners/Candy** (pantalla de login)

**Acciones:**

```
1. Selecciona tu usuario
2. Ingresa tu contraseña
3. ANTES de presionar Enter:
   - Clic en el ícono superior derecho (selector de sesión)
   - Selecciona "Hyprland" (no "i3", no "System")
4. Ahora sí, presiona Enter o clic en "Login"
```

---

#### Paso 6.2 - Primera Carga de Hyprland

La primera vez puede tardar 10-30 segundos en cargar porque:
- Se generan caches de wallpapers
- Se compilan shaders de Hyprland
- Se inicializan temas

**✅ Verificación de Carga Exitosa:**
- Debes ver tu wallpaper
- Waybar arriba (barra de estado)
- Cursor funcional
- Brillo ajustable con teclas Fn

---

### FASE 7: Verificaciones Post-Instalación

> **¡Importante!** Realiza estas verificaciones para asegurar que todo funcione correctamente.

#### Prueba 7.1 - Control de Brillo

```bash
# Abrir terminal: Super + Enter (o Super + T)

# Probar control de brillo
brightnessctl set 25%    # Bajar al 25%
brightnessctl set 75%    # Subir al 75%
brightnessctl set 50%    # Volver al 50%
```

**✅ Debe:** Cambiar el brillo de la pantalla visiblemente

**❌ Si no funciona:**
```bash
# Verificar parámetro en kernel
cat /proc/cmdline | grep i915.enable_dpcd_backlight

# Debe mostrar: i915.enable_dpcd_backlight=3
# Si NO aparece, revisar Solución de Problemas al final
```

---

#### Prueba 7.2 - Aceleración de Hardware (VA-API)

```bash
# Verificar driver de video
vainfo

# Debe mostrar:
# libva info: Driver version: Intel iHD driver for Intel(R) Gen Graphics
```

**✅ Si ves "iHD driver"** - Aceleración de hardware funcionando ✓

---

#### Prueba 7.3 - GPU Intel

```bash
# Monitorear GPU en tiempo real
sudo intel_gpu_top

# Debes ver:
# - Frecuencia actual de GPU
# - Uso de GPU
# - Memory usage
# Presiona 'q' para salir
```

---

#### Prueba 7.4 - TLP (Gestión de Energía)

```bash
# Ver estado de TLP
sudo tlp-stat -s

# Debe mostrar:
# +++ TLP Status
# State          = enabled
# Mode           = battery (o AC si está conectado)
```

---

#### Prueba 7.5 - GuC/HuC Firmware

```bash
# Verificar GuC
sudo dmesg | grep -i guc | tail -5

# Debe mostrar algo como:
# i915 0000:00:02.0: [drm] GuC firmware i915/adlp_guc_70.bin version 70.x.x
# i915 0000:00:02.0: [drm] GuC submission enabled

# Verificar HuC
sudo dmesg | grep -i huc | tail -5
```

**✅ Si ves versiones de firmware** - GuC/HuC activos correctamente

---

#### Prueba 7.6 - WiFi

```bash
# Verificar WiFi
nmcli device status

# Debe mostrar tu WiFi como "connected"

# Speed test
ping -c 4 google.com
```

---

#### Prueba 7.7 - Audio

```bash
# Probar audio
speaker-test -c 2 -t wav

# O abrir un video de YouTube en el navegador
```

---

### FASE 8: Configuración Inicial de HyDE

#### Paso 8.1 - Conocer Atajos de Teclado Básicos

| Atajo | Acción |
|-------|--------|
| `Super + Enter` | Abrir terminal |
| `Super + Q` | Cerrar ventana activa |
| `Super + T` | Cambiar tema |
| `Super + W` | Cambiar wallpaper |
| `Super + E` | Abrir file manager |
| `Super + Space` | Rofi (launcher de apps) |
| `Super + L` | Bloquear pantalla |
| `Super + Shift + E` | Menú de apagado |
| `Super + Tab` | Cambiar entre ventanas |
| `Print` | Screenshot |
| `Fn + Brillo` | Ajustar brillo |

> 📖 **Guía completa:** Ver archivo `KEYBINDINGS.md` en el repositorio

---

#### Paso 8.2 - Seleccionar Tema Oscuro (Recomendado para AMOLED)

```bash
# Abrir selector de temas
# Super + T

# O desde terminal:
hyde theme select
```

**Temas recomendados para AMOLED:**
1. **Catppuccin Mocha** - Oscuro elegante
2. **Tokyo Night** - Oscuro con buenos contrastes
3. **Gruvbox Dark** - Oscuro clásico
4. **Decay Green** - Oscuro matrix-style
5. **Rosé Pine Moon** - Oscuro suave

**❌ Evita temas claros** - Gastan más batería en AMOLED

---

#### Paso 8.3 - Configurar Wallpaper

```bash
# Cambiar wallpaper
# Super + W

# O desde terminal:
hyde wallpaper select
```

**Tip:** Elige wallpapers oscuros para maximizar duración de batería.

---

#### Paso 8.4 - Configurar Aplicaciones por Defecto

```bash
# Navegador web predeterminado
xdg-settings set default-web-browser firefox.desktop

# File manager predeterminado
xdg-mime default thunar.desktop inode/directory

# Editor de texto
xdg-mime default code.desktop text/plain
```

---

### FASE 9: Optimizaciones Opcionales

> Estas son opcionales pero muy recomendadas para tu laptop.

#### Optimización 9.1 - Ajustar Parámetros Adicionales del Kernel

```bash
# Editar GRUB
sudo nano /etc/default/grub

# Buscar la línea GRUB_CMDLINE_LINUX_DEFAULT
# Debe tener al menos: i915.enable_dpcd_backlight=3

# OPCIONAL - Agregar para mejor rendimiento/batería:
# i915.enable_fbc=1 i915.enable_psr=2 i915.fastboot=1

# Ejemplo completo:
# GRUB_CMDLINE_LINUX_DEFAULT="quiet splash i915.enable_dpcd_backlight=3 i915.enable_fbc=1 i915.enable_psr=2"

# Guardar: Ctrl+O, Enter, Ctrl+X

# Regenerar GRUB
sudo grub-mkconfig -o /boot/grub/grub.cfg

# Reiniciar para aplicar
sudo reboot
```

---

#### Optimización 9.2 - Configurar Gestos de Touchpad

```bash
# Instalar libinput-gestures (si no está)
yay -S libinput-gestures

# Habilitar para tu usuario
sudo gpasswd -a $USER input

# Habilitar autostart
systemctl --user enable libinput-gestures.service

# Reiniciar sesión para aplicar
```

Los gestos ya están configurados en `~/.config/libinput-gestures.conf` por el script.

---

#### Optimización 9.3 - Configurar Auto-hide para Waybar (Evitar Burn-in)

```bash
# Editar configuración de Waybar
nano ~/.config/waybar/config.jsonc

# Buscar la sección principal y agregar:
# "mode": "hide",

# Guardar y recargar Waybar: Super + Shift + R
```

---

### FASE 10: Mantenimiento y Actualizaciones

#### Actualizar el Sistema

```bash
# Actualizar paquetes oficiales
sudo pacman -Syu

# Actualizar paquetes AUR
yay -Syu

# Actualizar HyDE (si hay nuevas versiones)
cd ~/HyDE/Scripts
git pull
./install.sh -r  # Solo restaurar configs
```

---

#### Limpiar Sistema

```bash
# Limpiar cache de pacman
sudo pacman -Sc

# Limpiar cache de yay
yay -Sc

# Limpiar paquetes huérfanos
sudo pacman -Rns $(pacman -Qtdq)
```

---

## 🔧 SOLUCIÓN DE PROBLEMAS

### ❌ Problema: Brillo no funciona

**Solución:**

```bash
# 1. Verificar parámetro del kernel
cat /proc/cmdline | grep i915

# 2. Si NO aparece i915.enable_dpcd_backlight=3:
sudo nano /etc/default/grub

# 3. Agregar manualmente en GRUB_CMDLINE_LINUX_DEFAULT
# GRUB_CMDLINE_LINUX_DEFAULT="quiet splash i915.enable_dpcd_backlight=3"

# 4. Regenerar GRUB
sudo grub-mkconfig -o /boot/grub/grub.cfg

# 5. Reiniciar
sudo reboot
```

---

### ❌ Problema: Pantalla parpadea

**Solución:**

```bash
# Deshabilitar PSR temporalmente
echo 0 | sudo tee /sys/module/i915/parameters/enable_psr

# Si funciona, hacer permanente:
sudo nano /etc/modprobe.d/i915.conf
# Agregar: options i915 enable_psr=0

# Regenerar initramfs
sudo mkinitcpio -P
sudo reboot
```

---

### ❌ Problema: Batería se drena muy rápido

**Solución:**

```bash
# Verificar que TLP está activo
sudo systemctl status tlp

# Si no está activo:
sudo systemctl enable --now tlp.service

# Ver consumo actual
sudo powertop

# Optimizar automáticamente (solo primera vez)
sudo powertop --auto-tune
```

---

### ❌ Problema: WiFi lento o inestable

**Solución:**

```bash
# Verificar configuración
cat /etc/modprobe.d/iwlwifi.conf

# Debe contener:
# options iwlwifi power_save=1
# options iwlwifi 11n_disable=0

# Si no está, crear:
sudo nano /etc/modprobe.d/iwlwifi.conf
# Agregar las líneas de arriba

# Recargar módulo
sudo modprobe -r iwlwifi
sudo modprobe iwlwifi
```

---

### ❌ Problema: Hyprland no inicia / Pantalla negra

**Solución:**

```bash
# 1. En SDDM, presiona Ctrl+Alt+F2 (TTY2)
# 2. Login con tu usuario/password

# 3. Ver logs de Hyprland
cat ~/.cache/hyde/logs/*/install.sh.log | tail -50

# 4. Verificar errores específicos
# Si ves error de intel_gpu_top o similar:

# Reinstalar mesa
sudo pacman -S mesa --overwrite '*'

# Reintentar login a Hyprland
sudo systemctl restart sddm
```

---

### ❌ Problema: Tearing en videos

**Solución:**

```bash
# Editar configuración de Hyprland
nano ~/.config/hypr/hyprland.conf

# Agregar al final:
# env = WLR_DRM_NO_ATOMIC,1

# Guardar y recargar: Super + Shift + R
```

---

### ❌ Problema: TLP no se inicia automáticamente

**Solución:**

```bash
# Verificar servicios
systemctl status tlp

# Enmascarar servicios conflictivos
sudo systemctl mask systemd-rfkill.service
sudo systemctl mask systemd-rfkill.socket

# Habilitar TLP
sudo systemctl enable --now tlp.service

# Verificar
sudo tlp-stat -s
```

---

## 📊 MÉTRICAS DE RENDIMIENTO ESPERADAS

Con esta configuración deberías obtener:

| Métrica | Valor Esperado |
|---------|----------------|
| **Duración de batería (uso normal)** | 6-8 horas |
| **Duración de batería (uso intenso)** | 4-5 horas |
| **Temperatura idle** | 35-45°C |
| **Temperatura bajo carga** | 55-75°C |
| **FPS en Hyprland (animaciones)** | 60 FPS constante |
| **Uso de RAM idle** | 1.5-2.5 GB |
| **Tiempo de boot** | 15-25 segundos |
| **Tiempo de login Hyprland** | 3-8 segundos |

---

## 📚 RECURSOS ADICIONALES

| Recurso | Ubicación |
|---------|-----------|
| **Documentación completa** | `GALAXY_BOOK_2_PRO_SETUP.md` |
| **Lista de paquetes** | `Scripts/pkg_user_galaxybook2pro.lst` |
| **Atajos de teclado** | `KEYBINDINGS.md` |
| **Changelog personalizado** | `CHANGELOG_CUSTOM.md` |
| **Script de setup** | `Scripts/galaxybook2pro_setup.sh` |

---

## ✅ CHECKLIST FINAL

Después de completar la instalación, verifica:

- [ ] Brillo ajustable con teclas Fn
- [ ] WiFi conectado y estable
- [ ] Audio funcionando (parlantes y micrófono)
- [ ] Terminal abre con Super + Enter
- [ ] Rofi abre con Super + Space
- [ ] Tema oscuro seleccionado
- [ ] Wallpaper configurado
- [ ] TLP habilitado (`sudo tlp-stat -s`)
- [ ] thermald activo (`systemctl status thermald`)
- [ ] GuC/HuC cargados (`sudo dmesg | grep -i guc`)
- [ ] VA-API funcional (`vainfo`)
- [ ] GPU monitoreable (`sudo intel_gpu_top`)
- [ ] Batería durando >6 horas (uso normal)
- [ ] Sistema responsivo y fluido

---

## 🎉 ¡FELICITACIONES!

Si llegaste hasta aquí, tienes HyDE completamente instalado y optimizado para tu Galaxy Book 2 Pro.

### Próximos Pasos Sugeridos:

1. **Explora los temas** - `Super + T`
2. **Cambia wallpapers** - `Super + W`
3. **Lee los atajos** - `KEYBINDINGS.md`
4. **Personaliza** - Edita `~/.config/hypr/userprefs.conf`
5. **Únete a Discord** - [HyDE Community](https://discord.gg/qWehcFJxPa)

---

**Versión:** 1.0.0  
**Fecha:** Febrero 17, 2026  
**Hardware:** Samsung Galaxy Book 2 Pro  
**Sistema:** Arch Linux + HyDE (Hyprland)

**Documentado por:** Configuración personalizada para Intel i7-1260P
