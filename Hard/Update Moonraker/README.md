# Update Moonraker
Tutorial by ano.space and Cart

## Requirements
Legacy NaN, Entware (and optionally Loop Script)

### Tutorial

1. Set your clock, do it by running `rdate -s time.nist.gov` or whatever time server you perfer.
You can alternatively set it automatically by putting `/scripts/scripts/time.sh` ([available here](https://github.com/FlashForge-C5-Modding-Group/Creator-5-Scripts/blob/main/scripts/scripts/time.sh)) to `/usr/prog/scripts/scripts/` and running `chmod +xwr /usr/prog/scripts/scripts/time.sh`
2. Copy over the `lmdb.h` file in the same folder to `/opt/include`, or download all headers by running the below command. You can do one or the other.
```sh
cd /tmp
wget http://bin.entware.net/mipselsf-k3.4/include/include.tar.gz
mkdir /opt/include
gunzip -c include.tar.gz | tar x -C /opt/include/
```
3. Now lets get actually started, backup moonraker by running:
```sh
mv /usr/prog/moonraker/moonraker /usr/prog/moonraker/moonraker-old
mv /usr/prog/moonraker/moonraker-env /usr/prog/moonraker/moonraker-env-old
```
4. Now run `opkg update && opkg install git git-http`
5. Download newer moonraker by running these commands `cd /usr/prog/moonraker && git clone https://github.com/Arksine/moonraker.git`
6. Kill the current moonraker by running `/usr/prog/klipper/moonrakerDaemon stop`
7. Now lets install newer python. This will take a long while. `opkg install python3 python3-pip`
8. Now with the newer python, lets make a venv by running `python3 -m pip install virtualenv && virtualenv --system-site-packages -p python3 ./moonraker-env`
9. We need more opkg packages, lets install them now, will take a while yet again. Run `opkg install python3-dev python3-pillow python3-numpy python3-msgpack python3-cryptography python3-cffi python3-yaml python3-requests python3-setuptools libsodium libffi gcc lmdb`
10. Lets symlink libsodium for pip by running `ln -sf $(ls /opt/lib/libsodium.so.*[0-9] | head -1) /opt/lib/libsodium.so`
11. Source the venv by running `. ./moonraker-env/bin/activate`
12. Install python dependencies by running `pip install -r /usr/prog/moonraker/moonraker/scripts/moonraker-requirements.txt && LMDB_FORCE_SYSTEM=1 pip install --no-build-isolation lmdb` This will take a while again.
13. You can ensure it is working by running `python3 /usr/prog/moonraker/moonraker/moonraker/moonraker.py -d /usr/data`
14. If everything looks golden, add these to the top of `/usr/prog/klipper/moonrakerDaemon` 
```sh
export PATH=/opt/bin:/opt/sbin:$PATH
# replace the PYTHON= line with this
PYTHON=/usr/prog/moonraker/moonraker-env/bin/python3
```
15. Ensure Moonraker is enabled in `/usr/prog/klipper/start.sh` (or you have `/usr/prog/scripts/scripts/enable-msmr.sh`) and reboot
16. You should have up to date Moonraker, and you should be able to see the webcam too if you've updated Mainsail.
