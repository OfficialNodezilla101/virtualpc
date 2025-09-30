#!/bin/bash

# Colors
INFO='\033[0;36m'
WARNING='\033[0;33m'
ERROR='\033[0;31m'
SUCCESS='\033[0;32m'
NC='\033[0m'

# === FUNCTIONS ===

fresh_install() {
    # Prompt user/pass
    while true; do
        read -p "Enter the username for remote desktop: " USER
        if [[ "$USER" == "root" ]]; then
            echo -e "${ERROR}Error: 'root' cannot be used.${NC}"
        elif [[ "$USER" =~ [^a-zA-Z0-9] ]]; then
            echo -e "${ERROR}Error: Username must be alphanumeric.${NC}"
        else break; fi
    done

    while true; do
        read -sp "Enter the password for $USER: " PASSWORD
        echo
        if [[ "$PASSWORD" =~ [^a-zA-Z0-9] ]]; then
            echo -e "${ERROR}Error: Password must be alphanumeric.${NC}"
        else break; fi
    done

    echo -e "${INFO}Updating packages...${NC}"
    sudo apt update

    echo -e "${INFO}Installing XFCE + XRDP...${NC}"
    sudo apt install -y xfce4 xfce4-goodies xrdp xorgxrdp dbus-x11 policykit-1

    echo -e "${INFO}Adding user $USER...${NC}"
    sudo useradd -m -s /bin/bash $USER
    echo "$USER:$PASSWORD" | sudo chpasswd
    sudo usermod -aG sudo $USER

    # Per-user session
    sudo -u "$USER" bash -lc 'echo "exec startxfce4" > ~/.xsession && chmod 644 ~/.xsession'

    # Global XRDP startup
    sudo tee /etc/xrdp/startwm.sh >/dev/null <<'SH'
#!/bin/sh
export DESKTOP_SESSION=xfce
export XDG_SESSION_DESKTOP=xfce
export XDG_CURRENT_DESKTOP=XFCE
if [ -r "$HOME/.xsession" ]; then
    exec /bin/sh "$HOME/.xsession"
fi
exec dbus-launch --exit-with-session startxfce4
SH
    sudo chmod +x /etc/xrdp/startwm.sh

    # Config tweaks
    echo "allowed_users=anybody" | sudo tee /etc/X11/Xwrapper.config >/dev/null
    sudo sed -i '/^#xserverbpp=24/s/^#//; s/xserverbpp=24/xserverbpp=16/' /etc/xrdp/xrdp.ini
    grep -q '^max_bpp=' /etc/xrdp/xrdp.ini || echo 'max_bpp=16' | sudo tee -a /etc/xrdp/xrdp.ini > /dev/null
    grep -q '^xres=' /etc/xrdp/xrdp.ini || echo 'xres=1280' | sudo tee -a /etc/xrdp/xrdp.ini > /dev/null
    grep -q '^yres=' /etc/xrdp/xrdp.ini || echo 'yres=720' | sudo tee -a /etc/xrdp/xrdp.ini > /dev/null

    sudo systemctl enable xrdp
    sudo systemctl restart xrdp

    echo -e "${INFO}Installing Chrome...${NC}"
    sudo apt install -y wget gnupg
    wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
    echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list
    sudo apt update && sudo apt install -y google-chrome-stable

    if command -v ufw >/dev/null; then
        if sudo ufw status | grep -q "Status: active"; then
            sudo ufw allow 3389/tcp
            echo -e "${SUCCESS}Port 3389 opened in UFW.${NC}"
        fi
    fi

    echo -e "${SUCCESS}Installation complete. Connect via RDP as $USER.${NC}"
}

reinstall_fix() {
    echo -e "${WARNING}Stopping and removing XRDP + XFCE...${NC}"
    sudo systemctl stop xrdp xrdp-sesman
    sudo pkill -9 -f xrdp || true
    sudo apt purge -y xrdp xorgxrdp xfce4 xfce4-goodies
    sudo rm -rf /etc/xrdp /var/log/xrdp /var/run/xrdp
    sudo apt autoremove -y

    echo -e "${INFO}Proceeding with fresh reinstall...${NC}"
    fresh_install
}

uninstall_all() {
    echo -e "${WARNING}Removing XRDP, XFCE, Chrome, and created users...${NC}"
    sudo systemctl stop xrdp || true
    sudo apt purge -y xrdp xorgxrdp xfce4 xfce4-goodies google-chrome-stable
    sudo apt autoremove -y
    sudo rm -rf /etc/xrdp /var/log/xrdp /var/run/xrdp \
        /etc/apt/sources.list.d/google-chrome.list /etc/X11/Xwrapper.config

    # Remove non-root users created for RDP
    for u in $(getent passwd | awk -F: '$3 >= 1000 && $1 != "nobody" {print $1}'); do
        echo -e "${INFO}Removing user $u...${NC}"
        sudo deluser --remove-home "$u"
    done

    echo -e "${SUCCESS}Everything uninstalled. Desktop access is removed.${NC}"
}

# === MENU ===
while true; do
    echo -e "${INFO}==== Nodezilla101 Desktop Manager ====${NC}"
    echo "1) Fresh Install"
    echo "2) Reinstall / Fix Crash"
    echo "3) Uninstall / Undo Everything"
    echo "4) Exit"
    read -p "Choose an option [1-4]: " choice
    case $choice in
        1) fresh_install ;;
        2) reinstall_fix ;;
        3) uninstall_all ;;
        4) exit 0 ;;
        *) echo -e "${ERROR}Invalid choice.${NC}" ;;
    esac
done
