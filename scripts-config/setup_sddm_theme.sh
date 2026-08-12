#!/usr/bin/env bash
# scripts-config/setup_sddm_theme.sh
# Activa sddm-astronaut-theme (variante hyprland_kath) como login manager.
# A diferencia de copy_configs.sh, este script toca archivos del SISTEMA
# (/etc y /usr/share), no solo tu $HOME — por eso vive aparte y usa sudo.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"

THEME_DIR="/usr/share/sddm/themes/sddm-astronaut-theme"
METADATA="$THEME_DIR/metadata.desktop"
VARIANT="hyprland_kath"
BACKGROUND_FILENAME="1-eyes-wide.jpg"

echo "==> Configurando tema de login (sddm-astronaut-theme)..."

# -----------------------------------------------------
# Verificar que el tema esté instalado
# -----------------------------------------------------
if [ ! -f "$METADATA" ]; then
    echo "‼️  El tema no está instalado en $THEME_DIR"
    echo "    Corre primero install_packages.sh (instala sddm-astronaut-theme vía AUR)."
    exit 1
fi

# -----------------------------------------------------
# Copiar el fondo personalizado, si el repo lo trae
# -----------------------------------------------------
CUSTOM_BG="$REPO_ROOT/sddm/Backgrounds/$BACKGROUND_FILENAME"
if [ -f "$CUSTOM_BG" ]; then
    echo "  → Copiando fondo personalizado: $BACKGROUND_FILENAME"
    sudo cp "$CUSTOM_BG" "$THEME_DIR/Backgrounds/$BACKGROUND_FILENAME"
else
    if [ -f "$THEME_DIR/Backgrounds/$BACKGROUND_FILENAME" ]; then
        echo "  ✓ $BACKGROUND_FILENAME ya existe en el tema (viene de fábrica o de una corrida anterior)."
    else
        echo "  ⚠ No se encontró '$BACKGROUND_FILENAME' ni en el repo ni en el tema instalado."
        echo "    El login puede quedar sin fondo hasta que agregues la imagen a $REPO_ROOT/sddm/Backgrounds/"
    fi
fi

# -----------------------------------------------------
# Seleccionar la variante correcta dentro del tema
# -----------------------------------------------------
if [ ! -f "$THEME_DIR/Themes/${VARIANT}.conf" ]; then
    echo "‼️  No existe la variante '$VARIANT' en $THEME_DIR/Themes/"
    exit 1
fi

echo "  → Seleccionando variante: $VARIANT"
sudo sed -i "s|^ConfigFile=.*|ConfigFile=Themes/${VARIANT}.conf|" "$METADATA"

# -----------------------------------------------------
# Activar sddm-astronaut-theme como tema de SDDM
# -----------------------------------------------------
# Usamos /etc/sddm.conf.d/ (no /etc/sddm.conf directo) para no pisar
# ninguna otra configuración de sddm que ya tengas.
echo "  → Activando el tema en sddm.conf.d..."
sudo mkdir -p /etc/sddm.conf.d
echo -e "[Theme]\nCurrent=sddm-astronaut-theme" | sudo tee /etc/sddm.conf.d/theme.conf > /dev/null

echo ""
echo "✅ Tema de login configurado."
echo "ℹ️  Puedes previsualizarlo SIN cerrar sesión con:"
echo "    sddm-greeter-qt6 --test-mode --theme $THEME_DIR"