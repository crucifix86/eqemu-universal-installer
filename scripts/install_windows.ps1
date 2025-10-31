#########################################################
# EverQuest Emulator Windows Installer
# PowerShell Installation Script
#########################################################

param(
    [string]$InstallPath = "C:\EQEmu",
    [switch]$SkipPrereqs = $false
)

# Enable strict mode
$ErrorActionPreference = "Stop"

Write-Host "##########################################################" -ForegroundColor Cyan
Write-Host "#  EverQuest Emulator Windows Installer                 #" -ForegroundColor Cyan
Write-Host "##########################################################" -ForegroundColor Cyan
Write-Host ""

# Check for administrator privileges
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "ERROR: This script must be run as Administrator" -ForegroundColor Red
    Write-Host "Please right-click PowerShell and select 'Run as Administrator'" -ForegroundColor Red
    exit 1
}

Write-Host "Installation will proceed with the following settings:" -ForegroundColor Yellow
Write-Host "  Installation Path: $InstallPath" -ForegroundColor Yellow
Write-Host ""

# Prompt for confirmation
$confirm = Read-Host "Do you want to continue? (y/n)"
if ($confirm -ne "y" -and $confirm -ne "Y") {
    Write-Host "Installation cancelled by user" -ForegroundColor Yellow
    exit 0
}

#########################################################
# Function: Test-CommandExists
#########################################################
function Test-CommandExists {
    param($command)
    $null = Get-Command $command -ErrorAction SilentlyContinue
    return $?
}

#########################################################
# Function: Install-Chocolatey
#########################################################
function Install-Chocolatey {
    Write-Host "[Step] Installing Chocolatey package manager..." -ForegroundColor Green

    if (Test-CommandExists choco) {
        Write-Host "  Chocolatey is already installed" -ForegroundColor Gray
        return
    }

    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

    # Refresh environment variables
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

    Write-Host "  Chocolatey installed successfully" -ForegroundColor Gray
}

#########################################################
# Function: Install-Prerequisites
#########################################################
function Install-Prerequisites {
    Write-Host ""
    Write-Host "[Step] Installing prerequisites..." -ForegroundColor Green

    # Install required packages via Chocolatey
    $packages = @(
        "git",
        "cmake",
        "perl",
        "mariadb",
        "vcredist-all",
        "wget"
    )

    foreach ($package in $packages) {
        Write-Host "  Installing $package..." -ForegroundColor Gray
        choco install $package -y --force
    }

    Write-Host "  Prerequisites installed successfully" -ForegroundColor Gray
}

#########################################################
# Function: Configure-Database
#########################################################
function Configure-Database {
    param(
        [string]$DbName,
        [string]$DbUser,
        [string]$DbPassword,
        [string]$DbRootPassword
    )

    Write-Host ""
    Write-Host "[Step] Configuring MariaDB database..." -ForegroundColor Green

    # Start MariaDB service
    Write-Host "  Starting MariaDB service..." -ForegroundColor Gray
    Start-Service -Name "MariaDB" -ErrorAction SilentlyContinue
    Set-Service -Name "MariaDB" -StartupType Automatic -ErrorAction SilentlyContinue

    # Wait for service to start
    Start-Sleep -Seconds 5

    # Set root password and create database user
    Write-Host "  Creating database and user..." -ForegroundColor Gray

    $mysqlCmd = "C:\Program Files\MariaDB *\bin\mysql.exe"
    $mysqlPath = (Get-ChildItem $mysqlCmd | Select-Object -First 1).FullName

    if (-not $mysqlPath) {
        Write-Host "  Warning: Could not find MySQL/MariaDB executable" -ForegroundColor Yellow
        Write-Host "  You will need to configure the database manually" -ForegroundColor Yellow
        return
    }

    # Create SQL commands
    $sqlCommands = @"
CREATE DATABASE IF NOT EXISTS ``$DbName``;
CREATE USER IF NOT EXISTS '$DbUser'@'localhost' IDENTIFIED BY '$DbPassword';
GRANT ALL PRIVILEGES ON *.* TO '$DbUser'@'localhost' WITH GRANT OPTION;
FLUSH PRIVILEGES;
"@

    $sqlCommands | & $mysqlPath -u root

    Write-Host "  Database configured successfully" -ForegroundColor Gray
}

