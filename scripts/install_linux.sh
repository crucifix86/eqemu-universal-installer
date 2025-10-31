#!/usr/bin/env bash

#########################################################
# EverQuest Emulator Linux Installer
# Bash Installation Script
#########################################################

set -e  # Exit on error

# Check for root privileges
if [[ $EUID -ne 0 ]]; then
    echo "ERROR: This script must be run as root"
    echo "Please run: sudo ./install.sh"
    exit 1
fi

# Installation variables
export EQEMU_USER="eqemu"
export EQEMU_INSTALL_DIR="/home/$EQEMU_USER"
export EQEMU_SERVER_DIR="$EQEMU_INSTALL_DIR/server"
export EQEMU_BIN_DIR="$EQEMU_INSTALL_DIR/bin"
export EQEMU_DB_DIR="$EQEMU_INSTALL_DIR/database"
export EQEMU_SOURCE_DIR="$EQEMU_INSTALL_DIR/source"
export APT_OPTIONS="-y -qq"

echo "##########################################################"
echo "#  EverQuest Emulator Linux Installer                   #"
echo "##########################################################"
echo "#                                                        #"
echo "#  This installer will set up:                          #"
echo "#  - MariaDB (MySQL) database server                    #"
echo "#  - Perl scripting language                            #"
echo "#  - LUA scripting language                             #"
echo "#  - Server files and directories                       #"
echo "#  - Prerequisites and dependencies                     #"
echo "#                                                        #"
echo "##########################################################"
echo ""

#########################################################
# Detect Linux Distribution
#########################################################

detect_os() {
    if [[ -f /etc/debian_version ]]; then
        export OS="Debian"
        echo "Detected OS: Debian/Ubuntu"
    elif [[ -f /etc/fedora-release ]]; then
        export OS="fedora_core"
        echo "Detected OS: Fedora"
    elif [[ -f /etc/redhat-release ]]; then
        export OS="red_hat"
        echo "Detected OS: Red Hat/CentOS"
    else
        echo "ERROR: Unsupported Linux distribution"
        echo "This installer supports: Debian, Ubuntu, Fedora, Red Hat, CentOS"
        exit 1
    fi
}

#########################################################
# Collect User Input
#########################################################

collect_user_input() {
    echo ""
    echo "==========================================================="
    echo "Configuration Setup"
    echo "==========================================================="
    echo ""
    echo "Please provide the following information:"
    echo ""

    # Check if install_variables.txt exists
    if [ -f "$EQEMU_INSTALL_DIR/install_variables.txt" ]; then
        echo "Found existing installation configuration"
        read -p "Do you want to use the existing configuration? (y/n): " use_existing
        if [[ "$use_existing" == "y" || "$use_existing" == "Y" ]]; then
            source "$EQEMU_INSTALL_DIR/install_variables.txt"
            echo "Using existing configuration"
            return
        fi
    fi

    # EQEmu user password
    echo "Create password for Linux user 'eqemu':"
    read -s EQEMU_USER_PASSWORD
    echo ""

    # MySQL root password
    read -p "Enter MySQL root password: " MYSQL_ROOT_PASSWORD
    echo ""

    # Database configuration
    read -p "Enter database name (lowercase, no special characters): " EQEMU_DB_NAME
    read -p "Enter database username: " EQEMU_DB_USER
    read -p "Enter database password: " EQEMU_DB_PASSWORD
    echo ""

    # Server configuration
    read -p "Enter server long name (e.g., My EQEmu Server): " SERVER_LONG_NAME
    read -p "Enter server short name (e.g., myserver): " SERVER_SHORT_NAME
    echo ""

    # Confirm settings
    echo "==========================================================="
    echo "Configuration Summary:"
    echo "==========================================================="
    echo "Installation Directory: $EQEMU_INSTALL_DIR"
    echo "Database Name: $EQEMU_DB_NAME"
    echo "Database User: $EQEMU_DB_USER"
    echo "Server Long Name: $SERVER_LONG_NAME"
    echo "Server Short Name: $SERVER_SHORT_NAME"
    echo "==========================================================="
    echo ""

    read -p "Continue with installation? (y/n): " confirm
    if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
        echo "Installation cancelled"
        exit 0
    fi
}

