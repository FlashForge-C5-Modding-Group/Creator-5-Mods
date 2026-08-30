# Enable Loop Safety / Loop Script
Tutorial by Cart

## Requirements
[Root](https://github.com/FlashForge-C5-Modding-Group/Creator-5-Written-Scripts/blob/main/Basic/Enable%20Root/README.md) & preferably an SCP client (WinSCP and such)

## ⚠️WARNING⚠️
Do not enable mods that you already installed via `app_startup.sh`. This is meant for new scripts, new installs, or in the future when you update. 

### Tutorial
1. Download this repo https://github.com/FlashForge-C5-Modding-Group/Creator-5-Scripts/ and extract it (or git clone, whatever is your fancy) (or download the script needed [here](https://github.com/FlashForge-C5-Modding-Group/Creator-5-Scripts/blob/main/scripts/loop/loop.sh))
2. Move the script `scripts/loop/loop.sh` to `/usr/prog/scripts/loop/` on the printer (you may have to create this folder by running mkdir `/usr/prog/scripts/loop/`)
3. Run `chmod +xwr /usr/prog/scripts/loop/loop.sh`
4. Add a new line in `/usr/prog/app_startup.sh` that is right above `/usr/prog/PROGRAM/software/firmwareExe &` that adds `/usr/prog/scripts/loop/loop.sh &`
6. Make a new folder in `/usr/prog/scripts/` that is named scripts by running `mkdir /usr/prog/scripts/scripts/`

All done! Restart to apply changes.
Any scripts you want to have enabled at startup can be put into `/usr/prog/scripts/scripts/`<br>
Some premade scripts are available @ https://github.com/FlashForge-C5-Modding-Group/Creator-5-Scripts/tree/main/scripts/scripts

### Some Extra information
Q: Why use a script to launch applications instead of modifying `start.sh` or `app_startup.sh`<br>
A: Modifying `app_startup.sh` and making it error before it can read USB drives for firmware updates can cause your printer to brick, this fixes that. On top of that, it makes it extremely easy to recover your scripts AFTER you update, as its only a single line to enable all your mods (other than Klipper config changes).

Q: How do I make a script for this?<br>
A: Any script will run if you put it in `/usr/prog/scripts/scripts/` (.sh extension), so make a normal script and upload it there.

Q: Where do I find scripts already made?<br>
A: Available @ https://github.com/FlashForge-C5-Modding-Group/Creator-5-Scripts/tree/main/scripts/scripts

Q: How do I reinstall this after an update?<br>
A: To reinstall, just follow step number 4.
