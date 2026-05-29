#!/usr/bin/env bash
#==============================================================================
# SYCRONIX Framework - Installer
# Author: SYCRONIX
# License: MIT
#
# One-command installation:
#   curl -fsSL https://github.com/officialsycronix/sycronix-banner/raw/main/install.sh | bash
#==============================================================================
set -e

#--- Configuration ---
SYCRONIX_VERSION="1.0.0"
SYCRONIX_REPO="https://github.com/officialsycronix/sycronix-banner"
SYCRONIX_RAW="https://raw.githubusercontent.com/officialsycronix/sycronix-banner/main"

#--- Colors ---
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
CYAN="\033[0;36m"
MAGENTA="\033[0;35m"
BOLD="\033[1m"
RESET="\033[0m"

#--- Paths ---
SYCRONIX_SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SYCRONIX_INSTALL_DIR="${HOME}/.config/sycronix"
SYCRONIX_BIN_DIR="${PREFIX:-/data/data/com.termux/files/usr}/bin"
SYCRONIX_BACKUP_DIR="${HOME}/.config/sycronix-backups"

#--- Banner ---
__banner() {
  echo -e "${CYAN}${BOLD}"
  echo "  ███████╗██╗   ██╗ ██████╗██████╗  ██████╗ ███╗   ██╗██╗██╗  ██╗"
  echo "  ██╔════╝╚██╗ ██╔╝██╔════╝██╔══██╗██╔═══██╗████╗  ██║██║╚██╗██╔╝"
  echo "  ███████╗ ╚████╔╝ ██║     ██████╔╝██║   ██║██╔██╗ ██║██║ ╚███╔╝ "
  echo "  ╚════██║  ╚██╔╝  ██║     ██╔══██╗██║   ██║██║╚██╗██║██║ ██╔██╗ "
  echo "  ███████║   ██║   ╚██████╗██║  ██║╚██████╔╝██║ ╚████║██║██╔╝ ██╗"
  echo "  ╚══════╝   ╚═╝    ╚═════╝╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝╚═╝  ╚═╝"
  echo -e "${RESET}"
  echo -e "${MAGENTA}  SYCRONIX Framework v${SYCRONIX_VERSION} — Installer${RESET}"
  echo -e "${CYAN}  CYBER ENVIRONMENT for Termux${RESET}\n"
}

#--- Detect Termux ---
__detect_termux() {
  if [[ -d "/data/data/com.termux" ]] || [[ -n "$PREFIX" ]]; then
    echo -e "  ${GREEN}✓${RESET} Termux detected: ${PREFIX:-/data/data/com.termux/files/usr}"
    return 0
  fi
  echo -e "  ${YELLOW}⚠${RESET} Not running in Termux. Some features may not work."
  echo -e "  ${YELLOW}  Continuing with standard Linux installation.${RESET}"
  return 0
}

#--- Backup existing configuration ---
__backup() {
  if [[ -d "$SYCRONIX_INSTALL_DIR" ]] && [[ -f "${SYCRONIX_INSTALL_DIR}/sycronix.conf" ]]; then
    mkdir -p "$SYCRONIX_BACKUP_DIR"
    local backup_file="${SYCRONIX_BACKUP_DIR}/sycronix-backup-$(date +%Y%m%d-%H%M%S).conf"
    cp "${SYCRONIX_INSTALL_DIR}/sycronix.conf" "$backup_file"
    echo -e "  ${GREEN}✓${RESET} Existing config backed up to: ${backup_file}"
  fi
}

#--- Backup shell rc ---
__backup_shell_rc() {
  local rc_files=("${HOME}/.bashrc" "${HOME}/.zshrc" "${HOME}/.bash_profile")
  for rc in "${rc_files[@]}"; do
    if [[ -f "$rc" ]]; then
      mkdir -p "$SYCRONIX_BACKUP_DIR"
      cp "$rc" "${SYCRONIX_BACKUP_DIR}/$(basename "$rc")-backup-$(date +%Y%m%d-%H%M%S)"
      echo -e "  ${GREEN}✓${RESET} Backed up: $(basename "$rc")"
    fi
  done
}