#########################################################
# Function: Setup-ServerFiles
#########################################################
function Setup-ServerFiles {
    param([string]$InstallPath)

    Write-Host ""
    Write-Host "[Step] Setting up server files..." -ForegroundColor Green

    # Create installation directory
    if (-not (Test-Path $InstallPath)) {
        New-Item -ItemType Directory -Path $InstallPath -Force | Out-Null
        Write-Host "  Created directory: $InstallPath" -ForegroundColor Gray
    }

    # Create subdirectories
    $directories = @(
        "$InstallPath\server",
        "$InstallPath\bin",
        "$InstallPath\database",
        "$InstallPath\logs"
    )

    foreach ($dir in $directories) {
        if (-not (Test-Path $dir)) {
            New-Item -ItemType Directory -Path $dir -Force | Out-Null
            Write-Host "  Created directory: $dir" -ForegroundColor Gray
        }
    }

    # Download install files from GitHub
    $tempDir = "$env:TEMP\eqemu_installer_$([System.Guid]::NewGuid())"

    try {
        Write-Host "  Downloading server files from GitHub..." -ForegroundColor Gray

        # Clone the repository
        $cloneResult = & git clone --depth 1 https://github.com/crucifix86/eqemu-universal-installer.git $tempDir 2>&1

        if ($LASTEXITCODE -eq 0) {
            Write-Host "  Repository cloned successfully" -ForegroundColor Gray

            # Copy the install directory
            $sourceInstallDir = Join-Path $tempDir "install"
            if (Test-Path $sourceInstallDir) {
                Write-Host "  Copying server files..." -ForegroundColor Gray
                Copy-Item -Path "$sourceInstallDir\*" -Destination "$InstallPath\server" -Recurse -Force
                Write-Host "  Server files copied successfully" -ForegroundColor Gray
            } else {
                Write-Host "  Error: Install directory not found in repository" -ForegroundColor Red
            }
        } else {
            Write-Host "  Error: Failed to clone repository" -ForegroundColor Red
            Write-Host "  Please check your internet connection and try again" -ForegroundColor Yellow
        }
    } catch {
        Write-Host "  Error downloading server files: $_" -ForegroundColor Red
        Write-Host "  You will need to download them manually" -ForegroundColor Yellow
    } finally {
        # Clean up
        if (Test-Path $tempDir) {
            Remove-Item -Path $tempDir -Recurse -Force -ErrorAction SilentlyContinue
        }
    }
}

#########################################################
# Function: Download-ServerBinaries
#########################################################
function Download-ServerBinaries {
    param([string]$InstallPath)

    Write-Host ""
    Write-Host "[Step] Downloading server binaries..." -ForegroundColor Green

    $binPath = "$InstallPath\bin"
    $downloadUrl = "https://github.com/EQEmu/Server/releases/download/v23.10.3/eqemu-server-windows-x64.zip"
    $zipFile = "$binPath\eqemu-server-windows-x64.zip"

    try {
        Write-Host "  Downloading from $downloadUrl..." -ForegroundColor Gray
        Invoke-WebRequest -Uri $downloadUrl -OutFile $zipFile

        Write-Host "  Extracting binaries..." -ForegroundColor Gray
        Expand-Archive -Path $zipFile -DestinationPath $binPath -Force
        Remove-Item $zipFile

        Write-Host "  Server binaries downloaded successfully" -ForegroundColor Gray
    } catch {
        Write-Host "  Error downloading server binaries: $_" -ForegroundColor Red
        Write-Host "  You will need to download them manually" -ForegroundColor Yellow
    }
}

#########################################################
# Function: Download-Maps
#########################################################
function Download-Maps {
    param([string]$InstallPath)

    Write-Host ""
    Write-Host "[Step] Downloading maps..." -ForegroundColor Green

    $mapsPath = "$InstallPath\server\maps"

    if (-not (Test-Path $mapsPath)) {
        New-Item -ItemType Directory -Path $mapsPath -Force | Out-Null
    }

    try {
        Write-Host "  Cloning maps repository..." -ForegroundColor Gray
        Push-Location $mapsPath
        git clone https://github.com/peqarchive/peqmaps.git . 2>&1 | Out-Null
        Pop-Location
        Write-Host "  Maps downloaded successfully" -ForegroundColor Gray
    } catch {
        Write-Host "  Error downloading maps: $_" -ForegroundColor Red
        Write-Host "  You will need to download them manually" -ForegroundColor Yellow
    }
}

#########################################################
# Function: Download-Database
#########################################################
function Download-Database {
    param([string]$InstallPath)

    Write-Host ""
    Write-Host "[Step] Downloading PEQ database..." -ForegroundColor Green

    $dbPath = "$InstallPath\database"
    $downloadUrl = "https://github.com/peqarchive/peqdatabase/archive/refs/heads/main.zip"
    $zipFile = "$dbPath\peqdatabase.zip"

    try {
        Write-Host "  Downloading database..." -ForegroundColor Gray
        Invoke-WebRequest -Uri $downloadUrl -OutFile $zipFile

        Write-Host "  Extracting database..." -ForegroundColor Gray
        Expand-Archive -Path $zipFile -DestinationPath $dbPath -Force
        Remove-Item $zipFile

        Write-Host "  Database downloaded successfully" -ForegroundColor Gray
    } catch {
        Write-Host "  Error downloading database: $_" -ForegroundColor Red
        Write-Host "  You will need to download it manually" -ForegroundColor Yellow
    }
}

