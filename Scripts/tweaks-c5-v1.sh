#!/bin/sh

show_menu() {
    clear
    echo "==============================================="
    echo "               Tweaks for FF C5                "
    echo "Basic installs made by ano, script made by Cart"
    echo "              discord.gg/7nJUB9dq4F            "
    echo "                 Version 1.2.1                 "
    echo "==============================================="
    echo "1) Enable Legacy NaN MIPS binaries"
    echo "2) Install Entware"
    echo "3) Update Mainsail"
    echo "4) Update Moonraker (INDEV)"
    echo "5) Exit"
    echo ""
    echo "98) Credits"
    echo "99) Release Notes"
    echo "================================================"
}

release_notes() {
    clear
    release_noting
    printf "Press Enter to return to the main menu..."
    stty -echo
    read -r _
    stty echo
    return 0
}

release_noting(){
    echo "========================================="
    echo "              Release Notes"
    echo "               Version 1.2"
    echo ""
    echo "   Mainsail Updater, no Moonraker yet...  "
    echo "=========================================="
}

enable_nan_mips() {
    clear
    echo "[*] Checking kernel package version..."

    if [ ! -d "/usr/prog/PROGRAM/kernel/" ]; then
        echo "[-] Error: /usr/prog/PROGRAM/kernel/ directory not found!"
        printf "Press Enter to return..."
        read -r _
        return 1
    fi

    # Find highest version directory/file in kernel folder
    HIGHEST_VER=$(ls /usr/prog/PROGRAM/kernel/ | sort -V | tail -n 1)

    if [ -z "$HIGHEST_VER" ]; then
        echo "[-] Error: Could not determine kernel package version."
        printf "Press Enter to return..."
        read -r _
        return 1
    fi

    echo "[+] Detected highest kernel version: $HIGHEST_VER"

    # Map version to offset
    OFFSET=""
    case "$HIGHEST_VER" in
        "2.0.1"*)
            OFFSET="0x00a130d1"
            ;;
        *)
            echo "[-] Error: No matching offset defined for kernel version '$HIGHEST_VER'."
            echo "    Please verify your kernel package version manually."
            echo "[-] Please manually update the script and commit back."
            printf "Press Enter to return..."
            read -r _
            return 1
            ;;
    esac

    echo "[+] Mapped Offset: $OFFSET"
    echo "[*] Verifying current memory state..."

    # Read current state (read-only verification)
    CURRENT_VAL=$(busybox devmem "$OFFSET" 8 2>/dev/null)
    echo "[+] Current memory value at $OFFSET: $CURRENT_VAL"

    if [ "$CURRENT_VAL" != "0x00" ]; then
        echo "[!] Warning: Expected 0x00, but read '$CURRENT_VAL'."
        printf "Do you still want to proceed enabling NaN MIPS support? (y/N): "
        read -r CONFIRM
        if [ "$CONFIRM" != "y" ] && [ "$CONFIRM" != "Y" ]; then
            echo "[*] Aborted."
            printf "Press Enter to return..."
            read -r _
            return 0
        fi
    fi

    # Apply live memory write
    echo "[*] Writing 1 to $OFFSET..."
    busybox devmem "$OFFSET" 8 1

    # Insert persistent command at the top of app_startup.sh right after shebang
    STARTUP_FILE="/usr/prog/app_startup.sh"
    CMD_TO_ADD="busybox devmem $OFFSET 8 1"

    if [ -f "$STARTUP_FILE" ]; then
        if grep -q "$OFFSET" "$STARTUP_FILE"; then
            echo "[+] Startup entry already exists in $STARTUP_FILE."
        else
            echo "[*] Adding patch entry to top of $STARTUP_FILE..."
            # POSIX-compliant single-line sed insert after line 1
            sed -i "1a $CMD_TO_ADD" "$STARTUP_FILE"
            echo "[+] Successfully patched $STARTUP_FILE."
        fi
    else
        echo "[-] Warning: $STARTUP_FILE not found. Live patch applied, but persistent startup entry was not added."
    fi

    echo "[+] Legacy NaN MIPS binaries enablement complete!"
    printf "Press Enter to return..."
    read -r _
}

