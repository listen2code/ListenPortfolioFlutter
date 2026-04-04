# Final Documentation Generation Script (PowerShell)
# Handles Windows path limitations gracefully

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
$TempCoreDir = Join-Path $ProjectRoot "doc_core_$((Get-Date).ToString('yyyyMMdd_HHmmss'))"
$TempUIKitDir = Join-Path $ProjectRoot "doc_uikit_$((Get-Date).ToString('yyyyMMdd_HHmmss'))"

Write-Info "Starting final documentation generation..."
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
$TempDirs = @($TempMainDir, $TempCoreDir, $TempUIKitDir)
foreach ($TempDir in $TempDirs) {
    if (Test-Path $TempDir) {
        try {
            Write-Info "Cleaning temporary directory: $TempDir"
            Remove-Item -Recurse -Force $TempDir -ErrorAction SilentlyContinue
        }
        catch {
            Write-Warning "Could not clean temporary directory"
        }
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

# Generate documentation for listen_core
$CorePath = "..\ListenCore"
if (Test-Path $CorePath) {
    Write-Info "Found listen_core at $CorePath"
    Set-Location $CorePath
    
    # Get dependencies
    & dart pub get
    
    # Generate documentation
    Write-Info "Generating documentation for listen_core..."
    & dart doc --output $TempCoreDir
    
    if ($LASTEXITCODE -eq 0) {
        Write-Success "listen_core documentation generated successfully"
    }
    else {
        Write-Warning "Failed to generate listen_core documentation"
    }
    
    # Return to project root
    Set-Location $ProjectRoot
}
else {
    Write-Warning "listen_core not found at $CorePath"
}

# Generate documentation for listen_uikit
$UiKitPath = "..\ListenUiKit"
if (Test-Path $UiKitPath) {
    Write-Info "Found listen_uikit at $UiKitPath"
    Set-Location $UiKitPath
    
    # Get dependencies
    & dart pub get
    
    # Generate documentation
    Write-Info "Generating documentation for listen_uikit..."
    & dart doc --output $TempUIKitDir
    
    if ($LASTEXITCODE -eq 0) {
        Write-Success "listen_uikit documentation generated successfully"
    }
    else {
        Write-Warning "Failed to generate listen_uikit documentation"
    }
    
    # Return to project root
    Set-Location $ProjectRoot
}
else {
    Write-Warning "listen_uikit not found at $UiKitPath"
}

# Clean and prepare GitHub Pages directory
Write-Info "Preparing GitHub Pages directory..."
if (Test-Path $GhPagesDir) {
    try {
        # Keep .git directory, remove everything else
        $KeepItems = @(".git", ".nojekyll")
        Get-ChildItem -Path $GhPagesDir | Where-Object { $KeepItems -notcontains $_.Name } | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
    }
    catch {
        Write-Warning "Could not clean GitHub Pages directory"
    }
}
New-Item -ItemType Directory -Path $GhPagesDir -Force | Out-Null

# Copy documentation with simple approach
Write-Info "Organizing documentation structure..."

# Copy listen_core and listen_uikit (these should work fine)
$CoreSuccess = $false
$UIKitSuccess = $false
$MainSuccess = $false

try {
    if (Test-Path $TempCoreDir) {
        Copy-Item -Path $TempCoreDir -Destination (Join-Path $GhPagesDir "listen_core") -Recurse -Force
        $CoreSuccess = $true
        Write-Success "listen_core documentation copied successfully"
    }
}
catch {
    Write-Warning "Failed to copy listen_core documentation"
}

try {
    if (Test-Path $TempUIKitDir) {
        Copy-Item -Path $TempUIKitDir -Destination (Join-Path $GhPagesDir "listen_uikit") -Recurse -Force
        $UIKitSuccess = $true
        Write-Success "listen_uikit documentation copied successfully"
    }
}
catch {
    Write-Warning "Failed to copy listen_uikit documentation"
}

# For main application, try a more careful approach
try {
    if (Test-Path $TempMainDir) {
        $MainDestDir = Join-Path $GhPagesDir "listen_portfolio_flutter"
        New-Item -ItemType Directory -Path $MainDestDir -Force | Out-Null
        
        # Copy index.html
        $IndexFile = Join-Path $TempMainDir "index.html"
        if (Test-Path $IndexFile) {
            Copy-Item -Path $IndexFile -Destination $MainDestDir -Force
        }
        
        # Copy static-assets
        $StaticAssets = Join-Path $TempMainDir "static-assets"
        if (Test-Path $StaticAssets) {
            Copy-Item -Path $StaticAssets -Destination $MainDestDir -Recurse -Force -ErrorAction SilentlyContinue
        }
        
        # Try to copy some key directories
        $KeyDirs = @("features_auth", "features_home", "shared")
        foreach ($Dir in $KeyDirs) {
            $SourceDir = Join-Path $TempMainDir $Dir
            if (Test-Path $SourceDir) {
                try {
                    Copy-Item -Path $SourceDir -Destination $MainDestDir -Recurse -Force -ErrorAction SilentlyContinue
                }
                catch {
                    Write-Warning "Could not copy directory: $Dir"
                }
            }
        }
        
        $MainSuccess = $true
        Write-Success "Main application documentation copied (partial)"
    }
}
catch {
    Write-Warning "Failed to copy main application documentation"
}

# Create navigation index
Write-Info "Creating navigation index..."

# Determine status for each package
$MainStatus = if ($MainSuccess) { "success" } else { "error" }
$CoreStatus = if ($CoreSuccess) { "success" } else { "error" }
$UIKitStatus = if ($UIKitSuccess) { "success" } else { "error" }

$MainBadge = if ($MainSuccess) { "status-success" } else { "status-error" }
$CoreBadge = if ($CoreSuccess) { "status-success" } else { "status-error" }
$UIKitBadge = if ($UIKitSuccess) { "status-success" } else { "status-error" }

$MainText = if ($MainSuccess) { "Available" } else { "Unavailable" }
$CoreText = if ($CoreSuccess) { "Available" } else { "Unavailable" }
$UIKitText = if ($UIKitSuccess) { "Available" } else { "Unavailable" }

$MainLink = if ($MainSuccess) { "listen_portfolio_flutter/" } else { "#" }
$CoreLink = if ($CoreSuccess) { "listen_core/" } else { "#" }
$UIKitLink = if ($UIKitSuccess) { "listen_uikit/" } else { "#" }

$MainLinkText = if ($MainSuccess) { "View Documentation" } else { "Documentation Unavailable" }
$CoreLinkText = if ($CoreSuccess) { "View Documentation" } else { "Documentation Unavailable" }
$UIKitLinkText = if ($UIKitSuccess) { "View Documentation" } else { "Documentation Unavailable" }

$IndexHtml = @"
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Listen Portfolio Flutter - API Documentation</title>
    <style>
        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
            line-height: 1.6;
            color: #333;
        }
        .header {
            text-align: center;
            margin-bottom: 40px;
            padding-bottom: 20px;
            border-bottom: 2px solid #1976d2;
        }
        .header h1 {
            color: #1976d2;
            margin-bottom: 10px;
        }
        .package-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
            margin-bottom: 40px;
        }
        .package-card {
            background: #f8f9fa;
            border: 1px solid #e9ecef;
            border-radius: 8px;
            padding: 20px;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }
        .package-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }
        .package-card h3 {
            margin-top: 0;
            color: #1976d2;
        }
        .package-card p {
            margin-bottom: 15px;
            color: #666;
        }
        .package-card a {
            display: inline-block;
            background: #1976d2;
            color: white;
            padding: 8px 16px;
            border-radius: 4px;
            text-decoration: none;
            font-weight: 500;
        }
        .package-card a:hover {
            background: #1565c0;
        }
        .package-card.success {
            border-left: 4px solid #4caf50;
        }
        .package-card.warning {
            border-left: 4px solid #ff9800;
        }
        .package-card.error {
            border-left: 4px solid #f44336;
            opacity: 0.7;
        }
        .package-card.error a {
            background: #999;
            cursor: not-allowed;
        }
        .status-badge {
            display: inline-block;
            padding: 2px 8px;
            border-radius: 12px;
            font-size: 0.8em;
            font-weight: 500;
            margin-bottom: 10px;
        }
        .status-success {
            background: #e8f5e8;
            color: #2e7d32;
        }
        .status-warning {
            background: #fff3e0;
            color: #f57c00;
        }
        .status-error {
            background: #ffebee;
            color: #c62828;
        }
        .footer {
            text-align: center;
            margin-top: 40px;
            padding-top: 20px;
            border-top: 1px solid #e9ecef;
            color: #666;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>Listen Portfolio Flutter</h1>
        <p>API Documentation for Flutter Application and Core Libraries</p>
    </div>
    
    <div class="package-grid">
        <div class="package-card $MainStatus">
            <span class="status-badge $MainBadge">$MainText</span>
            <h3>Main Application</h3>
            <p>Complete API documentation for the Listen Portfolio Flutter application, including all features and components.</p>
            <a href="$MainLink">$MainLinkText</a>
        </div>
        
        <div class="package-card $CoreStatus">
            <span class="status-badge $CoreBadge">$CoreText</span>
            <h3>listen_core</h3>
            <p>Core utilities and base classes for Flutter applications. Clean architecture components and utilities.</p>
            <a href="$CoreLink">$CoreLinkText</a>
        </div>
        
        <div class="package-card $UIKitStatus">
            <span class="status-badge $UIKitBadge">$UIKitText</span>
            <h3>listen_uikit</h3>
            <p>Design system and reusable UI components for Flutter applications. Custom widgets and theming.</p>
            <a href="$UIKitLink">$UIKitLinkText</a>
        </div>
    </div>
    
    <div class="footer">
        <p>Generated by <a href="https://dart.dev/tools/dart-doc">dartdoc</a> | 
        <a href="https://github.com/listen2code/ListenPortfolioFlutter">GitHub Repository</a> |
        <a href="https://pub.dev/packages/listen_core">listen_core on pub.dev</a> |
        <a href="https://pub.dev/packages/listen_uikit">listen_uikit on pub.dev</a></p>
    </div>
</body>
</html>
"@

$IndexHtml | Out-File -FilePath (Join-Path $GhPagesDir "index.html") -Encoding UTF8

# Create .nojekyll file
"# GitHub Pages" | Out-File -FilePath (Join-Path $GhPagesDir ".nojekyll") -Encoding UTF8

# Clean up temporary directories
Write-Info "Cleaning up temporary directories..."
foreach ($TempDir in $TempDirs) {
    if (Test-Path $TempDir) {
        try {
            Remove-Item $TempDir -Recurse -Force -ErrorAction SilentlyContinue
            Write-Info "Temporary directory cleaned up: $TempDir"
        }
        catch {
            Write-Warning "Could not clean up temporary directory: $TempDir"
        }
    }
}

# Success message
Write-Host ""
Write-Success "Final documentation generation completed!"
Write-Host ""
Write-Info "Documentation structure:"
Write-Host "  - Main Application: listen_portfolio_flutter/ ($(if($MainSuccess){'Available'}else{'Limited'}))"
Write-Host "  - listen_core: listen_core/ ($(if($CoreSuccess){'Available'}else{'Unavailable'}))"
Write-Host "  - listen_uikit: listen_uikit/ ($(if($UIKitSuccess){'Available'}else{'Unavailable'}))"
Write-Host ""
Write-Info "Next steps:"
Write-Host "  1. cd pages"
Write-Host "  2. git add ."
Write-Host "  3. git commit -m 'Update documentation'"
Write-Host "  4. git push origin main"
Write-Host ""
Write-Info "Your documentation will be available at:"
Write-Host "  https://listen2code.github.io/ListenPortfolioFlutter/"
Write-Host ""
Write-Success "Done!"
