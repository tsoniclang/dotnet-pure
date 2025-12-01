#!/bin/bash
# Generate TypeScript declarations for .NET BCL (CLR naming - no JS transformations)
#
# This script regenerates all TypeScript type declarations from .NET assemblies
# using tsbindgen. Unlike @tsonic/dotnet, this uses CLR/PascalCase naming.
#
# Prerequisites:
#   - .NET 10 SDK installed
#   - tsbindgen repository cloned at ../tsbindgen (sibling directory)
#
# Usage:
#   ./__build/scripts/generate.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
TSBINDGEN_DIR="$PROJECT_DIR/../tsbindgen"

# .NET runtime path
DOTNET_VERSION="${DOTNET_VERSION:-10.0.0-rc.1.25451.107}"
DOTNET_HOME="${DOTNET_HOME:-$HOME/dotnet}"
DOTNET_RUNTIME_PATH="$DOTNET_HOME/shared/Microsoft.NETCore.App/$DOTNET_VERSION"

echo "================================================================"
echo "Generating .NET BCL TypeScript Declarations (CLR naming)"
echo "================================================================"
echo ""
echo "Configuration:"
echo "  .NET Runtime: $DOTNET_RUNTIME_PATH"
echo "  tsbindgen:    $TSBINDGEN_DIR"
echo "  Output:       $PROJECT_DIR"
echo "  Naming:       CLR (PascalCase - no JS transformations)"
echo ""

# Verify prerequisites
if [ ! -d "$DOTNET_RUNTIME_PATH" ]; then
    echo "ERROR: .NET runtime not found at $DOTNET_RUNTIME_PATH"
    echo "Set DOTNET_HOME or DOTNET_VERSION environment variables"
    exit 1
fi

if [ ! -d "$TSBINDGEN_DIR" ]; then
    echo "ERROR: tsbindgen not found at $TSBINDGEN_DIR"
    echo "Clone it: git clone https://github.com/tsoniclang/tsbindgen ../tsbindgen"
    exit 1
fi

# Clean output directory (keep config files)
echo "[1/3] Cleaning output directory..."
cd "$PROJECT_DIR"

# Remove all namespace directories (but keep config files, __build, node_modules, .git)
find . -maxdepth 1 -type d \
    ! -name '.' \
    ! -name '.git' \
    ! -name '.tests' \
    ! -name 'node_modules' \
    ! -name '__build' \
    -exec rm -rf {} \; 2>/dev/null || true

# Also remove internal/ and Internal/ at root level
rm -rf internal Internal 2>/dev/null || true

echo "  Done"

# Build tsbindgen
echo "[2/3] Building tsbindgen..."
cd "$TSBINDGEN_DIR"
dotnet build src/tsbindgen/tsbindgen.csproj -c Release --verbosity quiet
echo "  Done"

# Generate types with CLR naming (no --naming js flag)
echo "[3/3] Generating TypeScript declarations..."
dotnet run --project src/tsbindgen/tsbindgen.csproj --no-build -c Release -- \
    generate -d "$DOTNET_RUNTIME_PATH" -o "$PROJECT_DIR"

echo ""
echo "================================================================"
echo "Generation Complete"
echo "================================================================"
