## 🚀 How to Install & Use

# **Get a VPS first (For best results: US region).**
   👉 Order from [Contabo](https://www.anrdoezrs.net/click-101311044-14573812): [https://my.contabo.com/](https://www.anrdoezrs.net/click-101311044-14573812)

**Download Putty or Shellbean**
   SSH into the server:
   ssh root@your-server-ip
   
1. **Upload or create the script on your VPS**

   ```bash
   nano virtualpc.sh
   ```

   Paste the script content or
   Download the script:
   wget https://yourdomain.com/virtualpc.sh
   ./virtualpc.sh, then:

   ```bash
   chmod +x virtualpc.sh
   ```

3. **Run it**

   ```bash
   ./virtualpc.sh
   ```

   You’ll see the menu:

   ```
   1) Fresh Install
   2) Reinstall / Fix Crash
   3) Uninstall / Undo Everything
   4) Exit
   ```

4. **Choose an option**

   * Pick **1** for first-time setup (creates a new user, installs XFCE + XRDP + Chrome).
   * If login crashes later → run **2 (Reinstall)** and it will purge/reinstall everything.
   * To wipe all changes → run **3 (Uninstall)**.

5. **Connect with RDP**

   * On your PC (Windows: Remote Desktop, macOS: Microsoft Remote Desktop), connect to:

     ```
     your.server.ip:3389
     ```
   * Login with the username/password you set during install.

---