#########################################################
# Create EQEmu User
#########################################################

create_eqemu_user() {
    echo ""
    echo "[Step] Creating eqemu user..."

    # Check if user already exists
    if id "$EQEMU_USER" &>/dev/null; then
        echo "  User '$EQEMU_USER' already exists"
    else
        groupadd -f $EQEMU_USER
        useradd -g $EQEMU_USER -m -d $EQEMU_INSTALL_DIR $EQEMU_USER
        echo "$EQEMU_USER:$EQEMU_USER_PASSWORD" | chpasswd
        echo "  User '$EQEMU_USER' created successfully"
    fi
}

#########################################################
# Install Debian/Ubuntu Prerequisites
#########################################################

install_debian_prereqs() {
    echo ""
    echo "[Step] Installing Debian/Ubuntu prerequisites..."

    apt-get -y update

    # Install packages
    local packages=(
        bash build-essential cmake cpp curl debconf-utils g++ gcc git git-core
        libio-stringy-perl liblua5.1-0 liblua5.1-dev libluabind-dev
        libmysql++-dev libperl-dev libperl5i-perl libmysqlclient-dev
        minizip lua5.1 make mariadb-client mariadb-server
        open-vm-tools unzip uuid-dev wget zlib1g zlib1g-dev
        libsodium-dev libsodium23 libjson-perl libssl-dev dos2unix
    )

    for package in "${packages[@]}"; do
        echo "  Installing $package..."
        apt-get $APT_OPTIONS install $package || echo "    Warning: Failed to install $package"
    done

    echo "  Prerequisites installed successfully"
}

#########################################################
# Install Red Hat/CentOS Prerequisites
#########################################################

install_redhat_prereqs() {
    echo ""
    echo "[Step] Installing Red Hat/CentOS prerequisites..."

    yum -y install epel-release deltarpm
    yum -y update

    yum -y install \
        open-vm-tools vim cmake3 boost-devel zlib-devel \
        mariadb mariadb-server mariadb-devel mariadb-libs \
        perl-DBD-MySQL perl-JSON perl-IO-stringy perl-devel \
        perl-Time-HiRes lua-devel dos2unix \
        libuuid-devel libsodium libsodium-devel openssl-devel

    yum -y groupinstall "Development Tools"

    # Configure cmake3 alternative
    alternatives --install /usr/local/bin/cmake cmake /usr/bin/cmake3 20 \
        --slave /usr/local/bin/ctest ctest /usr/bin/ctest3 \
        --slave /usr/local/bin/cpack cpack /usr/bin/cpack3 \
        --slave /usr/local/bin/ccmake ccmake /usr/bin/ccmake3 \
        --family cmake

    echo "  Prerequisites installed successfully"
}

#########################################################
# Install Fedora Prerequisites
#########################################################

install_fedora_prereqs() {
    echo ""
    echo "[Step] Installing Fedora prerequisites..."

    dnf -y install \
        open-vm-tools vim cmake boost-devel zlib-devel \
        mariadb-server mariadb-devel perl perl-DBD-MySQL \
        perl-IO-stringy perl-devel lua-devel lua-sql-mysql \
        dos2unix wget compat-lua-libs compat-lua-devel compat-lua \
        perl-Time-HiRes perl-JSON libuuid-devel \
        libsodium libsodium-devel openssl-devel

    dnf -y group install "Development Tools" "C Development Tools and Libraries"

    echo "  Prerequisites installed successfully"
}

#########################################################
# Configure MariaDB
#########################################################

