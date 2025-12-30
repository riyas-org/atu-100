#!/bin/bash

# Configuration
PROJECT_PATH=$1
CONF_NAME=$2
COMPILER_PATH="/opt/microchip/xc8/v2.20/bin"

echo "--------------------------------------------------------"
echo "Building project ${PROJECT_PATH} [${CONF_NAME}]"
echo "Using MPLAB X v6.00 and XC8 v2.20"
echo "--------------------------------------------------------"

# Stop script on any error
set -e

# 1. Ensure the compiler is in the PATH for this session
export PATH="${COMPILER_PATH}:${PATH}"

# 2. Generate Makefiles
echo "Step 1: Generating Makefiles..."
/opt/mplabx/mplab_platform/bin/prjMakefilesGenerator.sh "${PROJECT_PATH}@${CONF_NAME}" || { echo "Makefile generation failed"; exit 1; }

# 3. Run the build
echo "Step 2: Compiling and Linking..."
make -C "${PROJECT_PATH}" CONF="${CONF_NAME}" build || { echo "Compilation failed"; exit 2; }

# 4. Fix Permissions (Hand ownership back to the host user)
# This looks at the owner of the current directory and applies it to the build artifacts
echo "Step 3: Adjusting permissions..."
OWNER=$(stat -c '%u:%g' .)
chown -R "$OWNER" "${PROJECT_PATH}/dist" "${PROJECT_PATH}/build" "${PROJECT_PATH}/nbproject"

echo "--------------------------------------------------------"
echo "BUILD SUCCESSFUL"
# Find and display the resulting hex file
find "${PROJECT_PATH}/dist/${CONF_NAME}" -name "*.hex" -exec echo "Result: {}" \;
echo "--------------------------------------------------------"

