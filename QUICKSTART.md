# EQEmu Universal Installer - Quick Start Guide

## Windows Installation (5 Steps)

1. **Right-click** `install.bat` and select **"Run as administrator"**

2. **Enter configuration** when prompted:
   - Database name: `peqdb`
   - Database user: `eqemu`
   - Database password: (create a secure password)
   - Server name: `My EQEmu Server`
   - Server short name: `myserver`

3. **Wait** for installation (15-30 minutes)

4. **Start the server**:
   ```
   cd C:\EQEmu\server
   Copy the executables from C:\EQEmu\bin to C:\EQEmu\server
   Run the server executables
   ```

5. **Connect** with your EQ client to `127.0.0.1`

## Linux Installation (5 Steps)

1. **Run the installer**:
   ```bash
   sudo ./install.sh
   ```

2. **Enter configuration** when prompted:
   - eqemu user password: (create a password)
   - MySQL root password: (create a password)
   - Database name: `peqdb`
   - Database user: `eqemu`
   - Database password: (create a password)
   - Server name: `My EQEmu Server`
   - Server short name: `myserver`

3. **Wait** for installation (15-30 minutes)

4. **Start the server**:
   ```bash
   su - eqemu
   cd /home/eqemu/server
   ./start.sh
   ```

5. **Connect** with your EQ client to your server IP

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
