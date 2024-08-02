#!/bin/bash
# hacky one-liner
echo (AIX Alpine AlterLinux Anarchy Android Antergos antiX\
 "AOSC  OS" "AOSC OS/Retro" Apricity ArcoLinux ArchBox ARCHlabs\
 ArchStrike XFerience ArchMerge Arch Artix Arya  Bedrock\
 Bitrig BlackArch BLAG BlankOn BlueLight bonsai BSD\
 BunsenLabs Calculate Carbs CentOS Chakra ChaletOS Chapeau\
 Chrom  Cleanjaro  ClearOS  Clear_Linux Clover Condres Container_Linux\
 CRUX Cucumber Debian  Deepin  DesaOS  Devuan\
 DracOS  DragonFly  Drauger  Elementary EndeavourOS Endless\
 EuroLinux Exherbo Fedora Feren  FreeBSD  FreeMiNT  Frugalware\
 Funtoo GalliumOS Gentoo Pentoo gNewSense GNOME GNU\
 GoboLinux Grombyang Guix  Haiku  Huayra  Hyperbola  janus\
 Kali   KaOS   KDE_neon  Kibojoe  Kogaion  Korora  KSLinux\
 Kubuntu LEDE LFS Linux_Lite  LMDE  Lubuntu  Lunar  macos\
 Mageia  MagpieOS  Mandriva  Manjaro  Maui  Mer Minix LinuxMint\
 MX_Linux Namib  Neptune  NetBSD  Netrunner  Nitrux\
 NixOS  Nurunner  NuTyX OBRevenge OpenBSD OpenIndiana openmamba\
 OpenMandriva OpenStage OpenWrt osmc  Oracle  OS  Elbrus\
 PacBSD  Parabola Pardus Parrot Parsix TrueOS PCLinuxOS\
 Peppermint popos Porteus PostMarketOS Proxmox  Puppy\
 PureOS  Qubes  Radix  Raspbian  Reborn_OS Redstar Redcore\
 Redhat Refracted_Devuan Regata Rosa sabotage Sabayon Sailfish\
 SalentOS  Scientific  Septor  SereneLinux SharkLinux\
 Siduction  Slackware  SliTaz  SmartOS  Solus   Source_Mage\
 Sparky  Star  SteamOS  SunOS openSUSE_Leap openSUSE_Tumbleweed\
 openSUSE  SwagArch  Tails   Trisquel   Ubuntu-Budgie\
 Ubuntu-GNOME  Ubuntu-MATE  Ubuntu-Studio Ubuntu Venom Void\
 Obarun windows10 Windows7 Xubuntu Zorin IRIX) |
shuf | fzf | tee >(xargs neofetch -L --ascii_distro) && sleep 0.2
# NAME="$(shuf ~/.local/share/neofetch-ASCII | fzf)"
# echo "$NAME"
# neofetch -L --ascii_distro "$NAME"
#    ASCII:
#        --ascii_colors x x x x x x
#               Colors to print the ascii art
# 
#        --ascii_distro distro
#               Which Distro's ascii art to print
# 
# 
#               NOTE:  Arch, Ubuntu, Redhat, and Dragonfly have 'old' logo vari‐
#               ants.
# 
#               NOTE: Use '{distro name}_old' to use the old logos.
# 
#               NOTE: Ubuntu has flavor variants.
# 
#        NOTE: Change this to Lubuntu, Kubuntu, Xubuntu, Ubuntu-GNOME,
#               Ubuntu-Studio, Ubuntu-Mate  or Ubuntu-Budgie to use the flavors.
# 
#        NOTE: Arcolinux, Dragonfly, Fedora, Alpine, Arch, Ubuntu,
#               CRUX, Debian, Gentoo, FreeBSD,  Mac,  NixOS,  OpenBSD,  android,
#               Antrix,  CentOS,  Cleanjaro, ElementaryOS, GUIX, Hyperbola, Man‐
#               jaro, MXLinux,  NetBSD,  Parabola,  POP_OS,  PureOS,  Slackware,
#               SunOS,  LinuxLite,  OpenSUSE,  Raspbian,  postmarketOS, and Void
#               have a smaller logo variant.
# 
#               NOTE: Use '{distro name}_small' to use the small variants.
# 
#        --ascii_bold on/off
#               Whether or not to bold the ascii logo.
# 
#        -L, --logo
#               Hide the info text and only show the ascii logo.
# 
