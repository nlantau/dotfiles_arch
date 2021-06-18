# Archi3_Lenovo
As of 2021-06-18, I'm running:
+ 5.12.11-arch
+ xmonad
+ xmobar
+ slock


## Useful commands
As I've made my life hard for me, there're many commands and sometimes rather complex sequences of commands that
I need to keep in my head. Unfortunately, I'm human and forget. Therefore, I'll try to keep some of these commands here.

### USB - Disk management
Step-by-step to partition and format a USB-stick

This will partition and format a USB-stick to be used in cross-OS applications
```sh
> fdisk /dev/sda
> new GPT
# Partition 1: EFI ~ 200MB
# Partition 2: Microsoft Basic Data
```
After partitioning, 
```sh
> mkfs.fat -F32 partition1
> mkfs.fat -F32 partition2
# or
> mkfs.exfat partition -n name
```
