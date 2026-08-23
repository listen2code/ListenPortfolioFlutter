# Documentation Generation Script (PowerShell) - Main Project Only
# Generates documentation for the current project only

param(
    [switch]$Force,
    [switch]$Verbose
)

# Error handling
$ErrorActionPreference = "Stop"

# Colors for output
$Colors = @{
    Red = "Red"
    Green = "Green" 
    Yellow = "Yellow"
    Blue = "Blue"
    White = "White"
}

function Write-ColorOutput {
    param(
        [string]$Message,
        [string]$Color = "White"
    )
    Write-Host $Message -ForegroundColor $Colors[$Color]
}

function Write-Success {
    param([string]$Message)
    Write-ColorOutput "[SUCCESS] $Message" "Green"
}

function Write-Warning {
    param([string]$Message)
    Write-ColorOutput "[WARNING] $Message" "Yellow"
}

function Write-Error {
    param([string]$Message)
    Write-ColorOutput "[ERROR] $Message" "Red"
}

function Write-Info {
    param([string]$Message)
    Write-ColorOutput "[INFO] $Message" "Blue"
}

# Project root directory
$ProjectRoot = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$GhPagesDir = Join-Path $ProjectRoot "pages"
$TempMainDir = Join-Path $ProjectRoot "doc_main_$((Get-Date).ToString('yyyyMMdd_HHmmss'))"

Write-Info "Starting documentation generation for main project..."
Write-Info "Project root: $ProjectRoot"
Write-Info "Output directory: $GhPagesDir"

# Check if dart is installed
try {
    $DartVersion = & dart --version 2>$null
    Write-Success "Dart found: $DartVersion"
}
catch {
    Write-Error "Dart is not installed or not in PATH"
    exit 1
}

# Navigate to project root
Set-Location $ProjectRoot

# Clean previous temporary directories
if (Test-Path $TempMainDir) {
    try {
        Write-Info "Cleaning temporary directory: $TempMainDir"
        Remove-Item -Recurse -Force $TempMainDir -ErrorAction SilentlyContinue
    }
    catch {
        Write-Warning "Could not clean temporary directory"
    }
}

# Get dependencies for main project
Write-Info "Getting dependencies for main project..."
& dart pub get

if ($LASTEXITCODE -ne 0) {
    Write-Error "Failed to get dependencies for main project"
    exit 1
}

Write-Success "Dependencies resolved"

# Generate documentation for main project
Write-Info "Generating documentation for main application..."
& dart doc --output $TempMainDir

if ($LASTEXITCODE -eq 0) {
    Write-Success "Main application documentation generated successfully"
}
else {
    Write-Error "Failed to generate main application documentation"
    exit 1
}

# Clean and prepare GitHub Pages directory
Write-Info "Preparing GitHub Pages directory..."

if (Test-Path $GhPagesDir) {
    try {
        # Remove existing main app docs but keep other packages
        $MainDestDir = Join-Path $GhPagesDir "listen_portfolio_flutter"
        if (Test-Path $MainDestDir) {
            Write-Info "Removing existing main application documentation"
            Remove-Item -Path $MainDestDir -Recurse -Force -ErrorAction SilentlyContinue
        }
    }
    catch {
        Write-Warning "Could not remove existing directory"
    }
}
else {
    # Create pages directory if it doesn't exist
    New-Item -ItemType Directory -Path $GhPagesDir -Force | Out-Null
}

# Copy documentation with robocopy for reliable copying
Write-Info "Organizing documentation structure..."

try {
    # Create destination directory
    $MainDestDir = Join-Path $GhPagesDir "listen_portfolio_flutter"
    New-Item -ItemType Directory -Path $MainDestDir -Force | Out-Null
    
    # Use robocopy for reliable copying with long paths
    robocopy $TempMainDir $MainDestDir /E /NFL /NDL /NJH /NJS | Out-Null
    
    if ($LASTEXITCODE -le 7) {
        $MainSuccess = $true
        Write-Success "Main application documentation copied successfully"
    }
    else {
        Write-Warning "Robocopy failed with exit code: $LASTEXITCODE"
        $MainSuccess = $false
    }
}
catch {
    Write-Warning "Failed to copy main application documentation"
    $MainSuccess = $false
}

# Verify navigation index
$TargetIndexHtml = Join-Path $GhPagesDir "index.html"
if (-not (Test-Path $TargetIndexHtml)) {
    Write-Info "Creating default navigation index..."
    $IndexContent = @"
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Listen Portfolio Flutter - Documentation Portal</title>
</head>
<body>
    <h1>Listen Portfolio Flutter</h1>
    <p><a href="listen_portfolio_flutter/">View Documentation</a></p>
    <p><a href="privacy_policy.html">Privacy Policy</a></p>
    <p><a href="terms_of_service.html">Terms of Service</a></p>
    <p><a href="delete_account.html">Delete Account</a></p>
</body>
</html>
"@
    $IndexContent | Out-File -FilePath $TargetIndexHtml -Encoding UTF8
} else {
    Write-Info "Preserving existing portal index.html with legal and documentation links."
}

# Clean up temporary directories
Write-Info "Cleaning up temporary directories..."
if (Test-Path $TempMainDir) {
    try {
        Remove-Item -Path $TempMainDir -Recurse -Force
        Write-Info "Temporary directory cleaned up: $TempMainDir"
    }
    catch {
        Write-Warning "Failed to clean up temporary directory"
    }
}

# Final summary
Write-Info ""
Write-Success "Final documentation generation completed!"

Write-Info ""
Write-Info "Documentation structure:"
if ($MainSuccess) {
    Write-Info "  - Main Application: listen_portfolio_flutter/ (Available)"
}
else {
    Write-Info "  - Main Application: listen_portfolio_flutter/ (Failed)"
}

Write-Info ""
Write-Info "Next steps:"
Write-Info "  1. cd pages"
Write-Info "  2. git add ."
Write-Info "  3. git commit -m 'Update documentation'"
Write-Info "  4. git push origin main"

Write-Info ""
Write-Info "Your documentation will be available at:"
Write-Info "  https://listen2code.github.io/ListenPortfolioFlutter/"

Write-Success "Done!"
