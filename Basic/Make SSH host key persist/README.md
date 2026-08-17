# SSH Host Key Persistence
Tutorial by ano

### Info:
"The host key regenerates each boot because the path where dropbear reads the host key -`/etc/dropbear`-  is a symlink into `/run`, which is temporary. The init script actually tries to fix this but `/etc` hasn't been mounted yet so the init script only sees the read-only squashfs filesystem."
"We can mitigate this and make the host keys persist by removing the symlink and making it a real directory"

## Requirements:
Root

### Tutorial:
1. Run `mv /etc/dropbear/dropbear_ecdsa_host_key /tmp`
2. Run `rm /etc/dropbear`
3. Run `mkdir /etc/dropbear`
4. Run `mv /tmp/dropbear_ecdsa_host_key /etc/dropbear`
5. Reboot

### Afterthoughts
"This works because dropbear only loads the host key when you first connect.  Also, since/etc is bind-mounted to /usr/prog/etc once the system is up, a directory created there at runtime lands on persistent storage "