install_entware() {
    clear
    echo "[*] Checking for NaN Binaries enablement..."

    # Ensure $OFFSET is set if it wasn't run previously in Option 1
    if [ -z "$OFFSET" ]; then
        if [ -d "/usr/prog/PROGRAM/kernel/" ]; then
            HIGHEST_VER=$(ls /usr/prog/PROGRAM/kernel/ | sort -V | tail -n 1)
            case "$HIGHEST_VER" in
                "2.0.1"* | "2.0.5"*) OFFSET="0x00a130d1" ;;
            esac
        fi
    fi

    # Fallback safety if offset still couldn't be determined
    if [ -z "$OFFSET" ]; then
        echo "[-] Error: Could not determine kernel offset to verify NaN support."
        printf "Press Enter to return..."
        read -r _
        return 1
    fi

    # Read current state
    CURRENT_VAL=$(busybox devmem "$OFFSET" 8 2>/dev/null)
    echo "[+] Current memory value at $OFFSET: $CURRENT_VAL"

    if [ "$CURRENT_VAL" != "0x01" ]; then
        echo ""
        echo "[!] Error: Expected memory value 0x01, but read '$CURRENT_VAL'."
        echo "    You MUST enable Legacy NaN MIPS binaries before installing Entware!"
        echo ""
        printf "Press Enter to return to main menu..."
        read -r _
        return 0
    fi

    echo "[*] Legacy NaN is enabled, can continue."
    echo ""
    echo "[*] Checking for previous installations..."
    echo ""

    if command -v opkg >/dev/null 2>&1 || [ -x "/opt/bin/opkg" ]; then
        echo "[!] Entware appears to be installed already! ('opkg' executable found)."
        echo "[!] We do not recommend running unless something is very broken."
        echo ""
        printf "Do you want to force reinstall Entware anyway? Not recommended. (y/N): "
        read -r REINSTALL
        if [ "$REINSTALL" != "y" ] && [ "$REINSTALL" != "Y" ]; then
            echo "[*] Entware installation cancelled."
            printf "Press Enter to return..."
            read -r _
            return 0
        fi
    fi

    echo "[*] Proceeding with Entware installation..."

    # 1. Create directories and mount
    mkdir -p /usr/data/bin/opt
    mount --bind /usr/data/bin/opt /opt

    # 2. Download and run generic Entware installer
    echo "[*] Downloading and executing Entware setup script..."
    wget -O - http://bin.entware.net/mipselsf-k3.4/installer/generic.sh | sh

    # 3. Add to PATH persistently in /etc/profile
    PROFILE_FILE="/etc/profile"
    EXPORT_LINE='export PATH=/opt/bin:/opt/sbin:$PATH'
    if [ -f "$PROFILE_FILE" ]; then
        if ! grep -q "/opt/bin" "$PROFILE_FILE"; then
            echo "$EXPORT_LINE" >> "$PROFILE_FILE"
            echo "[+] Added /opt paths to $PROFILE_FILE."
        else
            echo "[+] $PROFILE_FILE already contains /opt PATH export."
        fi
    fi

    # Export PATH for current session immediately
    export PATH=/opt/bin:/opt/sbin:$PATH

    # 4. Add mount and unslung startup script to app_startup.sh
    STARTUP_FILE="/usr/prog/app_startup.sh"
    TARGET_LINE="busybox devmem 0x00a130d1 8 1"

    if [ -f "$STARTUP_FILE" ]; then
        if grep -q "rc.unslung" "$STARTUP_FILE"; then
            echo "[+] Entware startup entry already exists in $STARTUP_FILE."
        elif grep -q "$TARGET_LINE" "$STARTUP_FILE"; then
            echo "[*] Inserting Entware startup entry directly below '$TARGET_LINE'..."

            # 1. Write the block to a temporary file
            cat << 'EOF' > /tmp/entware_block.txt

