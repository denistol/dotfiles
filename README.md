<div align="center">

```text
       /\            __       __    ___ __             
      /  \   _______/ /_     / /_  / (_) /__  _____    
     / /\ \ / ___/ __/ __ \   / __ \/ / / // _ \/ ___/    
    / ____ / /  / /_/ / / /  / /_/ / / / //  __(__  )     
   /_/    /_\/   \__/_/ /_/  /_.___/_/_/_/ \___/____/      
                                                          
            ✦  A R C H   L I N U X   •   H Y P R L A N D  ✦
```

<p align="center">
  <b>Personal minimalist dotfiles managed with a Git Bare Repository</b>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/OS-Arch%20Linux-1793D1?style=for-the-badge&logo=arch-linux&logoColor=white" alt="Arch Linux" />
  <img src="https://img.shields.io/badge/WM-Hyprland-00A9E0?style=for-the-badge&logo=hyprland&logoColor=white" alt="Hyprland" />
  <img src="https://img.shields.io/badge/Terminal-Kitty-1E1E2E?style=for-the-badge&logo=kitty&logoColor=F5E0DC" alt="Kitty" />
  <img src="https://img.shields.io/badge/Shell-Zsh%20%2B%20OMZ-black?style=for-the-badge&logo=zsh&logoColor=white" alt="Zsh" />
  <img src="https://img.shields.io/badge/Theme-Catppuccin%20Mocha-CBA6F7?style=for-the-badge" alt="Catppuccin" />
</p>

---

</div>

## 🎨 Tech Stack & Components

| Component | Tool / Application | Description |
| :--- | :--- | :--- |
| **OS** | `Arch Linux` | Rolling-release Linux distribution |
| **Window Manager** | `Hyprland` | Dynamic tiling Wayland compositor |
| **Status Bar** | `Waybar` | Highly customizable modular top bar |
| **App Launcher** | `Wofi` | Application launcher and runner |
| **Terminal** | `Kitty` | GPU-accelerated terminal emulator with blur & ligature support |
| **Shell** | `Zsh` + `Oh My Zsh` | Enhanced shell with `autosuggestions`, `syntax-highlighting` & `SHARE_HISTORY` |
| **Notifications** | `Mako` | Lightweight Wayland notification daemon |
| **Lock & Idle** | `hyprlock` & `hypridle` | Screen locker and idle management daemon |
| **Wallpaper Daemon**| `hyprpaper` | Fast Wayland wallpaper utility |
| **Image Viewer** | `imv` | Native, fast Wayland image viewer |
| **Resource Monitor**| `btop` / `bottom` | Terminal-based system monitors styled in Catppuccin |
| **Color Scheme** | `Catppuccin Mocha` | Soothing pastel theme applied across the ecosystem |

---

## 🚀 Quick Setup on a Fresh Installation

These dotfiles are tracked using a **Git Bare Repository** technique — no extra symlink managers or file moves required.

### 1. Clone the repository as a bare repository
```bash
git clone --bare git@github.com:denistol/dotfiles.git $HOME/.dotfiles.git
```

### 2. Define the working alias
```bash
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME'
```

### 3. Checkout configurations
```bash
# Hide untracked files from 'dotfiles status'
dotfiles config --local status.showUntrackedFiles no

# Apply configs to your home directory
dotfiles checkout -f
```

### 4. Install Packages (Optional)
```bash
# Official repository packages
sudo pacman -S --needed - < ~/.config/pkglist.txt

# AUR packages
yay -S --needed - < ~/.config/foreignpkglist.txt
```

---

## 🛠 Everyday Workflow

Manage your dotfiles seamlessly like any regular Git repository:

```bash
# Check modified configuration files
dotfiles status

# Stage updated configs
dotfiles add ~/.config/hypr/hyprland.lua

# Commit and push changes
dotfiles commit -m "style: tweak hyprland animations"
dotfiles push
```

---

<div align="center">
  <sub>Crafted with ☕ and tuned for productivity on Arch Linux</sub>
</div>
