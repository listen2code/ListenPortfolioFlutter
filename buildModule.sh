#!/bin/bash
# ==============================================================================
# Unified Multi-Target Build & Deployment Automation Pipeline
# Listen Portfolio Flutter
#
# Supported Commands:
#   ./buildModule.sh apk dev       -> Builds debug/dev APK for testing
#   ./buildModule.sh bundle prod   -> Builds release Android App Bundle (AAB)
#   ./buildModule.sh patch prod    -> Generates & deploys Shorebird OTA Hotfix Patch
#   ./buildModule.sh web prod      -> Compiles production Flutter Web assets
#
# Pipeline Architecture:
#   Phase 1: Input Validation & Toolchain Discovery (Flutter, Shorebird)
#   Phase 2: Build Cache Clean & Dependency Resolution
#   Phase 3: Web Release Compilation
#   Phase 4: Shorebird OTA Hotfix Patch Deployment
#   Phase 5: Android AAB / APK Release Compilation (Obfuscation + Symbol Stripping)
#   Phase 6: Artifact Extraction & Standardized Output Staging
# ==============================================================================

# --- Phase 1: Input Validation & Toolchain Discovery ---
TARGET_TYPE=${1:-"apk"}     # First argument: apk, bundle, patch, or web
ENV=${2:-"dev"}             # Second argument: mock, dev, test, prod
USE_SHOREBIRD_ARG=$3

# Validate target artifact type
if [[ ! "$TARGET_TYPE" =~ ^(apk|bundle|patch|web)$ ]]; then
    echo ">>> Error: Invalid target type '$TARGET_TYPE'. Must be one of: apk, bundle, patch, web"
    exit 1
fi

# Validate target environment
if [[ ! "$ENV" =~ ^(mock|dev|test|prod)$ ]]; then
    echo ">>> Error: Invalid environment '$ENV'. Must be one of: mock, dev, test, prod"
    exit 1
fi

# Ensure Shorebird CLI binary is discoverable in PATH across all standard OS paths
if [ -d "$HOME/.shorebird/bin" ]; then
    export PATH="$HOME/.shorebird/bin:$PATH"
fi
if [ -n "$XDG_CONFIG_HOME" ] && [ -d "$XDG_CONFIG_HOME/shorebird/bin" ]; then
    export PATH="$XDG_CONFIG_HOME/shorebird/bin:$PATH"
fi
if [ -d "$HOME/.config/shorebird/bin" ]; then
    export PATH="$HOME/.config/shorebird/bin:$PATH"
fi

# Auto-detect Shorebird execution eligibility based on CLI args or CI secrets
if [ -n "$USE_SHOREBIRD_ARG" ]; then
    USE_SHOREBIRD="$USE_SHOREBIRD_ARG"
elif [ -n "$SHOREBIRD_TOKEN" ]; then
    USE_SHOREBIRD="true"
else
    USE_SHOREBIRD="false"
fi

# --- Phase 2: Build Cache Clean & Dependency Resolution ---
echo ">>> Cleaning cache"
rm -rf apkOutput
mkdir -p apkOutput
flutter clean

echo ">>> Fetching dependencies (flutter pub get)"
flutter pub get

echo ">>> Extracting version from pubspec.yaml"
APP_VERSION=$(grep '^version: ' pubspec.yaml | cut -d ' ' -f 2 | cut -d '+' -f 1)

# --- Phase 3: Web Release Compilation ---
# Builds production-optimized Web assets (HTML, CanvasKit/WASM, minified JS, assets).
#
# Key Compilation Flags:
# - `--release`: Triggers Dart2JS / dart2wasm full tree-shaking, symbol minification,
#   and dead-code elimination for minimal initial bundle size.
# - `--dart-define=APP_ENV=$ENV`: Injects compile-time environment identifier so that
#   [AppEnv] resolves to the target environment (e.g. 'prod' binding to same-origin /api).
# - `--dart-define=APP_VERSION=$APP_VERSION`: Embeds semantic version string from pubspec.yaml.
if [ "$TARGET_TYPE" == "web" ]; then
    echo ">>> Building Flutter Web Release for [$ENV] environment (Version: $APP_VERSION)..."
    flutter build web --release \
        --dart-define=APP_ENV=$ENV \
        --dart-define=APP_VERSION=$APP_VERSION
    if [ $? -eq 0 ]; then
        echo ">>> Web build completed successfully. Output directory: build/web"
        echo ">>> Note: Deploy output to Nginx root (e.g., /var/www/listen_portfolio_web)."
        exit 0
    else
        echo ">>> Error: Web build failed!"
        exit 1
    fi