#########################################################
# Function: Update-ConfigFiles
#########################################################
function Update-ConfigFiles {
    param(
        [string]$InstallPath,
        [string]$DbName,
        [string]$DbUser,
        [string]$DbPassword,
        [string]$ServerLongName,
        [string]$ServerShortName
    )

    Write-Host ""
    Write-Host "[Step] Updating configuration files..." -ForegroundColor Green

    # Update eqemu_config.json
    $configFile = "$InstallPath\server\eqemu_config.json"
    if (Test-Path $configFile) {
        $config = Get-Content $configFile -Raw | ConvertFrom-Json
        $config.server.database.db = $DbName
        $config.server.database.username = $DbUser
        $config.server.database.password = $DbPassword
        $config.server.qsdatabase.db = $DbName
        $config.server.qsdatabase.username = $DbUser
        $config.server.qsdatabase.password = $DbPassword
        $config.server.world.longname = $ServerLongName
        $config.server.world.shortname = $ServerShortName

        $config | ConvertTo-Json -Depth 10 | Set-Content $configFile
        Write-Host "  Updated eqemu_config.json" -ForegroundColor Gray
    }

    # Update login.json
    $loginFile = "$InstallPath\server\login.json"
    if (Test-Path $loginFile) {
        $login = Get-Content $loginFile -Raw | ConvertFrom-Json
        $login.database.db = $DbName
        $login.database.user = $DbUser
        $login.database.password = $DbPassword

        $login | ConvertTo-Json -Depth 10 | Set-Content $loginFile
        Write-Host "  Updated login.json" -ForegroundColor Gray
    }
}

#########################################################
# Main Installation Process
#########################################################

try {
    Write-Host ""
    Write-Host "===========================================================" -ForegroundColor Cyan
    Write-Host "Beginning installation..." -ForegroundColor Cyan
    Write-Host "===========================================================" -ForegroundColor Cyan

    # Collect configuration information
    Write-Host ""
    Write-Host "Please provide the following information:" -ForegroundColor Yellow
    Write-Host ""

    $dbName = Read-Host "Database name (e.g., peqdb)"
    $dbUser = Read-Host "Database username (e.g., eqemu)"
    $dbPassword = Read-Host "Database password" -AsSecureString
    $dbPasswordPlain = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($dbPassword))
    $dbRootPassword = Read-Host "Database root password (leave empty if not set)" -AsSecureString
    $dbRootPasswordPlain = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($dbRootPassword))
    $serverLongName = Read-Host "Server long name (e.g., My EQEmu Server)"
    $serverShortName = Read-Host "Server short name (e.g., myserver)"

    # Install prerequisites
    if (-not $SkipPrereqs) {
        Install-Chocolatey
        Install-Prerequisites
    }

    # Configure database
    Configure-Database -DbName $dbName -DbUser $dbUser -DbPassword $dbPasswordPlain -DbRootPassword $dbRootPasswordPlain

    # Setup server files
    Setup-ServerFiles -InstallPath $InstallPath

    # Download server binaries
    Download-ServerBinaries -InstallPath $InstallPath

    # Download maps
    Download-Maps -InstallPath $InstallPath

    # Download database
    Download-Database -InstallPath $InstallPath

    # Update configuration files
    Update-ConfigFiles -InstallPath $InstallPath -DbName $dbName -DbUser $dbUser -DbPassword $dbPasswordPlain -ServerLongName $serverLongName -ServerShortName $serverShortName

    Write-Host ""
    Write-Host "===========================================================" -ForegroundColor Green
    Write-Host "Installation completed successfully!" -ForegroundColor Green
    Write-Host "===========================================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "Installation directory: $InstallPath" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Next steps:" -ForegroundColor Yellow
    Write-Host "1. Import the database by running the SQL files in $InstallPath\database" -ForegroundColor Yellow
    Write-Host "2. Copy the server binaries from $InstallPath\bin to $InstallPath\server" -ForegroundColor Yellow
    Write-Host "3. Start the server using the start scripts in $InstallPath\server" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Please see README.md for detailed instructions" -ForegroundColor Yellow

} catch {
    Write-Host ""
    Write-Host "===========================================================" -ForegroundColor Red
    Write-Host "Installation failed with error:" -ForegroundColor Red
    Write-Host "===========================================================" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    Write-Host ""
    Write-Host "Please check the error message above and try again" -ForegroundColor Yellow
    exit 1
}
