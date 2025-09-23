#!/usr/bin/env bash
# install-vim.sh
# Usage: bash install-vim.sh [path-to-vimrc]
# Default vimrc source: ./vim_folder/.vimrc
set -euo pipefail
IFS=$'\n\t'

# --------- Config ----------
VUNDLE_REPO="https://github.com/VundleVim/Vundle.vim.git"
DEFAULT_VIMRC_SOURCE="./vim_folder/.vimrc"   # default to ./vim_folder/.vimrc as requested
VIMRC_TARGET="${HOME}/.vimrc"
VUNDLE_DIR="${HOME}/.vim/bundle/Vundle.vim"
YCM_DIR="${HOME}/.vim/bundle/YouCompleteMe"
INSTALL_YCM="yes"   # set to "no" to skip building YCM
# ---------------------------

print() { printf "\n==> %s\n" "$1"; }
err() { printf "\n[ERROR] %s\n" "$1" >&2; }

# Allow override by argument (still defaults to ./vim_folder/.vimrc)
if [ "${#}" -ge 1 ]; then
  DEFAULT_VIMRC_SOURCE="$1"
fi

if [ ! -f "${DEFAULT_VIMRC_SOURCE}" ]; then
  err "Vimrc source file not found: ${DEFAULT_VIMRC_SOURCE}"
  err "Put your .vimrc in ./vim_folder/.vimrc or pass its path as argument."
  exit 2
fi

# Detect package manager
detect_pkg_manager() {
  if command -v apt-get >/dev/null 2>&1; then
    echo "apt"
  elif command -v dnf >/dev/null 2>&1; then
    echo "dnf"
  elif command -v pacman >/dev/null 2>&1; then
    echo "pacman"
  elif command -v zypper >/dev/null 2>&1; then
    echo "zypper"
  else
    echo "unsupported"
  fi
}

PKG_MANAGER="$(detect_pkg_manager)"
if [ "${PKG_MANAGER}" = "unsupported" ]; then
  err "No supported package manager found (apt/dnf/pacman/zypper). Exiting."
  exit 3
fi
print "Detected package manager: ${PKG_MANAGER}"

install_packages() {
  local pkgs=("$@")
  case "${PKG_MANAGER}" in
    apt)
      sudo DEBIAN_FRONTEND=noninteractive apt-get update -y
      sudo apt-get install -y "${pkgs[@]}" || { err "apt install failed"; exit 4; }
      ;;
    dnf)
      sudo dnf install -y "${pkgs[@]}" || { err "dnf install failed"; exit 4; }
      ;;
    pacman)
      sudo pacman -Sy --noconfirm "${pkgs[@]}" || { err "pacman install failed"; exit 4; }
      ;;
    zypper)
      sudo zypper --non-interactive install "${pkgs[@]}" || { err "zypper install failed"; exit 4; }
      ;;
  esac
}

print "Installing base packages (may ask for sudo password)..."
case "${PKG_MANAGER}" in
  apt)
    UBUNTU_PKGS=(git vim-nox build-essential cmake python3-dev python3-pip \
                 mono-complete golang nodejs openjdk-17-jdk npm)
    install_packages "${UBUNTU_PKGS[@]}"
    ;;
  dnf)
    FEDORA_PKGS=(git vim-enhanced gcc-c++ make cmake python3-devel python3-pip \
                 mono-core golang nodejs java-17-openjdk-devel npm)
    install_packages "${FEDORA_PKGS[@]}"
    ;;
  pacman)
    ARCH_PKGS=(git vim base-devel cmake python python-pip go nodejs jdk-openjdk npm)
    install_packages "${ARCH_PKGS[@]}"
    ;;
  zypper)
    SLES_PKGS=(git vim gcc-c++ make cmake python3-devel python3-pip \
               mono-devel golang nodejs java-17-openjdk-devel npm)
    install_packages "${SLES_PKGS[@]}"
    ;;
esac

# Ensure pip exists and upgrade a bit (best-effort)
if command -v pip3 >/dev/null 2>&1; then
  PIP_CMD=pip3
elif command -v pip >/dev/null 2>&1; then
  PIP_CMD=pip
else
  PIP_CMD=""
fi
if [ -n "${PIP_CMD}" ]; then
  print "Upgrading pip (best-effort)"
  sudo "${PIP_CMD}" install --upgrade pip setuptools wheel || true
fi

# Clone or update Vundle
if [ -d "${VUNDLE_DIR}" ]; then
  print "Vundle already present -> pulling updates"
  git -C "${VUNDLE_DIR}" pull --ff-only || true
else
  print "Cloning Vundle into ${VUNDLE_DIR}"
  mkdir -p "$(dirname "${VUNDLE_DIR}")"
  git clone --depth=1 "${VUNDLE_REPO}" "${VUNDLE_DIR}"
fi

# Backup whatever is currently at ~/.vimrc
if [ -f "${VIMRC_TARGET}" ]; then
  BACKUP="${VIMRC_TARGET}.bak.$(date +%Y%m%d%H%M%S)"
  print "Backing up existing ${VIMRC_TARGET} -> ${BACKUP}"
  cp "${VIMRC_TARGET}" "${BACKUP}"
fi

print "Copying vimrc from ${DEFAULT_VIMRC_SOURCE} -> ${VIMRC_TARGET}"
# <-- the direct cp you requested
cp "${DEFAULT_VIMRC_SOURCE}" "${VIMRC_TARGET}"

# ensure ~/.vim exists
mkdir -p "${HOME}/.vim"

# Run Vundle PluginInstall headless
print "Running PluginInstall (vim +PluginInstall +qall)..."
if command -v vim >/dev/null 2>&1; then
  vim +PluginInstall +qall || { err "vim PluginInstall failed"; exit 5; }
else
  err "vim not found after package install. Please ensure 'vim' is installed."
  exit 6
fi

# Build YouCompleteMe if requested and present
if [ "${INSTALL_YCM}" = "yes" ]; then
  if [ -d "${YCM_DIR}" ]; then
    print "YouCompleteMe detected. Running build (install.py --all --verbose)"
    if [ -f "${YCM_DIR}/install.py" ]; then
      pushd "${YCM_DIR}" >/dev/null
      PY_CMD="python3"
      if ! command -v "${PY_CMD}" >/dev/null 2>&1; then
        PY_CMD="python"
      fi
      "${PY_CMD}" install.py --all --verbose || {
        err "YouCompleteMe build failed — you may need extra dev packages like clang/libclang."
      }
      popd >/dev/null
    else
      print "YouCompleteMe folder exists but no install.py found (plugin layout may differ)."
    fi
  else
    print "YouCompleteMe not installed (plugin not present). Skip build."
  fi
fi

print "Done. To update plugins later: vim +PluginUpdate +qall"
exit 0

