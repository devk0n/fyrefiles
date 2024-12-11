# **Arch Linux Installation and Hyprland Setup Guide**

***
DISCLAIMER:
This is a guide for my personal setup for practice and to recreate my system when reinstalling. DO NOT follow this if you're not familiar with the process. Proceed at your own risk.
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
    arch-chroot /mnt

    ln -sf /usr/share/zoneinfo/Europe/Rome /etc/localtime

    hwclock --systohc

    nano /etc/locale.gen

en_US.UTF-8 UTF-8
nb_NO.UTF-8 UTF-8

## 1.7 Installing the Bootloader
Install GRUB:

    pacman -S grub efibootmgr

Install GRUB for UEFI:

    grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB

Generate GRUB configuration:

    grub-mkconfig -o /boot/grub/grub.cfg

**Congratulation, Arch is now installed! Remove the installation media and launch into Arch Linux.**

# 2. Post-Installation Setup

# 3. Hyprland Installation

```bash
sudo pacman -S hyprland-git
```

# 4. Customization and Tweaks
