# Changelog

## Universal Installer v1.0

### New Features

- **Cross-Platform Support**: Single installer package for both Windows and Linux
- **Automated Installation**: Full automation of prerequisites, dependencies, and configuration
- **Interactive Setup**: User-friendly prompts for all configuration options
- **Windows PowerShell Installer**: Modern PowerShell-based installer for Windows
- **Improved Linux Installer**: Enhanced bash script with better error handling
- **Automatic Database Import**: Automatically downloads and imports PEQ database
- **Map Download**: Automatically clones and installs PEQ maps
- **Binary Download**: Automatically downloads latest server binaries
- **Configuration Management**: Automatically updates JSON configuration files
- **Backup System**: Creates backups of configuration files before modification

### Windows-Specific Features

- Chocolatey package manager integration
- Automatic installation of:
  - MariaDB (MySQL)
  - Git
  - CMake
  - Perl
  - Visual C++ Redistributables
  - wget
- PowerShell-based installation with progress feedback
- Automatic service configuration
- JSON configuration file updating

### Linux-Specific Features

- Multi-distribution support:
  - Debian/Ubuntu
  - Red Hat/CentOS
  - Fedora
- Automatic installation of all prerequisites
- Automatic user creation (eqemu)
- Symlink management for server binaries
- Permission and ownership configuration
- dos2unix integration for cross-platform file compatibility
- systemd service configuration

### Installation Components

1. **Prerequisites and Dependencies**
   - Database server (MariaDB/MySQL)
   - Scripting languages (Perl, Lua)
   - Development tools and libraries
   - Version control (Git)

2. **Server Components**
   - Server configuration files
   - Quest scripts (PEQ)
   - Plugins
   - Assets and opcodes
   - Server binaries (latest release)

3. **Database**
   - PEQ database schema
   - Game content data
   - World server registration

4. **Maps**
   - Complete PEQ map set
   - All zones

### Documentation

- Comprehensive README with:
  - Installation instructions for both platforms
  - Configuration guide
  - Troubleshooting section
  - Advanced topics
- Quick Start Guide for rapid deployment
- Inline documentation in all scripts

### Improvements Over Original Installer

1. **Cross-Platform**: Works on both Windows and Linux
2. **Better Error Handling**: Graceful failures with helpful error messages
3. **Progress Feedback**: Clear indication of installation progress
4. **Modular Design**: Separate functions for each installation step
5. **Idempotent**: Can be run multiple times safely
6. **Configuration Backup**: Preserves existing configurations
7. **Updated URLs**: Uses latest repository URLs
8. **Modern Tools**: PowerShell for Windows, improved bash for Linux
9. **Better Security**: Secure password input, proper permissions
10. **Comprehensive Testing**: Checks for existing installations

### Directory Structure

```
universal_installer/
├── install.sh              # Main installer (Linux/Unix entry point)
├── install.bat             # Windows entry point
├── scripts/
│   ├── install_linux.sh    # Linux installation script
│   └── install_windows.ps1 # Windows installation script
├── install/                # Server files and assets
│   ├── assets/
│   ├── quests/
│   ├── plugins/
│   ├── eqemu_config.json
│   ├── login.json
│   └── [other server files]
├── README.md               # Comprehensive documentation
├── QUICKSTART.md           # Quick start guide
└── CHANGELOG.md            # This file
```

### Known Issues

- Windows installer requires Administrator privileges
- Linux installer requires root/sudo privileges
- Database download may fail on slow connections (can be retried)
- Map cloning requires Git to be installed
- Some antivirus software may flag the installer (false positive)

### Future Enhancements

- GUI installer option
- Docker container support
- Automatic update mechanism
- Web-based configuration panel
- Systemd service files for Linux
- Windows service installation
- Automated backup and restore
- Multi-server deployment
- Configuration validation
- Health check scripts

### Credits

Based on the original EQEmu installer by:
- Akkadius (Original Author)
- N0ctrnl (Co-Author)
- EQEmu Development Team
- EQEmu Community

### Version History

- **v1.0** (2025-10-30): Initial release of universal installer

### License

GPL v3 - Same as EQEmu Server

### Support

For issues, questions, or contributions:
- GitHub: https://github.com/EQEmu/Server
- Forums: https://www.eqemulator.org/forums/
- Discord: EQEmu Community Discord
