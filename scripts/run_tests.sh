#!/bin/bash

# Test Runner Script for Listen Portfolio Flutter
# Provides comprehensive testing with coverage analysis

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to show help
show_help() {
    echo "Flutter Test Runner - Listen Portfolio Flutter"
    echo ""
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -u, --unit          Run unit tests only"
    echo "  -w, --widget        Run widget tests only"
    echo "  -i, --integration   Run integration tests only"
    echo "  -c, --coverage      Generate coverage report"
    echo "  -f, --file FILE     Run specific test file"
    echo "  -v, --verbose       Verbose output"
    echo "  -h, --help          Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0                  Run all tests"
    echo "  $0 -u -c            Run unit tests with coverage"
    echo "  $0 -f test/features/auth/login/  Run auth login tests"
    echo "  $0 --verbose        Run with detailed output"
}

# Default values
RUN_UNIT=false
RUN_WIDGET=false
RUN_INTEGRATION=false
GENERATE_COVERAGE=false
SPECIFIC_FILE=""
VERBOSE=false

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -u|--unit)
            RUN_UNIT=true
            shift
            ;;
        -w|--widget)
            RUN_WIDGET=true
            shift
            ;;
        -i|--integration)
            RUN_INTEGRATION=true
            shift
            ;;
        -c|--coverage)
            GENERATE_COVERAGE=true
            shift
            ;;
        -f|--file)
            SPECIFIC_FILE="$2"
            shift 2
            ;;
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        *)
            print_error "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
done

# If no specific test type selected, run all
if [[ "$RUN_UNIT" == false && "$RUN_WIDGET" == false && "$RUN_INTEGRATION" == false && "$SPECIFIC_FILE" == "" ]]; then
    RUN_UNIT=true
    RUN_WIDGET=true
    RUN_INTEGRATION=true
fi

# Function to run tests
run_tests() {
    local test_type="$1"
    local test_path="$2"
    local coverage_flag="$3"
    
    print_status "Running $test_type tests..."
    
    local cmd="flutter test"
    
    if [[ "$VERBOSE" == true ]]; then
        cmd="$cmd --reporter=expanded"
    else
        cmd="$cmd --reporter=compact"
    fi
    
    if [[ "$coverage_flag" == true ]]; then
        cmd="$cmd --coverage"
    fi
    
    if [[ "$SPECIFIC_FILE" != "" ]]; then
        cmd="$cmd $SPECIFIC_FILE"
    elif [[ "$test_path" != "" ]]; then
        cmd="$cmd $test_path"
    fi
    
    print_status "Executing: $cmd"
    
    if eval "$cmd"; then
        print_success "$test_type tests passed!"
    else
        print_error "$test_type tests failed!"
        exit 1
    fi
}

# Function to generate coverage report
generate_coverage_report() {
    if [[ ! -f "coverage/lcov.info" ]]; then
        print_warning "No coverage data found. Run tests with --coverage flag."
        return
    fi
    
    print_status "Generating coverage report..."
    
    # Check if lcov is available
    if ! command -v lcov &> /dev/null; then
        print_warning "lcov not found. Install lcov to generate HTML reports."
        print_status "On Ubuntu/Debian: sudo apt-get install lcov"
        print_status "On macOS: brew install lcov"
        return
    fi
    
    # Check if genhtml is available
    if ! command -v genhtml &> /dev/null; then
        print_warning "genhtml not found. Install lcov package to generate HTML reports."
        return
    fi
    
    # Generate HTML report
    genhtml coverage/lcov.info -o coverage/html --quiet --ignore-errors source
    
    if [[ -d "coverage/html" ]]; then
        print_success "Coverage report generated: coverage/html/index.html"
        
        # Show coverage summary
        if command -v lcov &> /dev/null; then
            print_status "Coverage Summary:"
            lcov --summary coverage/lcov.info
        fi
    else
        print_error "Failed to generate coverage report"
    fi
}

# Function to check test environment
check_environment() {
    print_status "Checking test environment..."
    
    # Check Flutter installation
    if ! command -v flutter &> /dev/null; then
        print_error "Flutter not found. Please install Flutter SDK."
        exit 1
    fi
    
    # Show Flutter version
    print_status "Flutter version: $(flutter --version | head -n 1)"
    
    # Check if we're in the right directory
    if [[ ! -f "pubspec.yaml" ]]; then
        print_error "pubspec.yaml not found. Please run from project root."
        exit 1
    fi
    
    # Get dependencies
    print_status "Getting dependencies..."
    flutter pub get
    
    # Ensure test assets directory exists
    mkdir -p assets/mock/v1/get
    mkdir -p assets/mock/v1/post
    
    print_success "Test environment ready!"
}

# Main execution
main() {
    print_status "Flutter Test Runner - Listen Portfolio Flutter"
    echo ""
    
    check_environment
    
    # Run tests based on flags
    if [[ "$SPECIFIC_FILE" != "" ]]; then
        run_tests "Specific File" "" "$GENERATE_COVERAGE"
    else
        if [[ "$RUN_UNIT" == true ]]; then
            run_tests "Unit" "test/core/ test/features/" "$GENERATE_COVERAGE"
        fi
        
        if [[ "$RUN_WIDGET" == true ]]; then
            run_tests "Widget" "test/features/home/projects/projects_widget_test.dart" false
        fi
        
        if [[ "$RUN_INTEGRATION" == true ]]; then
            if [[ -d "integration_test" ]]; then
                run_tests "Integration" "integration_test/" false
            else
                print_warning "No integration tests found, skipping..."
            fi
        fi
    fi
    
    # Generate coverage report if requested
    if [[ "$GENERATE_COVERAGE" == true ]]; then
        generate_coverage_report
    fi
    
    print_success "All tests completed successfully! 🎉"
}

# Run main function
main "$@"
