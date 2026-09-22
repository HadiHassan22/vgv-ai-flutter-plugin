#!/bin/bash
# SessionStart hook: warn when Very Good CLI is missing or outdated.
# Output is injected into Claude's context (not displayed in the terminal).
# Non-blocking — always exits 0.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/vgv-cli-common.sh"

cli_status=$(check_vgv_cli)
case "$cli_status" in
  not_installed)
    echo "⚠️ Very Good CLI is not installed. The Very Good CLI MCP server will not work without Very Good CLI >= ${MIN_VERSION}. Install with: dart pub global activate very_good_cli"
    ;;
  outdated:*)
    version="${cli_status#outdated:}"
    echo "⚠️ Very Good CLI ${version} is too old. The Very Good CLI MCP server requires >= ${MIN_VERSION}. Update with: dart pub global activate very_good_cli"
    ;;
  unverifiable)
    # The very_good shim execs dart. The Very Good CLI MCP server starts through the same
    # shim, so if dart is missing from the PATH hooks inherit, the server will not start.
    echo "⚠️ Very Good CLI was found but could not run: dart is not on the PATH available to hooks, so its version could not be verified and the Very Good CLI MCP server will not start. Add the Dart SDK bin directory to PATH for non-interactive shells (e.g. in ~/.zprofile) and start a new session."
    ;;
esac

exit 0
