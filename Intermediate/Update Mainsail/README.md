# Update Mainsail
Tutorial by Cart

## Requirements
[Entware](https://github.com/FlashForge-C5-Modding-Group/Creator-5-Written-Scripts/tree/main/Intermediate/Add%20Entware%20Package%20Manager)

### Tutorial

1. Get into SSH
2. Run `opkg update`
3. Move old Mainsail to somewhere else `mv /usr/data/mainsail /usr/data/mainsailbackup`
4. Install git and curl by running `opkg install curl`
5. Make new Mainsail folder and cd to it by running `mkdir /usr/data/mainsail && cd /usr/data/mainsail`
6. Obtain a newer Mainsail by running `curl -LO https://github.com/mainsail-crew/mainsail/releases/download/v2.18.2/mainsail.zip`
7. Unzip Mainsail by running `unzip mainsail.zip`
8. Delete Mainsail's zip by running `rm -rf mainsail.zip`
9. Reboot.
