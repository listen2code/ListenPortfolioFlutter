# Test Runner Script for Listen Portfolio Flutter (PowerShell)
# Provides comprehensive testing with coverage analysis

param(
    [switch]$Unit,
    [switch]$Widget,
    [switch]$Integration,
    [switch]$Coverage,
    [string]$File,
    [switch]$Verbose,
    [switch]$Help
)

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

function Write-Status {
    param([string]$Message)
    Write-ColorOutput "[INFO] $Message" "Blue"
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

function Show-Help {
    Write-Host "Flutter Test Runner - Listen Portfolio Flutter"
    Write-Host ""
    Write-Host "Usage: .\run_tests.ps1 [OPTIONS]"
    Write-Host ""
    Write-Host "Options:"
    Write-Host "  -Unit              Run unit tests only"
    Write-Host "  -Widget            Run widget tests only"
    Write-Host "  -Integration       Run integration tests only"
    Write-Host "  -Coverage          Generate coverage report"
    Write-Host "  -File FILE         Run specific test file"
    Write-Host "  -Verbose           Verbose output"
    Write-Host "  -Help              Show this help message"
    Write-Host ""
    Write-Host "Examples:"
    Write-Host "  .\run_tests.ps1                   Run all tests"
    Write-Host "  .\run_tests.ps1 -Unit -Coverage   Run unit tests with coverage"
    Write-Host "  .\run_tests.ps1 -File 'test\features\auth\login\'  Run auth login tests"
    Write-Host "  .\run_tests.ps1 -Verbose          Run with detailed output"
}

function Test-Command {
    param([string]$Command)
    try {
        $null = Get-Command $Command -ErrorAction Stop
        return $true
    }
    catch {
        return $false
    }
}

function Invoke-Tests {
    param(
        [string]$TestType,
        [string]$TestPath,
        [switch]$Coverage
    )
    
    Write-Status "Running $TestType tests..."
    
    $cmd = "flutter test"
    
    if ($Verbose) {
        $cmd += " --reporter=expanded"
    }
    else {
        $cmd += " --reporter=compact"
    }
    
    if ($Coverage) {
        $cmd += " --coverage"
    }
    
    if ($File) {
        $cmd += " $File"
    }
    elseif ($TestPath) {
        $cmd += " $TestPath"
    }
    
    Write-Status "Executing: $cmd"
    
    try {
        Invoke-Expression $cmd
        if ($LASTEXITCODE -eq 0) {
            Write-Success "$TestType tests passed!"
        }
        else {
            Write-Error "$TestType tests failed!"
            exit 1
        }
    }
    catch {
        Write-Error "Failed to execute tests: $_"
        exit 1
    }
}

function New-CoverageReport {
    if (-not (Test-Path "coverage\lcov.info")) {
        Write-Warning "No coverage data found. Run tests with -Coverage flag."
        return
    }
    
    Write-Status "Generating coverage report..."
    
    # Check if lcov is available
    if (-not (Test-Command "lcov")) {
        Write-Warning "lcov not found. Install lcov to generate HTML reports."
        Write-Status "On Windows: Use WSL or Git Bash with lcov installed"
        return
    }
    
    # Check if genhtml is available
    if (-not (Test-Command "genhtml")) {
        Write-Warning "genhtml not found. Install lcov package to generate HTML reports."
        return
    }
    
    try {
        # Generate HTML report
        Invoke-Expression "genhtml coverage\lcov.info -o coverage\html --quiet --ignore-errors source"
        
        if (Test-Path "coverage\html") {
            Write-Success "Coverage report generated: coverage\html\index.html"
            
            # Show coverage summary
            Write-Status "Coverage Summary:"
            Invoke-Expression "lcov --summary coverage\lcov.info"
        }
        else {
            Write-Error "Failed to generate coverage report"
        }
    }
    catch {
        Write-Warning "Failed to generate coverage report: $_"
    }
}

function Test-Environment {
    Write-Status "Checking test environment..."
    
    # Check Flutter installation
    if (-not (Test-Command "flutter")) {
        Write-Error "Flutter not found. Please install Flutter SDK."
        exit 1
    }
    
    # Show Flutter version
    $flutterVersion = flutter --version | Select-Object -First 1
    Write-Status "Flutter version: $flutterVersion"
    
    # Check if we're in the right directory
    if (-not (Test-Path "pubspec.yaml")) {
        Write-Error "pubspec.yaml not found. Please run from project root."
        exit 1
    }
    
    # Get dependencies
    Write-Status "Getting dependencies..."
    flutter pub get
    
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Failed to get dependencies"
        exit 1
    }
    
    # Ensure test assets directory exists
    New-Item -ItemType Directory -Force -Path "assets\mock\v1\get" | Out-Null
    New-Item -ItemType Directory -Force -Path "assets\mock\v1\post" | Out-Null
    
    Write-Success "Test environment ready!"
}

# Main execution
function Main {
    Write-Status "Flutter Test Runner - Listen Portfolio Flutter"
    Write-Host ""
    
    if ($Help) {
        Show-Help
        return
    }
    
    Test-Environment
    
    # If no specific test type selected, run all
    if (-not $Unit -and -not $Widget -and -not $Integration -and -not $File) {
        $Unit = $true
        $Widget = $true
        $Integration = $true
    }
    
    # Run tests based on flags
    if ($File) {
        Invoke-Tests "Specific File" "" -Coverage:$Coverage
    }
    else {
        if ($Unit) {
            Invoke-Tests "Unit" "test\core\ test\features\" -Coverage:$Coverage
        }
        
        if ($Widget) {
            Invoke-Tests "Widget" "test\features\home\projects\projects_widget_test.dart"
        }
        
        if ($Integration) {
            if (Test-Path "integration_test") {
                Invoke-Tests "Integration" "integration_test\"
            }
            else {
                Write-Warning "No integration tests found, skipping..."
            }
        }
    }
    
    # Generate coverage report if requested
    if ($Coverage) {
        New-CoverageReport
    }
    
    Write-Success "All tests completed successfully! 🎉"
}

# Run main function
Main
