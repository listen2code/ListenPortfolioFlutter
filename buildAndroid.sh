#!/bin/bash

# Default values
TARGET_TYPE=${1:-"apk"} # Use first argument, default to "apk"

if [ "$TARGET_TYPE" == "bundle" ]; then
    echo ">>> Building App Bundle (.aab)"
    build_cmd="appbundle"
    from="build/app/outputs/bundle/release"
    file_name="app-release.aab"
    output_ext="aab"
else
    echo ">>> Building APK (.apk)"
    build_cmd="apk"
    from="build/app/outputs/flutter-apk"
    file_name="app-release.apk"
    output_ext="apk"
fi

echo ">>> clean cache"
rm -rf apkOutput
mkdir apkOutput
flutter clean

echo ">>> flutter pub get"
flutter pub get

echo ">>> build $TARGET_TYPE"
# Added obfuscation and debug info splitting as in original script
flutter build $build_cmd --release --no-pub --obfuscate --split-debug-info=apkOutput --extra-gen-snapshot-options=--save-obfuscation-map=apkOutput/mapping.json

# Copy result to output folder
if [ -f "$from/$file_name" ]; then
    cp -rf "$from/$file_name" "apkOutput/lPortfolio-release.$output_ext"
    # APK usually has a sha1 file, AAB might not always have it in the same spot, but let's try to copy if exists
    if [ -f "$from/$file_name.sha1" ]; then
        cp -rf "$from/$file_name.sha1" "apkOutput/lPortfolio-release.$output_ext.sha1"
    fi
    echo ">>> Build successful. Output in apkOutput/"
else
    echo ">>> Error: Build file not found at $from/$file_name"
    exit 1
fi