#--- Create Custom Banner ---
__create_custom_banner() {
  echo ""
  echo -e "  ${CYAN}━━━ Create Your Custom Banner ━━━${RESET}\n"
  echo -e "  ${YELLOW}Type your own banner text. SYCRONIX will display it on terminal start.${RESET}"
  echo -e "  ${YELLOW}You can use colors like:${RESET} \033[0;36m\${SYCRONIX_COLOR_PRIMARY}\033[0m, \033[0;35m\${SYCRONIX_COLOR_SECONDARY}\033[0m, \033[0;33m\${SYCRONIX_COLOR_ACCENT}\033[0m"
  echo -e "  ${YELLOW}Type END on a new line when finished.${RESET}\n"

  echo -e "  ${CYAN}Enter your banner (multi-line allowed, END to finish):${RESET}"
  echo ""

  local banner_lines=()
  while IFS= read -r line; do
    if [[ "$line" == "END" ]]; then
      break
    fi
    banner_lines+=("$line")
  done

  if [[ ${#banner_lines[@]} -eq 0 ]]; then
    echo -e "\n  ${YELLOW}No input given. Using default cyber banner.${RESET}"
    SYCRONIX_SELECTED_BANNER="cyber"
    return
  fi

  # Save as custom banner
  mkdir -p "${HOME}/.config/sycronix/banners"
  local custom_file="${HOME}/.config/sycronix/banners/custom.banner"
  SYCRONIX_SELECTED_BANNER="custom"

  cat > "$custom_file" << BANNEREOF
#==============================================================================
# SYCRONIX Banner: Custom
# User-created custom banner
#==============================================================================
BANNER_NAME="Custom"
BANNER_DESC="Your custom banner"

__sycronix_banner_custom() {
  echo -e "
$(printf '%s\n' "${banner_lines[@]}")
"
}
BANNEREOF

  echo -e "\n  ${GREEN}✓${RESET} Your custom banner saved!"

  # Show preview
  echo ""
  echo -e "  ${CYAN}━━━ Banner Preview ━━━${RESET}"
  echo -e "${SYCRONIX_COLOR_PRIMARY}"
  for line in "${banner_lines[@]}"; do
    echo -e "  $line"
  done
  echo -e "${SYCRONIX_COLOR_RESET}"
  echo -e "  ${CYAN}━━━━━━━━━━━━━━━━━━━━${RESET}\n"
  echo -ne "  ${CYAN}Is this okay? [Y/n]: ${RESET}"
  read -r confirm
  if [[ "$confirm" == "n" ]] || [[ "$confirm" == "N" ]]; then
    SYCRONIX_SELECTED_BANNER="cyber"
    echo -e "  ${YELLOW}Using default cyber banner instead.${RESET}"
  fi
}

#--- Install files ---
__install() {
  echo ""
  echo -e "  ${CYAN}━━━ Installing SYCRONIX Files ━━━${RESET}\n"

  # Create directories
  mkdir -p "${SYCRONIX_INSTALL_DIR}"/{themes,banners,prompts,plugins,cache}

  # Copy source files
  local copy_dirs=("themes" "banners" "prompts" "plugins")
  for dir in "${copy_dirs[@]}"; do
    if [[ -d "${SYCRONIX_SOURCE_DIR}/${dir}" ]]; then
      cp -r "${SYCRONIX_SOURCE_DIR}/${dir}"/* "${SYCRONIX_INSTALL_DIR}/${dir}/" 2>/dev/null || true
      echo -e "  ${GREEN}✓${RESET} Installed ${dir}"
    fi
  done

  # Install config with selected banner
  if [[ ! -f "${SYCRONIX_INSTALL_DIR}/sycronix.conf" ]]; then
    if [[ -f "${SYCRONIX_SOURCE_DIR}/config/default.conf" ]]; then
      cp "${SYCRONIX_SOURCE_DIR}/config/default.conf" "${SYCRONIX_INSTALL_DIR}/sycronix.conf"
      sed -i "s/^SYCRONIX_BANNER=.*/SYCRONIX_BANNER=\"${SYCRONIX_SELECTED_BANNER}\"/" "${SYCRONIX_INSTALL_DIR}/sycronix.conf"
      echo -e "  ${GREEN}✓${RESET} Installed default configuration"
    fi
  fi

  # Install CLI commands
  local commands=("sycronix" "sycronix-config" "sycronix-theme" "sycronix-update" "sycronix-reset" "sycronix-version")
  for cmd in "${commands[@]}"; do
    if [[ -f "${SYCRONIX_SOURCE_DIR}/${cmd}" ]]; then
      cp "${SYCRONIX_SOURCE_DIR}/${cmd}" "${SYCRONIX_BIN_DIR}/${cmd}"
      chmod +x "${SYCRONIX_BIN_DIR}/${cmd}"
      echo -e "  ${GREEN}✓${RESET} Installed command: ${cmd}"
    fi
  done

  # Create config directory symlink
  if [[ ! -L "${SYCRONIX_INSTALL_DIR}/config" ]]; then
    ln -sf "${SYCRONIX_INSTALL_DIR}" "${SYCRONIX_INSTALL_DIR}/config" 2>/dev/null || true
  fi
}

#--- Add to shell rc ---
__setup_shell() {
  echo ""
  echo -e "  ${CYAN}━━━ Configuring Shell ━━━${RESET}\n"

  local rc_file=""
  if [[ -n "$BASH_VERSION" ]]; then
    rc_file="${HOME}/.bashrc"
  elif [[ -n "$ZSH_VERSION" ]]; then
    rc_file="${HOME}/.zshrc"
  else
    rc_file="${HOME}/.bashrc"
  fi

  local source_line="[[ -f \"${SYCRONIX_BIN_DIR}/sycronix\" ]] && source \"${SYCRONIX_BIN_DIR}/sycronix\""

  # Check if already configured
  if grep -q "SYCRONIX" "$rc_file" 2>/dev/null; then
    echo -e "  ${YELLOW}⚠${RESET} SYCRONIX already configured in $(basename "$rc_file")"
    echo -e "  ${YELLOW}  Skipping shell setup.${RESET}"
    return
  fi

  echo "" >> "$rc_file"
  echo "# SYCRONIX Framework - Cyber Environment" >> "$rc_file"
  echo "# https://github.com/officialsycronix/sycronix-banner" >> "$rc_file"
  echo "$source_line" >> "$rc_file"

  echo -e "  ${GREEN}✓${RESET} Added SYCRONIX to $(basename "$rc_file")"
}

#--- Verify installation ---
__verify() {
  echo ""
  echo -e "  ${CYAN}━━━ Verifying Installation ━━━${RESET}\n"

  local all_ok=true

  for cmd in sycronix sycronix-config sycronix-theme; do
    if [[ -x "${SYCRONIX_BIN_DIR}/${cmd}" ]]; then
      echo -e "  ${GREEN}✓${RESET} ${cmd} found in PATH"
    else
      echo -e "  ${RED}✗${RESET} ${cmd} not found!"
      all_ok=false
    fi
  done

  if [[ -f "${SYCRONIX_INSTALL_DIR}/sycronix.conf" ]]; then
    echo -e "  ${GREEN}✓${RESET} Configuration file found"
  else
    echo -e "  ${RED}✗${RESET} Configuration file missing!"
    all_ok=false
  fi

  if [[ -d "${SYCRONIX_INSTALL_DIR}/themes" ]]; then
    echo -e "  ${GREEN}✓${RESET} Themes directory found"
  fi
  if [[ -d "${SYCRONIX_INSTALL_DIR}/banners" ]]; then
    echo -e "  ${GREEN}✓${RESET} Banners directory found"
  fi
  if [[ -d "${SYCRONIX_INSTALL_DIR}/prompts" ]]; then
    echo -e "  ${GREEN}✓${RESET} Prompts directory found"
  fi
  if [[ -d "${SYCRONIX_INSTALL_DIR}/plugins" ]]; then
    echo -e "  ${GREEN}✓${RESET} Plugins directory found"
  fi

  if $all_ok; then
    echo -e "\n  ${GREEN}${BOLD}✓ SYCRONIX installed successfully!${RESET}"
  else
    echo -e "\n  ${RED}${BOLD}✗ Some components failed to install.${RESET}"
    echo -e "  ${YELLOW}  Try reinstalling or check permissions.${RESET}"
  fi
}

#--- Completion message ---
__done() {
  echo ""
  echo -e "  ${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
  echo -e "  ${GREEN}${BOLD}  SYCRONIX CYBER ENVIRONMENT v${SYCRONIX_VERSION}${RESET}"
  echo -e "  ${GREEN}  ACCESS GRANTED — WELCOME BACK ${USER}${RESET}"
  echo -e "  ${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
  echo ""
  echo -e "  ${YELLOW}To start using SYCRONIX:${RESET}"
  echo -e "    1. Restart your terminal"
  echo -e "    2. Or run: ${CYAN}source ~/.bashrc${RESET}"
  echo ""
  echo -e "  ${YELLOW}Commands:${RESET}"
  echo -e "    ${CYAN}sycronix${RESET}          Initialize environment"
  echo -e "    ${CYAN}sycronix-config${RESET}   Open configuration wizard"
  echo -e "    ${CYAN}sycronix-theme${RESET}    Change themes"
  echo -e "    ${CYAN}sycronix-update${RESET}   Check for updates"
  echo -e "    ${CYAN}sycronix-reset${RESET}    Reset to defaults"
  echo -e "    ${CYAN}sycronix-version${RESET}  Version info"
  echo ""
}

#--- Cleanup on error ---
__cleanup() {
  echo -e "\n  ${RED}Installation failed! Rolling back...${RESET}"
  local commands=("sycronix" "sycronix-config" "sycronix-theme" "sycronix-update" "sycronix-reset" "sycronix-version")
  for cmd in "${commands[@]}"; do
    rm -f "${SYCRONIX_BIN_DIR}/${cmd}" 2>/dev/null || true
  done
  echo -e "  ${YELLOW}Rollback complete.${RESET}"
  exit 1
}

#--- Main ---
trap __cleanup ERR

clear
__banner
__detect_termux
__create_custom_banner
__backup
__backup_shell_rc
__install
__setup_shell
__verify
__done