# entware
mount --bind /usr/data/bin/opt /opt
[ -x /opt/etc/init.d/rc.unslung ] && /opt/etc/init.d/rc.unslung start
EOF

            # 2. Insert the contents of the temp file right below TARGET_LINE
            sed -i "/$TARGET_LINE/r /tmp/entware_block.txt" "$STARTUP_FILE"

            # 3. Clean up temp file
            rm -f /tmp/entware_block.txt

            echo "[+] Inserted Entware startup entries into $STARTUP_FILE."
        else
            echo "[!] '$TARGET_LINE' not found. Appending Entware entry to end of file..."
            cat << 'EOF' >> "$STARTUP_FILE"

# entware
mount --bind /usr/data/bin/opt /opt
[ -x /opt/etc/init.d/rc.unslung ] && /opt/etc/init.d/rc.unslung start
EOF
            echo "[+] Appended Entware startup entries to $STARTUP_FILE."
        fi
    fi

    echo "[+] Running opkg update"
    opkg update

    echo "[+] Adding aditional packages (Nano, Git)"
    opkg install nano git

    echo "[+] Entware installation finished!"
    printf "Press Enter to return..."
    read -r _
}

add_entware_packages() {
    clear
    echo "[*] Checking if Entware is installed..."
    if command -v opkg >/dev/null 2>&1 || [ -x "/opt/bin/opkg" ]; then
        echo "[+] Entware is detected, can continue."
        echo "[*] Getting required Entware packages, may take a moment."
        opkg update
        opkg install curl git
        echo "[+] Done installing packages."
        echo "[*] Checking for previous backups..."

        if [ -e "/usr/data/mainsailbackup" ]; then
            echo "[!] Warning: /usr/data/mainsailbackup already exists. It is recommended to move it manually if you have already updated once."
            printf "[?] Would you like to overwrite it? (y/N): "
            read -r reply
            case "$reply" in
                [Yy]*)
                    echo "[*] Removing existing mainsailbackup..."
                    rm -rf "/usr/data/mainsailbackup"
                    echo "[+] Removed. Ready to continue with mainsail update."
                    ;;
                *)
                    echo "[!] Overwrite declined. Aborting operation."
                    printf "Press Enter to return..."
                    read -r _
                    return 1
                    ;;
            esac
        fi

        echo "[+] Continuing update."
        echo "[+] Moving old Mainsail"
        mv /usr/data/mainsail /usr/data/mainsailbackup
        mkdir /usr/data/mainsail && cd /usr/data/mainsail
        echo "[+] Downloading new Mainsail..."
        curl -LO --output-dir /usr/data/ https://github.com/mainsail-crew/mainsail/releases/download/v2.18.2/mainsail.zip
        echo "[+] Unzipping Mainsail..."
        unzip /usr/data/mainsail.zip -d /usr/data/mainsail
        echo "[+] Deleting Mainsail ZIP"
        rm -rf /usr/data/mainsail.zip
        echo "[*] All finished! Ready to reboot!"
        printf "Press Enter to reboot..."
        read -r _
        echo "[*] Printer will reboot now! Goodbye."
        reboot
    else
        echo "[!] Entware doesn't seem to be installed. Please add Entware!"
        echo "[!] Entware package failure!"
    fi
    printf "Press Enter to return..."
    read -r _
}

update_moonraker () {
    echo "Updating Moonraker isn't supported yet..."
    echo "Check back for updates!"
    printf "Press Enter to return..."
    read -r _
}

credits () {
    echo "================================================================"
    echo "                          Credits for"
    echo "                          Version 1.2.1"
    echo ""
    echo "All scripts are made by Cart. Some AI assist, not written by AI."
    echo " github/FlashForge-C5-Modding-Group/Creator-5-Written-Scripts "
    echo "================================================================"
    printf "Press Enter to return..."
    read -r _
}

# --- Main Menu Loop ---
while true; do
    show_menu
    printf "Enter your choice: "
    read -r CHOICE

    case "$CHOICE" in
        1)
            enable_nan_mips
            ;;
        2)
            install_entware
            ;;
        3)
            add_entware_packages
            ;;
        4)
            update_moonraker
            ;;
        5)
            echo "Exiting..."
            exit 0
            ;;
        98)
            credits
            ;;
        99)
            release_notes
            ;;
        *)
            echo "Invalid option. Please try again."
            sleep 1
            ;;
    esac
done
