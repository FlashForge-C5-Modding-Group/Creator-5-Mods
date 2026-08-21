# Add OPKG / Entware
Tutorial by ano.space and Cart

## Requirements
Legacy NaN & Loop Script

**⚠️THIS TUTORIAL IS BEING REPLACED BY AN AUTOINSTALL SCRIPT⚠️
⚠️SCRIPT IS AVAILABLE UNDER "SCRIPTS"⚠️**

### Tutorial
1. After running Legacy NAN and the rest, start by running `mkdir -p /usr/data/bin/opt`
2. After you run that, run `mount --bind /usr/data/bin/opt /opt` (to bind a non writable area to writable)
3. Then run, `wget -O - http://bin.entware.net/mipselsf-k3.4/installer/generic.sh | sh` and wait for it to successfully install
4. Finally, run `echo 'export PATH=/opt/bin:/opt/sbin:$PATH' >> /etc/profile`
5. Now move [this script](https://github.com/FlashForge-C5-Modding-Group/Creator-5-Scripts/blob/main/scripts/scripts/entware.sh) to `/usr/prog/scripts/scripts/`
6. Now run `chmod +xwr /usr/prog/scripts/scrips/entware.sh`
7. Reboot

All done! Entware packages can now be installed by running `opkg install <package>`
