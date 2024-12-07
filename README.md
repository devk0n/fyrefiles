# **Arch Linux Installation and Hyprland Setup Guide**

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
Press g to create a new GPT partition table.
Create Partitions:
Press n for a new partition.
