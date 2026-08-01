# Make the SSH host key persist
Tutorial by ano.space

## Requirements:
[Root](https://github.com/FlashForge-C5-Modding-Group/Creator-5-Written-Scripts/tree/main/Basic/Enable%20Root)

Information before starting:
The host key regenerates each boot because the path where dropbear reads the host key -`/etc/dropbear`-  is a symlink into `/run`, which is temporary.
The init script actually tries to fix this but `/etc` hasn't been mounted yet so the init script only sees the read-only squashfs filesystem.
This tutorial mitigates it by removing the symlink and making it a real directory.

### Tutorial
1. Open your favorite SSH program
2. `mv /etc/dropbear/dropbear_ecdsa_host_key /tmp`
3. `rm /etc/dropbear`
4. `mkdir /etc/dropbear`
5. `mv /tmp/dropbear_ecdsa_host_key /etc/dropbear`
Reboot

Now it should only ask once from now on and will correctly save the key
