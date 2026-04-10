#!/bin/bash
set -e

VERSION=$(grep '^version:' pubspec.yaml | sed 's/version: //' | sed 's/+.*//')
BUILD=$(grep '^version:' pubspec.yaml | sed 's/.*+//')

echo "▶ Building FieldShotAI v$VERSION+$BUILD ..."

flutter build apk --release

mkdir -p release
cp build/app/outputs/flutter-apk/app-release.apk release/FieldShotAI-v$VERSION.apk
cd release && zip FieldShotAI-v$VERSION.zip FieldShotAI-v$VERSION.apk

echo "✅ Done: release/FieldShotAI-v$VERSION.zip"
