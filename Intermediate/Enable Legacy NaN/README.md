# Enable Legacy NaN binary support
Tutorial by ano.space and Cart

## Requirements
[root](https://github.com/FlashForge-C5-Modding-Group/Creator-5-Written-Scripts/blob/main/Basic/Enable%20Root/README.md) & Loop Script

### Tutorial
1. Check what version you are currently on for kernel and consult the list at the bottom, do it by running `ls /usr/prog/PROGRAM/kernel/`
2. If the version exists, check the offset, copy it and run `busybox devmem <offset> 8`, it should return 0x00. If it doesn't, legacy nan is enabled, or something is very wrong.
3. If it is all good, run `busybox devmem <offset> 8 1`
4. Copy [this script](https://github.com/FlashForge-C5-Modding-Group/Creator-5-Scripts/blob/main/scripts/scripts/nan-binary.sh) to /usr/prog/scripts/scripts/
5. Run `chmod +xwr /usr/prog/scrips/scripts/nan-binary.sh`

All done! Now you can move onto things that require it.

### Version Map
```
2.0.1: 0x00a130d1
2.0.5: 0x00a130d1
```
