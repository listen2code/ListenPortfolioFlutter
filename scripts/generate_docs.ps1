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

# Create navigation index
Write-Info "Creating navigation index..."

$IndexContent = @"
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Listen Portfolio Flutter - Documentation</title>
    <style>
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            line-height: 1.6;
            color: #333;
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
            background-color: #f8f9fa;
        }
        .header {
            text-align: center;
            margin-bottom: 40px;
            padding: 40px 20px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        .header h1 {
            margin: 0;
            font-size: 2.5em;
            font-weight: 300;
        }
        .header p {
            margin: 10px 0 0 0;
            opacity: 0.9;
            font-size: 1.2em;
        }
        .package-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
            gap: 30px;
            margin-bottom: 40px;
        }
        .package-card {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        .package-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
        }
        .package-card h3 {
            margin: 0 0 15px 0;
            color: #2c3e50;
            font-size: 1.5em;
        }
        .package-card p {
            margin: 0 0 20px 0;
            color: #666;
            flex-grow: 1;
        }
        .package-card a {
            display: inline-block;
            background: #3498db;
            color: white;
            padding: 12px 24px;
            text-decoration: none;
            border-radius: 5px;
            font-weight: 500;
            transition: background 0.3s ease;
        }
        .package-card a:hover {
            background: #2980b9;
        }
        .package-card.success {
            border-left: 4px solid #27ae60;
        }
        .package-card.warning {
            border-left: 4px solid #f39c12;
            opacity: 0.8;
        }
        .package-card.error {
            border-left: 4px solid #e74c3c;
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
        <p>API Documentation for Flutter Application</p>
    </div>
    
    <div class="package-grid">
        <div class="package-card success">
            <span class="status-badge status-success">Available</span>
            <h3>Main Application</h3>
            <p>Complete API documentation for the Listen Portfolio Flutter application, including all features and components.</p>
            <a href="listen_portfolio_flutter/">View Documentation</a>
        </div>
    </div>
    
    <div class="footer">
        <p>Generated by <a href="https://dart.dev/tools/dart-doc">dartdoc</a> | 
        <a href="https://github.com/listen2code/ListenPortfolioFlutter">GitHub Repository</a></p>
    </div>
</body>
</html>
"@

$IndexContent | Out-File -FilePath (Join-Path $GhPagesDir "index.html") -Encoding UTF8

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
