#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PROXY_DIR="${ROOT_DIR}/repo/forge-proxy/de/oceanlabs/mcp"
FORGE_MAVEN_BASE="https://maven.minecraftforge.net/de/oceanlabs/mcp"
MCP_CACHE_DIR="${ROOT_DIR}/.gradle/caches/minecraft"
USER_MCP_CACHE_DIR="${HOME}/.gradle/caches/minecraft"
FERNFLOWER_ZIP="${MCP_CACHE_DIR}/fernflower-fix-1.0.zip"
USER_FERNFLOWER_ZIP="${USER_MCP_CACHE_DIR}/fernflower-fix-1.0.zip"

download() {
    local source_url="$1"
    local dest_path="$2"
    mkdir -p "$(dirname "${dest_path}")"
    curl -fsSL "${source_url}" -o "${dest_path}"
}

# ForgeGradle 1.2 transitive dependencies that cannot be downloaded by JRE8
# builds missing EC cipher/provider support.
download \
    "${FORGE_MAVEN_BASE}/RetroGuard/3.6.6/RetroGuard-3.6.6.pom" \
    "${PROXY_DIR}/RetroGuard/3.6.6/RetroGuard-3.6.6.pom"
download \
    "${FORGE_MAVEN_BASE}/RetroGuard/3.6.6/RetroGuard-3.6.6.jar" \
    "${PROXY_DIR}/RetroGuard/3.6.6/RetroGuard-3.6.6.jar"

download \
    "${FORGE_MAVEN_BASE}/mcinjector/3.2-SNAPSHOT/maven-metadata.xml" \
    "${PROXY_DIR}/mcinjector/3.2-SNAPSHOT/maven-metadata.xml"
download \
    "${FORGE_MAVEN_BASE}/mcinjector/3.2-SNAPSHOT/mcinjector-3.2-20150605.000822-18.pom" \
    "${PROXY_DIR}/mcinjector/3.2-SNAPSHOT/mcinjector-3.2-20150605.000822-18.pom"
download \
    "${FORGE_MAVEN_BASE}/mcinjector/3.2-SNAPSHOT/mcinjector-3.2-20150605.000822-18.jar" \
    "${PROXY_DIR}/mcinjector/3.2-SNAPSHOT/mcinjector-3.2-20150605.000822-18.jar"

download \
    "${FORGE_MAVEN_BASE}/versions.json" \
    "${MCP_CACHE_DIR}/McpMappings.json"
download \
    "${FORGE_MAVEN_BASE}/versions.json" \
    "${USER_MCP_CACHE_DIR}/McpMappings.json"

download \
    "https://files.minecraftforge.net/fernflower-fix-1.0.zip" \
    "${FERNFLOWER_ZIP}"
unzip -p "${FERNFLOWER_ZIP}" fernflower.jar > "${MCP_CACHE_DIR}/fernflower-fixed.jar"
download \
    "https://files.minecraftforge.net/fernflower-fix-1.0.zip" \
    "${USER_FERNFLOWER_ZIP}"
unzip -p "${USER_FERNFLOWER_ZIP}" fernflower.jar > "${USER_MCP_CACHE_DIR}/fernflower-fixed.jar"

echo "Bootstrapped local Forge proxy repo at: ${ROOT_DIR}/repo/forge-proxy"
