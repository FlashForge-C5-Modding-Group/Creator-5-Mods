# Unlock camera to 720p @ 30 FPS
Tutorial by ano.space

## Requirements:
[Root](https://github.com/FlashForge-C5-Modding-Group/Creator-5-Written-Scripts/blob/main/Basic/Enable%20Root/README.md) and an SCP program

### Tutorial:
1. Place the sh script in this folder at `/usr/prog/mjpeg-streamer/`
2. Run `chmod 755 /usr/prog/mjpeg-streamer/start_webcam.sh/`
3. Run `vi /usr/prog/app_startup.sh`
4. Look for `/usr/prog/PROGRAM/software/firmwareExe &` (near the bottom)
5. Press the "INS" (insert) button and add the line below **ABOVE** that line

```
# start mjpg-streamer before firmwareExe
sh /usr/prog/mjpg-streamer/start_webcam.sh
sleep 2
```
6: Press "ESC" and type `:wq`, and press enter
7: Type "Reboot"

You should get an error on the UI saying "Failed to open camera," but mjpg-streamer should be running on port 8080 and at 720p@30.
