# Discord integration via Disraker
Cart

## Requirements
Loop Script & Optionally; [Entware](https://github.com/FlashForge-C5-Modding-Group/Creator-5-Mods/tree/main/Intermediate/Add%20Entware%20Package%20Manager)

### Tutorial with PC
1. Download and unzip DisRaker from this [GitHub](https://github.com/FlashForge-C5-Modding-Group/DisRaker) repository via the `Code` button anywhere on your computer
2. Manually move the `/usr/` folder from DisRaker into your printer's `/usr/` folder, making sure to only copy and not overwrite
3. Configure `/usr/data/disraker/config/disraker.json` by renaming `/usr/data/disraker/config/disraker.json.example`, making sure to fill in your information. You'll need to make a Discord bot [here](https://discord.com/developers/applications)
4. Navigate via ssh on the printer, using the command `cd /usr/data/disraker`
5. Create a .venv via `python3 -m venv .venv`
6. Install packages via `.venv/bin/pip install -r requirements.txt`. This will take a while, to check if it is still running, open another ssh window, and run `top` and you should see a GCC process running. If your printer hangs, reboot manually
7. Do `chmod +x /usr/data/scripts/scripts/disraker_loop.sh` to enable Loop Script for this
8. To test if it is working, go to the directory of the script via `/usr/data/scripts/scripts/`. Then, run `./disraker_loop.sh`. You should see it display no errors, and you should have your bot show up
9. If that is all good, reboot your machine to have Loop Script start it for you

### Tutorial directly on printer, Entware REQUIRED
1. Install packages via Entware / OPKG. Run `opkg install git git-http nano`
2. Run `git clone https://github.com/FlashForge-C5-Modding-Group/DisRaker.git`
3. Do `cd DisRaker/usr`
4. Do `mv data/disraker /usr/data/disraker`
5. Do `mv prog/scripts/scripts/disraker_loop.sh /usr/prog/scripts/scripts/disraker_loop.sh`
6. Now do `cd /usr/data/disraker`
7. Configure the json by doing `cp /usr/data/disraker/config/disraker.json.example /usr/data/disraker/config/disraker.json`, and then doing `nano /usr/data/disraker/config/disraker.json` Or doing it on a PC first by moving it to a PC over SFTP/SCP then configuring it, then moving it back, You'll need to make a Discord bot [here](https://discord.com/developers/applications)
8. Create a .venv via `python3 -m venv .venv`
9. Install packages via `.venv/bin/pip install -r requirements.txt`. This will take a while, to check if it is still running, open another ssh window, and run `top` and you should see a GCC process running. If your printer hangs, reboot manually.
10. Do `chmod +x /usr/data/scripts/scripts/disraker_loop.sh` to enable Loop Script for this
11. To test if it is working, go to the directory of the script via `/usr/data/scripts/scripts/`. Then, run `./disraker_loop.sh`. You should see it display no errors, and you should have your bot show up
12. If that is all good, reboot your machine to have Loop Script start it for you

If you have any issues, feel free to ask in the Discord channel.
