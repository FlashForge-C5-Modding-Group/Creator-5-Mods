# SFTP Enabler
Tutorial by Cart

## Requirements
[Loop Script](https://github.com/FlashForge-C5-Modding-Group/Creator-5-Mods/tree/main/Basic/Loop%20Script) & [Entware](https://github.com/FlashForge-C5-Modding-Group/Creator-5-Mods/tree/main/Intermediate/Add%20Entware%20Package%20Manager)

### Tutorial
1. Do `opkg update`
2. Do `opkg install openssh-sftp-server`
3. Drop [this script](https://github.com/FlashForge-C5-Modding-Group/Creator-5-Scripts/blob/main/scripts/scripts/sftp-enable.sh) in `/usr/prog/scripts/scripts/`
4. Run `chmod +xwr /usr/prog/scripts/scripts/sftp-enable.sh`
5. Reboot (By unplugging or running `reboot`

All done!
