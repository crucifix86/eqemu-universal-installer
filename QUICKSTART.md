# EQEmu Universal Installer - Quick Start Guide

## Ubuntu/Debian Quick Start (Fully Automated!)

```bash
git clone https://github.com/crucifix86/eqemu-universal-installer.git
cd eqemu-universal-installer
chmod +x install.sh scripts/install_linux.sh
sudo ./install.sh
```

**No user input required!** The installer auto-generates all credentials and saves them to `/root/eqemu_credentials.txt`.

Wait 15-30 minutes for installation to complete, then view your credentials:

```bash
cat /root/eqemu_credentials.txt
```

---

## Windows Installation (6 Steps)

1. **Clone the repository**:
   ```powershell
   git clone https://github.com/crucifix86/eqemu-universal-installer.git
   cd eqemu-universal-installer
   ```

2. **Right-click** `install.bat` and select **"Run as administrator"**

3. **Enter configuration** when prompted:
   - Database name: `peqdb`
   - Database user: `eqemu`
   - Database password: (create a secure password)
   - Server name: `My EQEmu Server`
   - Server short name: `myserver`

4. **Wait** for installation (15-30 minutes)

5. **Start the server**:
   ```
   cd C:\EQEmu\server
   Copy the executables from C:\EQEmu\bin to C:\EQEmu\server
   Run the server executables
   ```

6. **Connect** with your EQ client to `127.0.0.1`

## Linux Installation (6 Steps)

1. **Clone the repository**:
   ```bash
   git clone https://github.com/crucifix86/eqemu-universal-installer.git
   cd eqemu-universal-installer
   chmod +x install.sh scripts/install_linux.sh
   ```

2. **Run the installer** (No input required!):
   ```bash
   sudo ./install.sh
   ```

3. **Wait** for installation (15-30 minutes)
   - All credentials are auto-generated
   - Saved to `/root/eqemu_credentials.txt`

4. **View your credentials**:
   ```bash
   cat /root/eqemu_credentials.txt
   ```

5. **Start the server**:
   ```bash
   su - eqemu
   cd /home/eqemu/server
   ./start.sh
   ```

6. **Connect** with your EQ client to your server IP

## Creating a GM Account

1. Connect to server and create a character
2. Log in to MySQL:
   ```sql
   mysql -u eqemu -p peqdb
   ```
3. Set GM status:
   ```sql
   UPDATE account SET status = 255 WHERE name = 'YourAccountName';
   ```
4. Zone once to activate GM powers

## Firewall Ports (For External Access)

- **5998**: Titanium client
- **5999**: SoD client
- **9000**: World server
- **7100-7400**: Zone servers

## Need Help?

See `README.md` for detailed documentation and troubleshooting.

## Support

- Forums: https://www.eqemulator.org/forums/
- GitHub: https://github.com/EQEmu/Server
