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

To use it,
```sh
> mkdir /tmp/usb
> mount /dev/sda /tmp/usb #/dev/sda is the usb
```

# Gentoo
make.conf
```sh
COMMON_FLAGS="-march=skylake -02 -pipe"

USE="X elogind xinerama udev dbus git crypt alc \
     xrandr upower x264 imlib libpng apng postproc \
     networkmanager usb matroska man jpeg png gif \
     ffmpeg encode curl bzip2 savedconfig bash-completion \
     alsa pulseaudio mp3 mp4 vim-syntax pdf latex \
     bluetooth wifi aac \
     -gnome -gtk -kde -plasma -ios -ipod -emacs -xemacs \
     -dvd -dvdr -dv -coreaudio -scanner -a52 \
     -systemd -aqua -css -cups"

# The number of possible tasks created <= N*K
# X.Y=N*0.9 = 2.7
MAKEOPTS="-j3"
EMERGE_DEFAULT_OPTS="--jobs 3 --load-average 2.7"

VIDEO_CARDS="intel nvidia"
INPUT_DEVICES="libinput synaptics"

ACCEPT_LICENSE="*"
ACCEPT_KEYWORDS="~amd64"

GRUB_PLATFORMS="efi-64"

```

packages
```sh
# X
x11-apps/xinit
x11-apps/xbacklight
x11-apps/xinput
x11-apps/xset
x11-apps/xcape
x11-apps/xrandr
x11-misc/dmenu

# Sys
sys-auth/elogind
sys-apps/pciutils
sys-apps/lm-sensors
sys-process/htop
app-admin/sudo

# Terminal
x11-terms/alacritty
app-editors/vim

# Media
www-client/firefox
media-sound/pulseaudio
media-sound/alsa-utils
media-video/ffmpeg
media-gfx/feh

# vcs & network
dev-vcs/git
net-misc/networkmanager
net-wireless/iw
net-wireless/wpa_supplicant
```

