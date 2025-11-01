# Development TODO & External Resources

## 📋 Current Development Status

### ✅ Completed
- [x] Ubuntu 24.04 LTS fully automated installer
- [x] Auto-generated credentials system
- [x] Pre-compiled Perl 5.32.1 for Ubuntu 24.04
- [x] Pre-built binary distribution
- [x] Complete database and maps installation
- [x] Server management scripts (start/stop/status)
- [x] Safety backup system

### 🚧 In Progress
- [ ] Windows installer support
- [ ] Support for Ubuntu 20.04 / 22.04
- [ ] Testing on Debian 11/12
- [ ] Automated testing suite

### 📝 Planned Features
- [ ] Docker containerized deployment
- [ ] Web-based control panel
- [ ] Automatic server updates
- [ ] Multi-server instance support
- [ ] Backup and restore automation
- [ ] Performance monitoring integration

## 🔗 External Git Repositories

These are **upstream dependencies** we pull from (not maintained by this installer project):

### Primary Dependencies

#### EQEmu Server (Official)
- **Repository**: https://github.com/EQEmu/Server
- **Purpose**: Main EverQuest Emulator server source code
- **Used For**: Source code compilation (when needed) and server binaries
- **License**: GPL v3
- **Current Version**: v23.10.3
- **Binaries URL**: https://github.com/EQEmu/Server/releases/download/v23.10.3/eqemu-server-linux-x64.zip

#### PEQ Database (Community Content)
- **Repository**: https://github.com/peqarchive/peqdatabase
- **Purpose**: Game database with NPCs, spawns, quests, loot tables
- **Download URL**: https://github.com/peqarchive/peqdatabase/archive/refs/heads/main.zip
- **Used For**: Server database content
- **Updated**: Community maintained

#### PEQ Maps
- **Repository**: https://github.com/peqarchive/peqmaps
- **Purpose**: Zone map files for navigation and pathfinding
- **Clone URL**: https://github.com/peqarchive/peqmaps.git
- **Used For**: Server map data
- **Updated**: Community maintained

### Language & Tools

#### Perl 5.32.1
- **Source**: https://www.cpan.org/src/5.0/perl-5.32.1.tar.gz
- **Purpose**: Quest scripting language runtime
- **Why This Version**: EQEmu requires Perl 5.32.1 for map compatibility on Ubuntu 24.04
- **Our Pre-compiled Version**:
  - Built with threading and shared library support
  - Available at: `eqemu-perl-5.32.1-ubuntu24.04-x64.tar.gz` (18MB)
  - Hosted in our installer repository

## 🌐 External Services & APIs

### IP Detection Services
Used for automatic server configuration:
- **Primary**: https://api.ipify.org (IPv4 detection)
- **Fallback**: https://icanhazip.com (IPv4 detection)

## 📚 Documentation & Resources

### Official EQEmu Resources
- **Main Website**: https://www.eqemulator.org
- **Forums**: https://www.eqemulator.org/forums/
- **Wiki**: https://eqemulator.org/wiki
- **Discord**: Join via EQEmu forums

### Related Projects
- **EQEmu Server Docs**: https://github.com/EQEmu/Server/wiki
- **PEQ Editor**: https://github.com/ProjectEQ/peqphpeditor

## 🔧 Development Tools

### Required for Development
- **Git**: Version control
- **Bash**: Shell scripting
- **CMake**: Build system (for server compilation)
- **GCC/G++**: C++ compiler (for server compilation)

### Testing Environments
- **Primary**: Ubuntu 24.04 LTS (x86_64)
- **Planned**: Ubuntu 22.04 LTS, Ubuntu 20.04 LTS
- **Future**: Debian 11/12, CentOS Stream

## 📦 Our Custom Components

These are maintained in **this installer repository**:

### Pre-compiled Binaries
- **Perl 5.32.1**: `eqemu-perl-5.32.1-ubuntu24.04-x64.tar.gz` (18MB)
  - Thread-enabled build
  - Shared library support
  - Ubuntu 24.04 compatible

### Installation Scripts
- `install.sh` - Main installer entry point
- `scripts/install_linux.sh` - Linux installation logic
- `scripts/install_windows.ps1` - Windows installation (WIP)

### Management Scripts
- Located in server directory after installation:
  - `start.sh` - Start all server processes
  - `stop.sh` - Stop all server processes
  - `status.sh` - Check server status

## 🐛 Known Issues

### Ubuntu 24.04
- ✅ **FIXED**: Map crashes with system Perl 5.38.2
  - **Solution**: Use pre-compiled Perl 5.32.1

### General
- Windows installer not yet functional
- Ubuntu 20.04/22.04 not tested with new Perl installer
- Some edge cases with firewall auto-configuration

## 🤝 Contributing

### Before Contributing
1. Test on a clean Ubuntu 24.04 LTS VPS
2. Verify all auto-generated credentials are saved
3. Ensure pre-compiled Perl works correctly
4. Check that server starts without errors

### Submitting Changes
1. Fork the repository
2. Create a feature branch
3. Test thoroughly on Ubuntu 24.04
4. Submit pull request with detailed description

## 📞 Support Channels

- **GitHub Issues**: Report bugs and feature requests
- **EQEmu Forums**: General EQEmu support
- **Installer Issues**: https://github.com/crucifix86/eqemu-universal-installer/issues

## 📄 Version History

- **2025-10-31**: Added Perl 5.32.1 pre-compiled support
- **2025-10-31**: Fixed auto-credentials system
- **2025-10-31**: Created safety backup system
- **Earlier**: Initial Ubuntu installer development

---

**Last Updated**: October 31, 2025
**Maintainer**: crucifix86
**Status**: Active Development
