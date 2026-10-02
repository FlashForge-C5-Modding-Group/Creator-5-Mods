# Remote access with Tailscale
Tutorial by Eric Pedley

Puts the printer on your [Tailscale](https://tailscale.com) network (tailnet), so you can reach Mainsail, the webcam and SSH from your phone or another PC when you are away from home, without port forwarding.

## Requirements
[Entware](https://github.com/FlashForge-C5-Modding-Group/Creator-5-Mods/tree/main/Intermediate/Add%20Entware%20Package%20Manager) (which needs [Legacy NaN](https://github.com/FlashForge-C5-Modding-Group/Creator-5-Mods/tree/main/Intermediate/Enable%20Legacy%20NaN) & [Loop Script](https://github.com/FlashForge-C5-Modding-Group/Creator-5-Mods/tree/main/Basic/Loop%20Script)), and a Tailscale account

Recommended: [Mainsail](https://github.com/FlashForge-C5-Modding-Group/Creator-5-Mods/tree/main/Basic/Enable%20Moonraker%20%26%20Mainsail) (otherwise there is not much to reach) and [SSH host key persistence](https://github.com/FlashForge-C5-Modding-Group/Creator-5-Mods/tree/main/Basic/Make%20SSH%20host%20key%20persist)

## ⚠️WARNING⚠️
Every device on your tailnet (including devices other people have shared into it) will be able to reach the printer. Moonraker has no authentication and the root password from the root guide is public, so anyone who can reach the printer can control it. Only do this on a tailnet you trust, and look at [Tailscale ACLs](https://tailscale.com/kb/1018/acls) if you share yours with anyone.

Never port forward the printer to the internet instead of doing this.

### Tutorial
1. Run `opkg update && opkg install tailscale`
2. The printer's kernel has no TUN device (`/dev/net/tun` does not exist), so tailscaled has to run in userspace networking mode. Add the flag to the init script by running:
```sh
sed -i 's|^ARGS="|ARGS="--tun=userspace-networking |' /opt/etc/init.d/S06tailscaled
```
3. Check it by running `grep ARGS= /opt/etc/init.d/S06tailscaled`, it should look like this:
```sh
ARGS="--tun=userspace-networking --state=/opt/var/tailscaled.state --statedir=/opt/var/lib/tailscale"
```
4. Start it by running `/opt/etc/init.d/S06tailscaled start` (a `logger: not found` message is harmless)
5. Run `tailscale up --hostname=creator5` (the hostname can be whatever you want)
6. It prints a `https://login.tailscale.com/a/...` link. Open it in a browser on any device, log into your Tailscale account and approve the printer. The command prints `Success.` once you have.
7. Run `tailscale ip -4` to get the printer's tailnet IP (`100.x.y.z`)
8. Reboot to make sure it comes back on its own

All done! From any device on your tailnet:
- Mainsail: `http://<tailnet ip>/`
- Webcam: `http://<tailnet ip>:8080/?action=stream`
- SSH: `ssh pwned@<tailnet ip>`

On a phone, install the Tailscale app, log into the same account, and open the Mainsail address in your browser. You can add it to your home screen to use it like an app.

### Some Extra information
Q: Do I need to add a script to `/usr/prog/scripts/scripts/`?<br>
A: No. The Entware `entware.sh` script already runs `/opt/etc/init.d/rc.unslung start` on boot, which starts everything in `/opt/etc/init.d/`, including `S06tailscaled`. The login is stored in `/opt/var`, which is on persistent storage, so you only have to approve the printer once.

Q: SSH says `no mutual signature algorithm` or keeps asking for a password when I use an SSH key<br>
A: The printer's dropbear (v2019.78) only supports the old `ssh-rsa` signature for RSA keys, which newer OpenSSH clients turn off. Add this to `~/.ssh/config` on your PC:
```
Host <tailnet ip>
  User pwned
  PubkeyAcceptedAlgorithms +ssh-rsa
  HostKeyAlgorithms +ssh-rsa
```

Q: What does userspace networking mode change?<br>
A: Connections coming in to the printer over the tailnet work (tested with ports 22, 80, 7125 and 8080). Programs on the printer can not reach other tailnet devices directly, and using the printer as a subnet router or exit node has not been tested.

Q: How do I remove the printer from my tailnet?<br>
A: Run `tailscale logout` on the printer, or remove it from the [admin console](https://login.tailscale.com/admin/machines). To uninstall, run `/opt/etc/init.d/S06tailscaled stop && opkg remove tailscale`.

Tested on firmware 2.0.7 with Tailscale 1.96.1.
