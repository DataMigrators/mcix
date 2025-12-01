#!/bin/sh -l

# ███╗   ███╗███████╗████████╗████████╗██╗     ███████╗ ██████╗██╗
# ████╗ ████║██╔════╝╚══██╔══╝╚══██╔══╝██║     ██╔════╝██╔════╝██║
# ██╔████╔██║█████╗     ██║      ██║   ██║     █████╗  ██║     ██║
# ██║╚██╔╝██║██╔══╝     ██║      ██║   ██║     ██╔══╝  ██║     ██║
# ██║ ╚═╝ ██║███████╗   ██║      ██║   ███████╗███████╗╚██████╗██║
# ╚═╝     ╚═╝╚══════╝   ╚═╝      ╚═╝   ╚══════╝╚══════╝ ╚═════╝╚═╝
# MettleCI DevOps for DataStage       (C) 2025-2026 Data Migrators

set -eu

# -----
# Setup
# -----
MCIX_BIN_DIR="/usr/share/mcix/bin"
MCIX_CMD="$MCIX_BIN_DIR/mcix"
PATH="$PATH:$MCIX_BIN_DIR"

: "${GITHUB_OUTPUT:?GITHUB_OUTPUT must be set}"

# ------------
# Step summary
# ------------
write_step_summary() {
  rc=$1

  status_emoji="✅"
  status_title="Success"
  [ "$rc" -ne 0 ] && status_emoji="❌" && status_title="Failure"

  project_display="${PROJECT:-<none>}"
  [ -n "${PROJECT_ID:-}" ] && project_display="${project_display} (ID: ${PROJECT_ID})"

  {
    cat <<EOF
## ${status_emoji} MCIX DataStage Import – ${status_title}

| Property      | Value                          |
|--------------|--------------------------------|
| **Project**  | \`${project_display}\`        |
| **Assets**   | \`${PARAM_ASSETS:-<none>}\`   |
| **Exit Code** | \`${rc}\`                    |
EOF

    # If we captured any output from the main command, include it as a section
    if [ -n "${CMD_OUTPUT:-}" ]; then
      printf '\n### MettleCI Command Output\n\n'

      # ---- Code block (excluding plugin list) ----
      echo '```text'
      printf '%s\n' "$CMD_OUTPUT" | awk '
        /^Loaded plugins:/ { in_plugins = 1; next }
        in_plugins && /^\s*\*/ { next }  # skip plugin lines
        { print }
      '
      echo '```'
      echo

      # ---- Collapsible section with plugin table ----
      echo '<details>'
      echo '<summary>Loaded plugins</summary>'
      echo
      echo '| Plugin | Version |'
      echo '| ------ | ------- |'

      printf '%s\n' "$CMD_OUTPUT" | awk '
        /^Loaded plugins:/ { in_plugins = 1; next }
        in_plugins && /^\s*\*/ {
          line = $0
          # strip leading " * "
          sub(/^\s*\*\s*/, "", line)

          plugin = line
          version = ""

          # If there is a (...) at the end, treat that as the version
          if (match(plugin, /\(([^()]*)\)[[:space:]]*$/)) {
            version = substr(plugin, RSTART + 1, RLENGTH - 2)
            plugin  = substr(plugin, 1, RSTART - 1)
            sub(/[[:space:]]*$/, "", plugin)  # trim trailing spaces
          }

          printf("| %s | %s |\n", plugin, version)
        }
      '

      echo
      echo '</details>'
    fi
  } >>"$GITHUB_STEP_SUMMARY"
}

# ---------
# Exit trap
# ---------
# Generic trap that always sets return-code and writes the step summary
write_return_code_and_summary() {
  rc=$?
  echo "return-code=$rc" >>"$GITHUB_OUTPUT"

  # Only write step summary if GitHub provides the file
  [ -z "${GITHUB_STEP_SUMMARY:-}" ] && exit "$rc"

  write_step_summary "$rc"
  exit "$rc"
}
trap write_return_code_and_summary EXIT

# ------------------------
# Build command to execute
# ------------------------
# Start argv
set -- "$MCIX_CMD" system version

# -------
# Execute
# -------
echo "Executing: $*"

# Run the command, capture its output and status, but don't let `set -e` kill us.
set +e
CMD_OUTPUT="$("$@" 2>&1)"
status=$?
set -e

# Echo original command output into the job logs
printf '%s\n' "$CMD_OUTPUT"

exit "$status"