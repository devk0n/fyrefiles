# **Arch Linux Installation and Hyprland Setup Guide**

DISCLAMER! This is a guide for my personal setup for me to practice writing documentation and to recreate my setup when re-installing. DO NOT follow if you dont know what you're doing.

---

## **1. Install Arch Linux**

### **Set Keyboard Layout and Timezone**
```bash
loadkeys no
timedatectl set-timezone Europe/Oslo
```

### **Disk Partitioning**

```bash
fdisk /dev/nvme0n1
```
#### **Create /boot partition**
* Press g to create a new GPT partition table.
* Press n for a new partition.
* Partition number 1.
* First sector 2048.
* Last sector +1G.

