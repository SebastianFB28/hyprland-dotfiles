#!/usr/bin/env bash
# install.sh
# Punto de entrada único del setup. Orquesta los scripts de scripts-config/
# en el orden correcto: primero instala, después coloca los archivos,
# y por último configura el tema de login.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "============================================="
echo "  Hyprland Setup"
echo "============================================="
echo ""

# -----------------------------------------------------
# 1) Instalar paquetes y dependencias
# -----------------------------------------------------
echo "==> Paso 1/3: Instalando paquetes..."
bash "$SCRIPT_DIR/scripts-config/install_packages.sh"

# -----------------------------------------------------
# 2) Colocar los archivos de configuración
# -----------------------------------------------------
echo ""
echo "==> Paso 2/3: Copiando archivos de configuración..."
bash "$SCRIPT_DIR/scripts-config/copy_configs.sh"

# -----------------------------------------------------
# 3) Configurar el tema de login (SDDM)
# -----------------------------------------------------
echo ""
echo "==> Paso 3/3: Configurando tema de login..."
bash "$SCRIPT_DIR/scripts-config/setup_sddm_theme.sh"

echo ""
echo "============================================="
echo "  ✅ Setup completo. Reinicia Hyprland para aplicar los cambios."
echo "============================================="
