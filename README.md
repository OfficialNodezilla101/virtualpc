## 🚀 How to Install & Use

### **Get a VPS first (For best results: US region).**
   👉 Order from [Contabo](https://www.anrdoezrs.net/click-101311044-14573812): [https://my.contabo.com/](https://www.anrdoezrs.net/click-101311044-14573812)

**Download Putty (Windows) or Shellbean (Mac or iphone)**
   SSH into the server:
   ssh root@your-server-ip
   Enter password
   
1. **Access the script on your VPS**

   `bash <(wget -qO- https://raw.githubusercontent.com/OfficialNodezilla101/virtualpc/main/virtualpc.sh)`
   , then:

   You’ll see the menu:

   ```
   1) Fresh Install
   2) Reinstall / Fix Crash
   3) Uninstall / Undo Everything
   4) Exit
   ```

2. **Choose an option**

   * Pick **1** for first-time setup (creates a new user, installs XFCE + XRDP + Chrome).
   * If login crashes later → run **2 (Reinstall)** and it will purge/reinstall everything.
   * To wipe all changes → run **3 (Uninstall)**.

3. **Connect with RDP**

   * On your PC (Windows: Remote Desktop, macOS: Microsoft Remote Desktop), connect to:

     ```
     your.server.ip:3389
     ```
   * Login with the username/password you set during install.

---
