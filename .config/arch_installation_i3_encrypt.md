# Step-by-step of Arch installation [^1]
[^1]: nlantau, 2021-03-28

**UEFI system**

## Steps

```sh

# root@archiso:

setfont ter-132n

# localectl list-keymaps | grep sv
loadkeys sv-latin1

# ethernet during install or wifi:
ip a

# wifi
iwctl
device list
station wlan0 scan
station wlan0 get-networks
station wlan0 connect "Nest"
# exit iwctl

# time and date
timedatectl set-ntp true

# Not needed:
reflector -c Sweden -a 6 --sort rate --save /etc/pacman.d/mirrorlist

# Synchronize package databases
pacman -Syy

# Disk partitioning
lsblk
gdisk /dev/<disk-name>

# First partition, inside gdisk (EFI system partition)
n
+500M
ef00

# Second partition, inside gdisk (swap)
n
+4G
8200

# Third partition, inside gdisk (Linux filesystem)
n
8300

w
Y
# Partition table writen to disk

lsblk
mkfs.fat -F32 /dev/<disk-name>1
mkswap /dev/<disk-name>2
swapon /dev/<disk-name>2

# Encryption
cryptsetup -y -v luksFormat /dev/<disk-name>3
YES
# Enter passphrase

# Open partion for formating
cryptsetup open /dev/<disk-name>3 cryptroot
# Enter passphrase

# Now we can format the partition
mkfs.ext4 /dev/mapper/cryproot

# Partition is now formatted

mount /dev/mapper/cryproot /mnt
mkdir /mnt/boot
mount /dev/<disk-name>1 /mnt/boot
# Nothing to do for swap
lsblk

# Install the base packages
pacstrap /mnt base linux linux-firmware vim intel-ucode

# Generate file system table where the mount points are stored
genfstab -U /mnt >> /mnt/etc/fstab

# See the content
cat /mnt/etc/fstab

# Move into the installation
arch-chroot /mnt

# Time zone and locales
timedatectl list-timezones | grep Stockholm
ln -sf /usr/share/zoneinfo/Europe/Stockholm /etc/localtime
hwclock --systohc

vim /etc/locale.gen

# Uncomment `en_US.UTF-8 UTF-8`
# Save and exit vim

# Generate locales
locale-gen

vim /etc/locale.conf
# Inside the newly created file
LAND=en_US.UTF-8
# Save and exit vim

# Put keyboard layout into `vconsole.conf`
vim /etc/vconsole.conf
# Inside the newly created file
KEYMAP=sv-latin1
# Save and exit vim

# Hostname
vim /etc/hostname
# Inside the newly created file
archcrypt
# Save and exit vim

# Hosts file
vim /etc/hosts
# Inside the newly created file
# Go to EOF
127.0.0.1 \t localhost
::1 \t\t localhost
127.0.1.1 \t archrypt.localdomain \t archcrypt
# Save and exit vim

# Password to root user
passwd
# Enter new password

# Install the packages for the system
pacman -S grub efibootmgr networkmanager network-manager-applet dialog wpa_supplicant mtools dosfstools base-devel
linux-headers bluez bluez-utils cups xdg-utils xgd-user-dirs alsa-utils pulseaudio pulseaudio-bluetooth git reflector

# Need to change mkinitcpio due to encrypted disk
vim /etc/mkinitcpio.conf
# Inside vim
# Go to `HOOKS` section:
# Change to:
HOOKS=(base udev autodetect keyboard keymap modconf block encrypt filesystems fsck)
# Save and exit vim

# Need to re-create the image
mkinitcpio -p linux

# Install the GRUB bootloader
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB

# Generate the configuration file
grub-mkconfig -o /boot/grub/grub.cfg

# Need to change the configuration file due to encryption
blkid
# Locate the UUID for /dev/<disk-name>3
# Copy the entire line for the above disk

# Enter config file
vim /etc/default/grub
# Inside file:
# Go to `GRUB_CMDLINE_LINUX=""
# Change to:
GRUB_CMDLINE_LINUX="cryptdevice=UUID=<enter-UUID>:cryptroot root=/dev/mapper/cryptroot"
# Save and exit vim

# Need to re-generate the configuration file
grub-mkconfig -o /boot/grub/grub.cfg


# Enable the system
systemctl enable NetworkManager
systemctl enable bluetooth
systemctl enable cups

# Create a user
# -m = home directory
# -G = Creates a supplementary group (wheel)
useradd -mG wheel <username>

# TODO: Complete this guide. 21:59





```

