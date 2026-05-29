#!/usr/bin/env bash
#==============================================================================
# SYCRONIX Framework - Uninstaller
# Author: SYCRONIX
# License: MIT
#==============================================================================
set -e

CYAN="\033[0;36m"
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
BOLD="\033[1m"
RESET="\033[0m"

SYCRONIX_BIN_DIR="${PREFIX:-/data/data/com.termux/files/usr}/bin"
SYCRONIX_INSTALL_DIR="${HOME}/.config/sycronix"
SYCRONIX_BACKUP_DIR="${HOME}/.config/sycronix-backups"

__header() {
  echo -e "${RED}${BOLD}"
  echo "  ╔═══════════════════════════════════════════╗"
  echo "  ║         SYCRONIX UNINSTALLER              ║"
  echo "  ╚═══════════════════════════════════════════╝"
  echo -e "${RESET}\n"
}

__remove_commands() {
  echo -e "  ${CYAN}━━━ Removing SYCRONIX ━━━${RESET}\n"
  local commands=("sycronix" "sycronix-config" "sycronix-theme" "sycronix-update" "sycronix-reset" "sycronix-version")
  for cmd in "${commands[@]}"; do
    if [[ -f "${SYCRONIX_BIN_DIR}/${cmd}" ]]; then
      rm -f "${SYCRONIX_BIN_DIR}/${cmd}"
      echo -e "  ${GREEN}✗${RESET} Removed: ${cmd}"
    fi
  done
}

__remove_config() {
  if [[ -d "$SYCRONIX_INSTALL_DIR" ]]; then
    rm -rf "$SYCRONIX_INSTALL_DIR"
    echo -e "  ${GREEN}✗${RESET} Removed: ${SYCRONIX_INSTALL_DIR}"
  fi
}

__clean_shell_rc() {
  local rc_files=("${HOME}/.bashrc" "${HOME}/.zshrc" "${HOME}/.bash_profile")
  for rc in "${rc_files[@]}"; do
    if [[ -f "$rc" ]]; then
      if grep -q "SYCRONIX" "$rc" 2>/dev/null; then
        sed -i '/# SYCRONIX/d' "$rc" 2>/dev/null || true
        sed -i '/sycronix/d' "$rc" 2>/dev/null || true
        echo -e "  ${GREEN}✗${RESET} Cleaned: $(basename "$rc")"
      fi
    fi
  done
}

__done() {
  echo ""
  echo -e "  ${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
  echo -e "  ${RED}${BOLD}  SYCRONIX has been uninstalled.${RESET}"
  echo -e "  ${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
  echo ""
  echo -e "  ${YELLOW}Backups preserved at:${RESET}"
  echo -e "  ${CYAN}${SYCRONIX_BACKUP_DIR}${RESET}"
  echo ""
}

#--- Main ---
__header
echo -e "  ${YELLOW}This will remove SYCRONIX Framework from your system.${RESET}"
echo -e "  ${YELLOW}Your backups are preserved in: ${SYCRONIX_BACKUP_DIR}${RESET}\n"
echo -ne "  ${CYAN}Are you sure you want to uninstall? [y/N]: ${RESET}"
read -r confirm

if [[ "$confirm" != "y" ]] && [[ "$confirm" != "Y" ]]; then
  echo -e "\n  ${YELLOW}Uninstall cancelled.${RESET}"
  exit 0
fi

__remove_commands
__remove_config
__clean_shell_rc
__done
