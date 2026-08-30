# Unlock camera to 720p @ 30 FPS
Tutorial by ano.space and Cart

## Requirements:
[Root](https://github.com/FlashForge-C5-Modding-Group/Creator-5-Written-Scripts/blob/main/Basic/Enable%20Root/README.md), [Loop script](https://github.com/FlashForge-C5-Modding-Group/Creator-5-Mods/tree/main/Basic/Loop%20Script) and an SCP program

### Tutorial:
1. Place the sh script included in this folder at `/usr/prog/mjpeg-streamer/` on the printer
2. Run `chmod 755 /usr/prog/mjpeg-streamer/start_webcam.sh`
3. Move `/scripts/scripts/camera.sh` ([available here](https://github.com/FlashForge-C5-Modding-Group/Creator-5-Scripts/blob/main/scripts/scripts/camera.sh)) to `/usr/prog/scripts/scripts/`
4. Run `chmod +xwr /usr/prog/scripts/scripts/camera.sh`
5. Reboot your printer by running `reboot` or just unplugging / plugging back in

You should get an error on the UI saying "Failed to open camera," but mjpg-streamer should be running on port 8080 and at 720p@30.
