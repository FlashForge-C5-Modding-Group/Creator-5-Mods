# Enable Moonraker & Mainsail WebUI
Tutorial by ano.space

## Requirements:
[Root](https://github.com/FlashForge-C5-Modding-Group/Creator-5-Written-Scripts/blob/main/Basic/Enable%20Root/README.md)

### Tutorial:
1. Open SSH, with the application of choice (PUTTY, PowerShell SSH, etc)
2. Open `/usr/prog/klipper/start.sh` by writing `vi /usr/prog/klipper/start.sh`
3. Press the "INS" (Insert) Button on your keyboard
4. Change
```
#/usr/prog/nginx/sbin/nginx -p /usr/prog/nginx -c /usr/prog/nginx/conf/nginx.conf
#/usr/prog/klipper/moonrakerDaemon start
```
to
```
/usr/prog/nginx/sbin/nginx -p /usr/prog/nginx -c /usr/prog/nginx/conf/nginx.conf
/usr/prog/klipper/moonrakerDaemon start
```
5: Press "ESC" (Escape) and type :wq and press enter
6: Run `reboot`

All done! You should be able to see the Mainsail WebUI on the printer's IP.
