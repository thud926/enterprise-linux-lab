#!/usr/bin/env bash
# ==============================================================================
# Bunkwerks Labs - Modern Slang CLI Utility Trilogy Installer
# Tools: yeet (rm), yoink (curl/cp), kobe (scp)
# ==============================================================================

set -euo pipefail

# Ensure the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "❌ Please run as root (use sudo ./install_trilogy.sh)"
  exit 1
fi

BIN_DIR="/usr/local/bin"
MAN_DIR="/usr/share/man/man1"

mkdir -p "$BIN_DIR" "$MAN_DIR"

echo "🚀 Beginning Bunkwerks Trilogy installation..."

# ------------------------------------------------------------------------------
# 1. INSTALLING YEET
# ------------------------------------------------------------------------------
echo "📦 Injecting 'yeet'..."
cat << 'EOF' > "$BIN_DIR/yeet"
#!/usr/bin/env bash
if [ $# -eq 0 ]; then
    echo "yeet: missing operand"
    echo "Try 'yeet --help' or 'man yeet' for more information."
    exit 1
fi

FORCE=false
RECURSIVE=false

for arg in "$@"; do
    case "$arg" in
        -*f*) FORCE=true ;;
    esac
    case "$arg" in
        -*r*|-*R*) RECURSIVE=true ;;
    esac
done

if [ "$FORCE" = true ] && [ "$RECURSIVE" = true ]; then
    echo "⚠️ Maximum Yeet engaged. Vaporizing directory tree into the digital void..."
elif [ "$FORCE" = true ]; then
    echo "💥 Absolute maximum yeet. No prompts, no mercy."
else
    echo "🚀 Aggressively ejecting targets from existence..."
fi

exec rm "$@"
EOF
chmod +x "$BIN_DIR/yeet"

cat << 'EOF' > "$MAN_DIR/yeet.1"
.TH YEET 1 "September 2026" "Bunkwerks Labs" "User Commands"
.SH NAME
yeet \- aggressively remove files and directories from existence
.SH SYNOPSIS
.B yeet
[\fI-i\fR] [\fI-r\fR] [\fI-f\fR] \fIFILE\fR...
.SH DESCRIPTION
.B yeet
is a modern, high-velocity wrapper for the standard rm(1) utility. It safely or violently ejects specified files and directories into the digital void.
.SH OPTIONS
.TP
.BR \-i ", " \-\-interactive
Prompt before every removal. Recommended for safety.
.TP
.BR \-r ", " \-\-recursive
Recursively yeet directories and their contents into non-existence.
.TP
.BR \-f ", " \-\-force
Ignore non-existent files and arguments, never prompt. Absolute maximum yeet.
.SH EXAMPLES
.TP
.B yeet build.log
Eject a single log file into oblivion.
.TP
.B yeet \-rf /tmp/junk/
Recursively and forcefully vaporize an unwanted directory tree.
.SH SEE ALSO
.BR rm (1),
.BR unlink (2)
EOF

# ------------------------------------------------------------------------------
# 2. INSTALLING YOINK
# ------------------------------------------------------------------------------
echo "📦 Injecting 'yoink'..."
cat << 'EOF' > "$BIN_DIR/yoink"
#!/usr/bin/env bash
if [ $# -eq 0 ]; then
    echo "yoink: missing operand"
    echo "Usage: yoink [-o OUTPUT] [-f] URL_OR_PATH"
    exit 1
fi

OUTPUT=""
FORCE=false
TARGET=""

while [[ $# -gt 0 ]]; do
    case $1 in
        -o|--output)
            OUTPUT="$2"
            shift 2
            ;;
        -f|--force)
            FORCE=true
            shift
            ;;
        *)
            if [ -z "$TARGET" ]; then
                TARGET="$1"
            fi
            shift
            ;;
    esac
done

if [ -z "$TARGET" ]; then 
    echo "❌ yoink: no target specified"
    exit 1
fi

if [ -z "$OUTPUT" ]; then 
    OUTPUT=$(basename "$TARGET")
fi

if [ -e "$OUTPUT" ] && [ "$FORCE" = false ]; then
    echo "❌ Error: '$OUTPUT' already exists! Use -f to yoink it anyway."
    exit 1
fi

if [[ "$TARGET" =~ ^https?:// ]]; then
    echo "🥷 Snatching '$OUTPUT' from the digital ether..."
    curl -sL -o "$OUTPUT" "$TARGET"
else
    echo "🫳 Yoinking local file: $TARGET -> $OUTPUT"
    cp -r "$TARGET" "$OUTPUT"
fi

echo "✅ Yoink successful."
EOF
chmod +x "$BIN_DIR/yoink"

cat << 'EOF' > "$MAN_DIR/yoink.1"
.TH YOINK 1 "September 2026" "Bunkwerks Labs" "User Commands"
.SH NAME
yoink \- aggressively snatch files from remote servers or local paths
.SH SYNOPSIS
.B yoink
[\fI-o OUTPUT\fR] [\fI-f\fR] \fIURL_OR_PATH\fR
.SH DESCRIPTION
.B yoink
is a modern, high-velocity wrapper for curl(1) and cp(1). It violently snatches specified assets from the digital ether and deposits them directly into your current working directory.
.SH OPTIONS
.TP
.BI \-o ", \-\-output " FILE
Specify a custom name for the snatched file.
.TP
.BR \-f ", " \-\-force
Overwrite existing files without warning. Maximum disrespect.
.SH SEE ALSO
.BR curl (1),
.BR cp (1)
EOF

# ------------------------------------------------------------------------------
# 3. INSTALLING KOBE
# ------------------------------------------------------------------------------
echo "📦 Injecting 'kobe'..."
cat << 'EOF' > "$BIN_DIR/kobe"
#!/usr/bin/env bash
if [ $# -lt 2 ]; then
    echo "kobe: missing file or destination target"
    echo "Usage: kobe [FLAGS] FILE... USER@HOST:/PATH"
    exit 1
fi

echo "🏀 [KOBE] Fading away... releasing long-range data transmission..."
scp -r "$@"

if [ $? -eq 0 ]; then
    echo "🔥 Nothing but net! Transmission successful."
else
    echo "❌ Airball. Connection failed."
    exit 1
fi
EOF
chmod +x "$BIN_DIR/kobe"

cat << 'EOF' > "$MAN_DIR/kobe.1"
.TH KOBE 1 "September 2026" "Bunkwerks Labs" "User Commands"
.SH NAME
kobe \- precision long-range transmission of files to remote hosts
.SH SYNOPSIS
.B kobe
[\fIOPTIONS\fR] \fISOURCE_FILE\fR... \fIUSER@REMOTE_HOST:/DESTINATION/PATH\fR
.SH DESCRIPTION
.B kobe
is a high-accuracy, long-distance utility wrapper for scp(1). Unlike yeet, which discards items blindly, kobe calculates a perfect trajectory to land your data exactly where it belongs on a remote server.
.SH SEE ALSO
.BR scp (1),
.BR ssh (1)
EOF

# ------------------------------------------------------------------------------
# 4. INDEX SYSTEM MAN PAGES
# ------------------------------------------------------------------------------
echo "🔄 Re-indexing man pages..."
mandb -q 2>/dev/null || true

echo "🎉 Installation complete! The Bunkwerks trilogy is live."
