# EverQuest Emulator Universal Installer

A cross-platform installer for EverQuest Emulator (EQEmu) server that supports both **Windows** and **Linux** operating systems.

## 🚀 Quick Installation (Ubuntu/Debian)

```bash
# Clone the repository
git clone https://github.com/crucifix86/eqemu-universal-installer.git
cd eqemu-universal-installer

# Make installer executable
chmod +x install.sh scripts/install_linux.sh

# Run installer as root
sudo ./install.sh
```

**✨ Fully Automated** - No user input required! The installer:
- Auto-generates all passwords and credentials
- Saves everything to `/root/eqemu_credentials.txt`
- Installs and configures everything automatically

Installation takes 15-30 minutes. All your credentials will be saved to a text file for you to review after installation.

### 💡 Testing on Ubuntu VPS

If you're testing on a fresh Ubuntu VPS:

```bash
# Update system first
sudo apt update && sudo apt upgrade -y

# Install git if not present
sudo apt install git -y

# Clone and run installer
git clone https://github.com/crucifix86/eqemu-universal-installer.git
cd eqemu-universal-installer
chmod +x install.sh scripts/install_linux.sh
sudo ./install.sh
```

**Important**:
- All credentials are auto-generated and saved to `/root/eqemu_credentials.txt`
- The installer creates an `eqemu` user with a generated password
- After installation:
  - View credentials: `cat /root/eqemu_credentials.txt`
  - Start server: `cd /home/eqemu/server && ./start.sh`
  - Check status: `cd /home/eqemu/server && ./status.sh`
  - Stop server: `cd /home/eqemu/server && ./stop.sh`

## 📋 Table of Contents

