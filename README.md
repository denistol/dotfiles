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
  <img src="https://img.shields.io/badge/OS-Arch%20Linux-1793D1?style=for-the-badge&logo=arch-linux&logoColor=white" />
  <img src="https://img.shields.io/badge/WM-Hyprland-00A9E0?style=for-the-badge&logo=hyprland&logoColor=white" />
  <img src="https://img.shields.io/badge/Terminal-Kitty-1E1E2E?style=for-the-badge&logo=kitty&logoColor=F5E0DC" />
  <img src="https://img.shields.io/badge/Shell-Zsh%20%2B%20OMZ-black?style=for-the-badge&logo=zsh&logoColor=white" />
  <img src="https://img.shields.io/badge/Theme-Catppuccin%20Mocha-CBA6F7?style=for-the-badge" />
</p>

---

</div>

## 🎨 Стек и компоненты

| Компонент | Утилита / Инструмент | Описание |
| :--- | :--- | :--- |
| **ОС** | `Arch Linux` | Rolling release дистрибутив |
| **Композитор (WM)** | `Hyprland` | Динамический тайлинговый Wayland-композитор |
| **Статус-бар** | `Waybar` | Кастомная панель с модулями |
| **Лаунчер** | `Wofi` | Меню запуска приложений и команд |
| **Терминал** | `Kitty` | GPU-ускоренный терминал с поддержкой блюра и лигатур |
| **Шелл** | `Zsh` + `Oh My Zsh` | `zsh-autosuggestions`, `zsh-syntax-highlighting`, `SHARE_HISTORY` |
| **Уведомления** | `Mako` | Легковесный Wayland демон уведомлений |
| **Локскрин & Idle**| `hyprlock` & `hypridle` | Экран блокировки и управление сном |
| **Обои** | `hyprpaper` | Быстрый Wayland-демон для смены обоев |
| **Просмотрщик фото**| `imv` | Нативный быстрый просмотрщик изображений |
| **Мониторинг** | `btop` / `bottom` | Системные мониторы в теме Catppuccin |
| **Цветовая палитра**| `Catppuccin Mocha` | Единая палитра для всех приложений |

---

## 🚀 Установка на чистой системе (Quick Install)

Все дотфайлы управляются через **Git Bare Repository** (без захламления `~` лишними папками и без симлинков).

### 1. Клонирование репозитория
```bash
git clone --bare git@github.com:denistol/dotfiles.git $HOME/.dotfiles.git
```

### 2. Настройка алиаса
```bash
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME'
```

### 3. Применение файлов
```bash
# Скрыть неотслеживаемые файлы
dotfiles config --local status.showUntrackedFiles no

# Применить конфиги в домашнюю директорию
dotfiles checkout -f
```

### 4. Установка пакетов (по желанию)
```bash
# Официальные пакеты
sudo pacman -S --needed - < ~/.config/pkglist.txt

# Пакеты из AUR
yay -S --needed - < ~/.config/foreignpkglist.txt
```

---

## 🛠 Как управлять дотфайлами

Используйте алиас `dotfiles` точно так же, как обычный `git`:

```bash
# Проверить статус изменений
dotfiles status

# Добавить измененный конфиг
dotfiles add ~/.config/hypr/hyprland.lua

# Закоммитить и отправить на GitHub
dotfiles commit -m "style: update hyprland config"
dotfiles push
```

---

<div align="center">
  <sub>Собрано с ☕ и настроено под себя на Arch Linux</sub>
</div>
