# **Arch Linux Installation and Hyprland Setup Guide**

***
DISCLAIMER:
This is a guide for my personal setup, it may not work for your setup. Proceed at your own risk.
***

# 1. Installing Arch Linux
Create a Arch Linux USB installation media and boot into a live environment.

## 1.1 Set Keyboard Layout and Timezone

    loadkeys no
    timedatectl set-timezone Europe/Oslo


## 1.2 Disk Partitioning
    fdisk /dev/nvme0n1

### 1.2.1 Delete Previous Partitions

⚠️ This will delete all your data!

Press `d` to delete partitions and `w` to write changes.

### 1.2.2 Create Partitions
1. EFI System Partition (1G):
    * Press `g` to create a new GPT partition table.
    * Press `n` for a new partition.
    * Default values for partition number and first sector.
    * Last sector: `+1G`.
    * Press `t` to set partition type, and choose `1` for `EFI System`.

2. Linux Swap Partition (4G):
    * Press `n` for a new partition.
    * Default values for partition number and first sector.
    * Last sector: `+4G`.
    * Press `t` to set partition type, and choose `19` for `Linux swap`.

3. Linux Root Partition (Remaining Space):
   * Press `n` for a new partition.
   * Default values for partition number and sectors.
   * Press `t` to set partition type, and choose `23` for `Linux root (x86-64)`.

4. Press `w` to write all changes.

## 1.3 Formatting and Mounting Partitions
    mkfs.ext4 /dev/nvme0n1p3   # Root
    mkswap /dev/nvme0n1p2      # Swap
    mkfs.fat -F 32 /dev/nvme0n1p1   # EFI System

Mount partitions:

    mount /dev/nvme0n1p3 /mnt
    mount --mkdir /dev/nvme0n1p1 /mnt/boot
    swapon /dev/nvme0n1p2

## 1.4 Installing Essential Packages
base
base-devel
git
linux-zen
linux-zen-headers
linux-firmware
grub
efibootmgr
amd-ucode
sudo
nano
nvidia-open-dkms
nvidia-utils
networkmanager
pipewire
pipewire-alsa
pipewire-pulse
pipewire-jack
wireplumber

    pacstrap -K /mnt base base-devel git linux-zen linux-zen-headers linux-firmware grub efibootmgr amd-ucode sudo nano nvidia-open-dkms nvidia-utils networkmanager pipewire pipewire-alsa pipewire-pulse pipewire-jack wireplumber

## 1.5 Generating Fstab
    genfstab -U /mnt >> /mnt/etc/fstab

## 1.6 Chroot into the System
```bash
arch-chroot /mnt
```
```bash
ln -sf /usr/share/zoneinfo/Europe/Oslo /etc/localtime
hwclock --systohc
```

    nano /etc/locale.gen

Uncomment `en_US.UTF-8 UTF-8` and `nb_NO.UTF-8 UTF-8`.

    nano /etc/locale.conf
    
    LANG=en_US.UTF-8
    LC_TIME=nb_NO.UTF-8
    LC_PAPER=nb_NO.UTF-8
    LC_MESURMENTS=nb_NO.UTF-8    
    
    nano /etc/vconsole.conf
    KEYMAP=no

## 1.7 Hostname & Host setup
    nano /etc/hostname
    neon

    nano /etc/hosts
    127.0.0.1 localhost
    ::1 localhost
    127.0.1.1 neon.localdomain neon

    useradd -m -G wheel -s /bin/bash username
    passwd

EDITOR=nano visudo

// Uncomment %wheel ALL=(ALL:ALL) ALL

## 1.7 Installing the Bootloader

Install GRUB for UEFI:

    grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB

Generate GRUB configuration:

    grub-mkconfig -o /boot/grub/grub.cfg

**Congratulation, Arch is now installed! Remove the installation media and launch into Arch Linux.**

# 2. Post-Installation Setup
    timedatectl set-ntp true

    sudo pacman -S --needed git base-devel && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si
    cd ..
    rm -rf yay/

Remove kms from the HOOKS array in /etc/mkinitcpio.conf and regenerate the initramfs.

    MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)

    mkinitcpio -P

    GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 nvidia-drm.modeset=1"

    sudo grub-mkconfig -o /boot/grub/grub.cfg


# 3. Hyprland Installation

```bash
sudo pacman -S hyprland-git
```

    sudo nano /etc/modprobe.d/nvidia.conf

    options nvidia_drm modeset=1 fbdev=1

# 4. Customization and Tweaks

    pacman -S waybar wofi hyprpaper

chmod +x .config/hypr/scripts/toggle_wofi.sh

## Pacman Tweaks

Open `sudo nano /etc/pacman.conf` and uncomment the following:

    ParallelDownloads = 10
    Color
    VerbosePkgLists

# 5. Personal Applications (so I dont forget)

    sudo pacman -S firefox
    yay -S jetbrains-toolbox

    sudo pacman -S dunst libnotify

    yay -S hyprpolkitagent-git

    sudo pacman -S qt5-wayland qt6-wayland

    sudo pacman -S fastfetch

    sudo pacman -S pavucontrol

    sudo pacman -S glfw glew glm vulkan-devel

    yay -S imgui

    yay -S eww-git

## 5.1 EVIOCSKEYCODE Error Fix

```bash
event11: Failed to call EVIOCSKEYCODE with scan code 0x7c, and key code 190: Invalid argument
``` 

    sudo cp /lib/udev/hwdb.d/60-keyboard.hwdb /etc/udev/hwdb.d/
    sudo nano /etc/udev/hwdb.d/60-keyboard.hwdb

`Control + F` and seach for either `7c` or `ASUS` and comment out `KEYBOARD_KEY_7c`.
    
    sudo systemd-hwdb update

## 6. TODO

- [ ] Configure kitty
- [ ] Configure waybar or eww
- [ ] Configure wofi
- [X] Configure Hyprland
- [ ] Fix README