- [Features](#features)
- [Requirements](#requirements)
- [Quick Start](#quick-start)
  - [Windows Installation](#windows-installation)
  - [Linux Installation](#linux-installation)
- [What Gets Installed](#what-gets-installed)
- [Post-Installation](#post-installation)
- [Configuration](#configuration)
- [Troubleshooting](#troubleshooting)
- [Advanced Topics](#advanced-topics)
- [Credits](#credits)

## Features

- **Universal**: Single installer package for both Windows and Linux
- **Fully Automated**: Zero user input required - auto-generates all credentials
- **Secure**: Generates strong random passwords and saves them securely
- **Safe**: Creates backups of configuration files before modification
- **Complete**: Includes server files, maps, database, and binaries
- **Clean VPS Ready**: Designed for fresh Ubuntu/Debian installations

## Requirements

### Windows

- Windows 10/11 or Windows Server 2016+
- Administrator privileges
- Internet connection (for downloading dependencies)
- At least 10 GB free disk space

### Linux

- Debian 10+, Ubuntu 18.04+, Fedora 30+, or CentOS 7+
- Root/sudo privileges
- Internet connection (for downloading dependencies)
- At least 10 GB free disk space

## Quick Start

### Windows Installation

1. **Clone the repository** or download as ZIP:
   ```powershell
   git clone https://github.com/crucifix86/eqemu-universal-installer.git
   cd eqemu-universal-installer
   ```

   Or download ZIP from GitHub and extract it.

2. **Run as Administrator**:
   - Right-click on `install.bat`
   - Select "Run as administrator"

3. **Follow the prompts**:
   - Database name (e.g., `peqdb`)
   - Database username (e.g., `eqemu`)
   - Database password (create a secure password)
   - Server long name (e.g., `My EQEmu Server`)
   - Server short name (e.g., `myserver`)

4. **Wait for installation to complete**
   - This may take 15-30 minutes depending on your internet connection
   - The installer will:
     - Install Chocolatey package manager
     - Install all prerequisites (Git, MariaDB, Perl, etc.)
     - Download server binaries
     - Download and import PEQ database
     - Download PEQ maps
     - Configure server files

5. **Complete post-installation steps** (see [Post-Installation](#post-installation))

### Linux Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/crucifix86/eqemu-universal-installer.git
   cd eqemu-universal-installer
   ```

2. **Make the installer executable**:
   ```bash
   chmod +x install.sh
   chmod +x scripts/install_linux.sh
   ```

3. **Run the installer as root**:
   ```bash
   sudo ./install.sh
   ```

4. **Wait for installation to complete** (No user input required!)
   - This may take 15-30 minutes depending on your internet connection
   - The installer will:
     - Auto-generate secure passwords
     - Install all prerequisites (MariaDB, Perl, Lua, etc.)
     - Download server binaries
     - Download and import PEQ database
     - Download PEQ maps
     - Configure server files
     - Set up the eqemu user and directories
     - Save all credentials to `/root/eqemu_credentials.txt`

5. **View your credentials**:
   ```bash
   cat /root/eqemu_credentials.txt
   ```

6. **Complete post-installation steps** (see [Post-Installation](#post-installation))

## What Gets Installed

### Prerequisites and Dependencies

**Windows:**
- Chocolatey package manager
- Git
- CMake
- Perl
- MariaDB (MySQL)
- Visual C++ Redistributables
- wget

**Linux:**
- Build tools (gcc, g++, make, cmake)
- MariaDB (MySQL)
- Perl and required modules
- Lua and libraries
- Git
- Various development libraries (libsodium, openssl, etc.)

### Server Components

- **Server Files**: Configuration files, quest scripts, plugins
- **Server Binaries**: Latest EQEmu server executables
- **Maps**: PEQ maps for all zones
- **Database**: PEQ database with game content
- **Scripts**: Start, stop, and status scripts

### Directory Structure

**Windows (Default: C:\EQEmu):**
```
C:\EQEmu\
├── server\          # Main server directory
│   ├── assets\
│   ├── quests\
│   ├── plugins\
│   ├── maps\
│   ├── eqemu_config.json
│   └── login.json
├── bin\             # Server executables
├── database\        # Database SQL files
└── logs\            # Log files
```

**Linux (Default: /home/eqemu):**
```
/home/eqemu/
├── server/          # Main server directory
│   ├── assets/
│   ├── quests/
│   ├── plugins/
│   ├── maps/
│   ├── eqemu_config.json
│   ├── login.json
│   ├── start.sh
│   ├── stop.sh
│   └── status.sh
├── bin/             # Server executables
├── database/        # Database SQL files
└── source/          # Source code (if compiling)
```

## Post-Installation

### Windows

1. **Copy server binaries** (if not already done):
   ```powershell
   Copy-Item C:\EQEmu\bin\* C:\EQEmu\server\
   ```

2. **Verify database import**:
   - Open Command Prompt or PowerShell
   - Navigate to `C:\EQEmu\database`
   - Check that the database was imported successfully

3. **Start the server**:
   ```powershell
   cd C:\EQEmu\server
   .\start.sh  # Or start the executables manually
   ```

### Linux

1. **Log in as the eqemu user** (optional but recommended):
   ```bash
   su - eqemu
   ```

2. **Navigate to the server directory**:
   ```bash
   cd /home/eqemu/server
   ```

3. **Start the server**:
   ```bash
   ./start.sh
   ```

4. **Check server status**:
   ```bash
   ./status.sh
   ```

5. **View logs**:
   ```bash
   tail -f logs/eqemu_world.log
   ```

### Creating a GM Account

1. **Start your EverQuest client** (RoF2 or compatible)

2. **Connect to your server** and create a character

3. **Log in to the database**:

   **Windows:**
   ```powershell
   mysql -u eqemu -p peqdb
   ```

   **Linux:**
   ```bash
   mysql -u eqemu -p peqdb
   ```

4. **Set GM status** (replace `YourAccountName` with your account):
   ```sql
   UPDATE account SET status = 255 WHERE name = 'YourAccountName';
   ```

5. **Zone once** with your character to activate GM commands

## Configuration

### Server Configuration Files

#### eqemu_config.json

Main server configuration file. Key settings:

- **database**: Database connection settings
- **world.longname**: Server name shown in server list
- **world.shortname**: Short identifier for the server
- **world.address**: IP address for external connections
- **zones.ports**: Port range for zone servers

#### login.json

Login server configuration. Key settings:

- **database**: Database connection settings
- **client_configuration**: Client opcodes and ports
- **account.auto_create_accounts**: Auto-create accounts on login

### Network Configuration

For external access, you'll need to:

1. **Configure your firewall** to allow:
   - Port 5998 (Titanium client)
   - Port 5999 (SoD client)
   - Port 9000 (World server)
   - Ports 7100-7400 (Zone servers)

2. **Update server configuration**:
   - Set `world.address` and `world.localaddress` in `eqemu_config.json`
   - Use your public IP for external access

3. **Port forwarding** (if behind a router):
   - Forward the above ports to your server's local IP

## Troubleshooting

### Windows

**Problem**: Chocolatey installation fails
- **Solution**: Ensure you're running as Administrator and have internet access
- Try installing Chocolatey manually: https://chocolatey.org/install

**Problem**: MariaDB service won't start
- **Solution**: Check Windows Services, ensure MariaDB is installed correctly
- Try reinstalling: `choco uninstall mariadb -y && choco install mariadb -y`

**Problem**: Server binaries not found
- **Solution**: Download manually from https://github.com/EQEmu/Server/releases
- Extract to `C:\EQEmu\bin`

### Linux

**Problem**: Package installation fails
- **Solution**: Run `apt-get update` (Debian/Ubuntu) or `yum update` (RedHat/CentOS)
- Check your internet connection
- Ensure you have enough disk space

**Problem**: Permission denied errors
- **Solution**: Ensure you're running the installer as root (`sudo`)
- Check file permissions: `ls -la /home/eqemu`

**Problem**: Database import fails
- **Solution**: Check MySQL/MariaDB is running: `systemctl status mariadb`
- Verify database credentials in `install_variables.txt`
- Try importing manually: `mysql -u eqemu -p peqdb < create_all_tables.sql`

**Problem**: Server won't start
- **Solution**: Check symlinks exist: `ls -la /home/eqemu/server`
- Verify binary permissions: `chmod 755 /home/eqemu/bin/*`
- Check logs: `tail -f /home/eqemu/server/logs/*.log`

### General

**Problem**: Can't connect from client
- **Solution**: Verify server is running
- Check firewall settings
- Ensure client configuration points to correct IP
- Verify ports are open and forwarded

**Problem**: Database connection errors
- **Solution**: Check credentials in `eqemu_config.json` and `login.json`
- Verify database exists: `mysql -u root -p -e "SHOW DATABASES;"`
- Test connection: `mysql -u eqemu -p peqdb`

## Advanced Topics

### Compiling from Source

If you want to compile the server binaries yourself:

**Linux:**
```bash
# Create source directory
mkdir -p /home/eqemu/server_source
cd /home/eqemu/server_source

# Clone source code
git clone https://github.com/EQEmu/Server.git .
git submodule init
git submodule update

# Create build directory
mkdir -p /home/eqemu/server_build
cd /home/eqemu/server_build

# Configure and build
cmake -DEQEMU_BUILD_LOGIN=ON -DEQEMU_BUILD_LUA=ON -G "Unix Makefiles" /home/eqemu/server_source
make

# Binaries will be in /home/eqemu/server_build/bin/
```

**Windows:**
- Install Visual Studio 2019 or later
- Follow the EQEmu compilation guide: https://github.com/EQEmu/Server/wiki

### Custom Installation Paths

**Windows:**
```powershell
.\scripts\install_windows.ps1 -InstallPath "D:\MyEQServer"
```

**Linux:**
Edit the installation script and change `EQEMU_INSTALL_DIR` variable.

### Updating the Server

To update server binaries:

1. Download latest binaries
2. Stop the server
3. Replace binaries in the `bin` directory
4. Start the server

To update database:

1. Check for updates in the PEQ database repository
2. Apply SQL patches from `server/db_update` directory
3. Or download fresh database and import

### Multiple Server Instances

You can run multiple server instances by:

1. Creating separate installation directories
2. Using different database names
3. Configuring different port ranges
4. Updating `eqemu_config.json` accordingly

## Credits

- **EQEmu Development Team**: For the server software
- **Project EQ**: For the database and quests
- **Installer Author**: Based on the original installer by Akkadius
- **Co-Authors**: N0ctrnl and the EQEmu community

## Disclaimer

EverQuest is a registered trademark of Daybreak Game Company LLC.

EQEmulator is not associated or affiliated in any way with Daybreak Game Company LLC.

This software is provided for educational and development purposes only.

## Support

- **EQEmu Forums**: https://www.eqemulator.org/forums/
- **Discord**: Join the EQEmu Discord community
- **GitHub**: https://github.com/EQEmu/Server

## License

This installer is provided as-is, without warranty of any kind.

The EQEmu server software is licensed under the GPL v3 license.
