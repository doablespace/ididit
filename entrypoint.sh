#!/bin/bash
# This script contains commands run in Docker after source code is mounted.

# Fail on first error
set -e

# HACK: Patch Flutter (allows transparent dismissible widget).
(cd $FLUTTER_HOME && git apply $OLDPWD/flutter.patch)

# Restore Ruby dependencies (Fastlane).
bundle install

# Restore Dart dependencies.
flutter pub get
