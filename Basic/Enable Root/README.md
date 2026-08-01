# Get Root 
Tutorial by ano.space

## Requirements
A flash drive (Recommended 2.0) formatted to FAT32, as MBR (Recommended 16GB or less)
Active LAN (Internet) connection for both the printer and your computer

## Tutorial
1. Place `runFirmwareExe.sh` onto the root of the flash drive
2. Insert the flash drive into the printer, reboot the printer
3. Wait 1 minute to make sure everything has ran (It will hang forever at the FlashForge bootup screen)
4. Remove the flash drive and reboot the printer

Now you can ssh with the credentials of
```
username: pwned
password: letmein
```

If you want to change the script, make sure they are made with UNIX line endings and not Windows, or else it will not work.