configure_mariadb() {
    echo ""
    echo "[Step] Configuring MariaDB..."

    # Start and enable MariaDB
    if [[ "$OS" == "Debian" ]]; then
        # Configure MariaDB for Debian/Ubuntu
        export DEBIAN_FRONTEND=noninteractive
        debconf-set-selections <<< "mariadb-server mysql-server/root_password password TEMP_PASS"
        debconf-set-selections <<< "mariadb-server mysql-server/root_password_again password TEMP_PASS"

        systemctl enable mariadb 2>/dev/null || service mariadb start
        systemctl start mariadb 2>/dev/null || service mariadb start
        sleep 3

        # Set root password
        mysql -uroot -pTEMP_PASS -e "SET PASSWORD FOR 'root'@'localhost' = PASSWORD('$MYSQL_ROOT_PASSWORD');" 2>/dev/null || \
        mysql -uroot -e "SET PASSWORD FOR 'root'@'localhost' = PASSWORD('$MYSQL_ROOT_PASSWORD');" 2>/dev/null || \
        mysqladmin -u root password "$MYSQL_ROOT_PASSWORD" 2>/dev/null
    else
        # Configure MariaDB for Red Hat/Fedora
        systemctl enable mariadb.service --now
        sleep 3
        mysqladmin -u root password "$MYSQL_ROOT_PASSWORD" 2>/dev/null || true
    fi

    # Create database and user
    echo "  Creating database and user..."
    mysql -uroot -p"$MYSQL_ROOT_PASSWORD" <<EOF
CREATE DATABASE IF NOT EXISTS \`$EQEMU_DB_NAME\`;
CREATE USER IF NOT EXISTS '$EQEMU_DB_USER'@'localhost' IDENTIFIED BY '$EQEMU_DB_PASSWORD';
GRANT ALL PRIVILEGES ON *.* TO '$EQEMU_DB_USER'@'localhost' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EOF

    echo "  MariaDB configured successfully"
}

#########################################################
# Create Directory Structure
#########################################################

create_directories() {
    echo ""
    echo "[Step] Creating directory structure..."

    local directories=(
        "$EQEMU_SERVER_DIR"
        "$EQEMU_BIN_DIR"
        "$EQEMU_DB_DIR"
        "$EQEMU_SOURCE_DIR"
        "$EQEMU_SERVER_DIR/export"
        "$EQEMU_SERVER_DIR/logs"
        "$EQEMU_SERVER_DIR/shared"
        "$EQEMU_SERVER_DIR/maps"
    )

    for dir in "${directories[@]}"; do
        if [ ! -d "$dir" ]; then
            mkdir -p "$dir"
            echo "  Created: $dir"
        fi
    done
}

#########################################################
# Copy Server Files
#########################################################

copy_server_files() {
    echo ""
    echo "[Step] Copying server files..."

    local source_dir="$(dirname "$(dirname "$(readlink -f "$0")")")/install"

    if [ -d "$source_dir" ]; then
        echo "  Copying from: $source_dir"
        cp -r "$source_dir"/* "$EQEMU_SERVER_DIR/"
        echo "  Server files copied successfully"
    else
        echo "  Warning: Install directory not found at $source_dir"
        echo "  You will need to copy server files manually"
    fi
}

#########################################################
# Download Server Binaries
#########################################################

download_server_binaries() {
    echo ""
    echo "[Step] Downloading server binaries..."

    cd "$EQEMU_BIN_DIR"

    local download_url="https://github.com/EQEmu/Server/releases/download/v23.10.3/eqemu-server-linux-x64.zip"

    echo "  Downloading from: $download_url"
    wget -q --show-progress "$download_url" -O eqemu-server-linux-x64.zip

    echo "  Extracting binaries..."
    unzip -q eqemu-server-linux-x64.zip
    rm eqemu-server-linux-x64.zip

    # Set permissions
    echo "  Setting executable permissions..."
    chmod 755 "$EQEMU_BIN_DIR"/*

    echo "  Server binaries downloaded successfully"
}

#########################################################
# Create Symbolic Links
#########################################################

create_symlinks() {
    echo ""
    echo "[Step] Creating symbolic links..."

    cd "$EQEMU_SERVER_DIR"

    local binaries=(
        "loginserver"
        "shared_memory"
        "world"
        "eqlaunch"
        "zone"
        "ucs"
        "queryserv"
        "import_client_files"
        "export_client_files"
    )

    for binary in "${binaries[@]}"; do
        if [ -f "$EQEMU_BIN_DIR/$binary" ]; then
            ln -sf "$EQEMU_BIN_DIR/$binary" "$EQEMU_SERVER_DIR/$binary"
            echo "  Created symlink: $binary"
        fi
    done
}

#########################################################
# Download Maps
#########################################################

download_maps() {
    echo ""
    echo "[Step] Downloading maps..."

    cd "$EQEMU_SERVER_DIR/maps"

    if [ -d ".git" ]; then
        echo "  Maps already downloaded, updating..."
        git pull
    else
        echo "  Cloning maps repository..."
        git clone https://github.com/peqarchive/peqmaps.git .
    fi

    echo "  Maps downloaded successfully"
}

#########################################################
# Download Database
#########################################################

download_database() {
    echo ""
    echo "[Step] Downloading PEQ database..."

    cd "$EQEMU_DB_DIR"

    echo "  Downloading database files..."
    wget -q --show-progress https://github.com/peqarchive/peqdatabase/archive/refs/heads/main.zip -O peqdatabase.zip

    echo "  Extracting database..."
    unzip -q peqdatabase.zip
    mv peqdatabase-main/* .
    rmdir peqdatabase-main
    rm peqdatabase.zip

    echo "  Database downloaded successfully"
}

#########################################################
# Import Database
#########################################################

import_database() {
    echo ""
    echo "[Step] Importing database..."

    cd "$EQEMU_DB_DIR"

    if [ -f "create_all_tables.sql" ]; then
        echo "  Importing database schema..."
        mysql -u"$EQEMU_DB_USER" -p"$EQEMU_DB_PASSWORD" "$EQEMU_DB_NAME" < create_all_tables.sql
        echo "  Database imported successfully"
    else
        echo "  Warning: create_all_tables.sql not found"
        echo "  You will need to import the database manually"
    fi

    # Add world server entry
    echo "  Adding world server entry..."
    mysql -u"$EQEMU_DB_USER" -p"$EQEMU_DB_PASSWORD" "$EQEMU_DB_NAME" <<EOF
INSERT INTO login_world_servers (id, long_name, short_name, tag_description, login_server_list_type_id, last_login_date, last_ip_address, login_server_admin_id, is_server_trusted, note)
VALUES (1, '$SERVER_LONG_NAME', '$SERVER_SHORT_NAME', '', 3, now(), '127.0.0.1', 0, 0, NULL)
ON DUPLICATE KEY UPDATE long_name='$SERVER_LONG_NAME', short_name='$SERVER_SHORT_NAME';
EOF
}

#########################################################
# Update Configuration Files
#########################################################

update_config_files() {
    echo ""
    echo "[Step] Updating configuration files..."

    # Update eqemu_config.json
    local config_file="$EQEMU_SERVER_DIR/eqemu_config.json"
    if [ -f "$config_file" ]; then
        # Create a backup
        cp "$config_file" "$config_file.bak"

        # Use sed to update the configuration
        sed -i "s/\"db\": \".*\"/\"db\": \"$EQEMU_DB_NAME\"/" "$config_file"
        sed -i "s/\"username\": \".*\"/\"username\": \"$EQEMU_DB_USER\"/" "$config_file"
        sed -i "s/\"password\": \".*\"/\"password\": \"$EQEMU_DB_PASSWORD\"/" "$config_file"
        sed -i "s/\"longname\": \".*\"/\"longname\": \"$SERVER_LONG_NAME\"/" "$config_file"
        sed -i "s/\"shortname\": \".*\"/\"shortname\": \"$SERVER_SHORT_NAME\"/" "$config_file"

        echo "  Updated eqemu_config.json"
    fi

    # Update login.json
    local login_file="$EQEMU_SERVER_DIR/login.json"
    if [ -f "$login_file" ]; then
        # Create a backup
        cp "$login_file" "$login_file.bak"

        # Use sed to update the configuration
        sed -i "s/\"db\": \".*\"/\"db\": \"$EQEMU_DB_NAME\"/" "$login_file"
        sed -i "s/\"user\": \".*\"/\"user\": \"$EQEMU_DB_USER\"/" "$login_file"
        sed -i "s/\"password\": \".*\"/\"password\": \"$EQEMU_DB_PASSWORD\"/" "$login_file"

        echo "  Updated login.json"
    fi

    # Fix line endings if needed
    if command -v dos2unix &> /dev/null; then
        find "$EQEMU_SERVER_DIR" -type f -name "*.sh" -exec dos2unix {} \; 2>/dev/null
        find "$EQEMU_SERVER_DIR" -type f -name "*.pl" -exec dos2unix {} \; 2>/dev/null
    fi

    # Set script permissions
    chmod 755 "$EQEMU_SERVER_DIR"/*.sh 2>/dev/null || true
    chmod 755 "$EQEMU_SERVER_DIR"/*.pl 2>/dev/null || true
}

#########################################################
# Set Ownership
#########################################################

set_ownership() {
    echo ""
    echo "[Step] Setting file ownership..."

    chown -R $EQEMU_USER:$EQEMU_USER "$EQEMU_INSTALL_DIR"
    echo "  Ownership set to $EQEMU_USER:$EQEMU_USER"
}

#########################################################
# Save Installation Variables
#########################################################

save_install_variables() {
    echo ""
    echo "[Step] Saving installation variables..."

    cat > "$EQEMU_INSTALL_DIR/install_variables.txt" <<EOF
MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD
EQEMU_DB_NAME=$EQEMU_DB_NAME
EQEMU_DB_USER=$EQEMU_DB_USER
EQEMU_DB_PASSWORD=$EQEMU_DB_PASSWORD
SERVER_LONG_NAME=$SERVER_LONG_NAME
SERVER_SHORT_NAME=$SERVER_SHORT_NAME
INSTALL_DATE=$(date)
EOF

    chmod 600 "$EQEMU_INSTALL_DIR/install_variables.txt"
    chown $EQEMU_USER:$EQEMU_USER "$EQEMU_INSTALL_DIR/install_variables.txt"

    echo "  Installation variables saved"
}

#########################################################
# Main Installation Process
#########################################################

main() {
    echo ""
    echo "==========================================================="
    echo "Beginning EQEmu Server Installation"
    echo "==========================================================="
    echo ""

    detect_os
    collect_user_input
    create_eqemu_user

    # Install prerequisites based on OS
    case "$OS" in
        "Debian")
            install_debian_prereqs
            ;;
        "red_hat")
            install_redhat_prereqs
            ;;
        "fedora_core")
            install_fedora_prereqs
            ;;
    esac

    configure_mariadb
    create_directories
    copy_server_files
    download_server_binaries
    create_symlinks
    download_maps
    download_database
    import_database
    update_config_files
    set_ownership
    save_install_variables

    echo ""
    echo "==========================================================="
    echo "Installation completed successfully!"
    echo "==========================================================="
    echo ""
    echo "Installation Summary:"
    echo "  Installation Directory: $EQEMU_INSTALL_DIR"
    echo "  Server Directory: $EQEMU_SERVER_DIR"
    echo "  Database Name: $EQEMU_DB_NAME"
    echo "  Database User: $EQEMU_DB_USER"
    echo ""
    echo "Next steps:"
    echo "  1. Review the configuration files in $EQEMU_SERVER_DIR"
    echo "  2. Start the server: cd $EQEMU_SERVER_DIR && ./start.sh"
    echo "  3. Check server status: ./status.sh"
    echo "  4. Stop the server: ./stop.sh"
    echo ""
    echo "For more information, see the README.md file"
    echo ""
}

# Run main installation
main