fi

# --- Phase 4: Shorebird OTA Hotfix Patch Deployment (Android) ---
if [ "$TARGET_TYPE" == "patch" ]; then
    echo ">>> Executing Shorebird Patch Android for [$ENV] environment (Version: $APP_VERSION)..."
    if command -v shorebird &> /dev/null; then
        shorebird patch android --allow-asset-diffs \
            -- \
            --no-tree-shake-icons \
            --obfuscate --split-debug-info=apkOutput \
            --extra-gen-snapshot-options=--save-obfuscation-map=apkOutput/mapping.json,--strip \
            --dart-define=APP_ENV=$ENV \
            --dart-define=APP_VERSION=$APP_VERSION
        if [ $? -eq 0 ]; then
            echo ">>> Shorebird Patch Android deployed successfully for [$ENV]!"
            exit 0
        else
            echo ">>> Error: Shorebird Patch deployment failed with non-zero exit code!"
            exit 1
        fi
    else
        echo ">>> Error: 'shorebird' CLI command was not found in PATH. Cannot deploy patch."
        exit 1
    fi
fi

# --- Phase 5: Android AAB / APK Release Compilation ---
if [ "$TARGET_TYPE" == "bundle" ]; then
    echo ">>> Building App Bundle (.aab) for [$ENV] environment (Shorebird: $USE_SHOREBIRD)"
    build_cmd="appbundle"
    shorebird_artifact="aab"
    from="build/app/outputs/bundle/release"
    file_name="app-release.aab"
    output_ext="aab"
else
    echo ">>> Building APK (.apk) for [$ENV] environment (Shorebird: $USE_SHOREBIRD)"
    build_cmd="apk"
    shorebird_artifact="apk"
    from="build/app/outputs/flutter-apk"
    file_name="app-release.apk"
    output_ext="apk"
fi

echo ">>> Building $TARGET_TYPE [$ENV] version [$APP_VERSION] (Shorebird: $USE_SHOREBIRD)"

if [ "$USE_SHOREBIRD" == "true" ]; then
    if command -v shorebird &> /dev/null; then
        echo ">>> Executing Strict Shorebird Release Build..."
        shorebird release android --artifact=$shorebird_artifact \
            -- \
            --obfuscate --split-debug-info=apkOutput \
            --extra-gen-snapshot-options=--save-obfuscation-map=apkOutput/mapping.json,--strip \
            --dart-define=APP_ENV=$ENV \
            --dart-define=APP_VERSION=$APP_VERSION
        echo ">>> Shorebird Release Build completed successfully!"
    else
        echo ">>> Error: USE_SHOREBIRD=true requested, but 'shorebird' CLI command was not found in PATH!"
        exit 1
    fi
else
    echo ">>> Executing Standard Flutter Release Build (Shorebird disabled)..."
    flutter build $build_cmd --release \
        --obfuscate --split-debug-info=apkOutput \
        --extra-gen-snapshot-options=--save-obfuscation-map=apkOutput/mapping.json,--strip \
        --dart-define=APP_ENV=$ENV \
        --dart-define=APP_VERSION=$APP_VERSION
fi

# --- Phase 6: Artifact Extraction & Standardized Output Staging ---
if [ -f "$from/$file_name" ]; then
    cp -rf "$from/$file_name" "apkOutput/lPortfolio-$ENV-release.$output_ext"
    echo ">>> Build successful. Output: apkOutput/lPortfolio-$ENV-release.$output_ext"
else
    echo ">>> Error: Build file not found at $from/$file_name"
    exit 1
fi
