#!/usr/bin/env bash
#
# Lab Proof-of-Work Evidence Collector
# Target Nodes:
#   - ken-optiplex-7010: 100.117.128.67
#   - ken-lenovo-ideapad-110-15isk: 100.109.2.114
#   - almalinux10: 100.67.104.107
#   - the-rock: 100.107.171.99
#   - rhel-node1: 100.126.26.113
#   - iphone-xr: 100.123.193.6

set -euo pipefail

# Output setup
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
OUTPUT_DIR="docs/proof"
OUTPUT_FILE="${OUTPUT_DIR}/proof_${TIMESTAMP}.md"

mkdir -p "${OUTPUT_DIR}"

echo "Collecting lab evidence into ${OUTPUT_FILE}..."

# Header
cat <<EOF > "${OUTPUT_FILE}"
# Lab Verification Log

**Generated:** $(date)  
**Host Node:** $(hostname)  
**User:** $(whoami)  

---

EOF

# 1. Host System Status
cat <<EOF >> "${OUTPUT_FILE}"
## 1. Local Host Status

\`\`\`text
$(fastfetch --pipe 2>/dev/null || neofetch --off 2>/dev/null || uname -a)
\`\`\`

### Active Network Interfaces
\`\`\`text
$(ip -brief addr 2>/dev/null || ifconfig)
\`\`\`

---

EOF

# 2. Tailscale Status
cat <<EOF >> "${OUTPUT_FILE}"
## 2. Tailscale Mesh Status

\`\`\`text
$(tailscale status 2>&1 || echo "Tailscale command not found or service inactive.")
\`\`\`

---

EOF

# 3. Network Ping Matrix over Overlay Network
cat <<EOF >> "${OUTPUT_FILE}"
## 3. Network Interconnectivity Matrix (Tailscale overlay)

EOF

# Array format: "LABEL|IP"
NODES=(
    "ken-optiplex-7010|100.117.128.67"
    "ken-lenovo-ideapad-110-15isk|100.109.2.114"
    "almalinux10|100.67.104.107"
    "the-rock|100.107.171.99"
    "rhel-node1|100.126.26.113"
    "iphone-xr|100.123.193.6"
)

cat <<EOF >> "${OUTPUT_FILE}"
| Node Name | Tailscale IP | Status | Packet Loss | Avg RTT |
| :--- | :--- | :---: | :---: | :---: |
EOF

for entry in "${NODES[@]}"; do
    IFS="|" read -r name ip <<< "${entry}"
    
    # Run 3 pings with a 1-second timeout
    PING_OUTPUT=$(ping -c 3 -W 1 "${ip}" 2>&1 || true)
    
    if echo "${PING_OUTPUT}" | grep -q "3 received\|2 received\|1 received"; then
        STATUS="ONLINE"
        LOSS=$(echo "${PING_OUTPUT}" | grep -oP '\d+%(?= packet loss)' || echo "N/A")
        RTT=$(echo "${PING_OUTPUT}" | awk -F'/' '/rtt|round-trip/ {print $5 " ms"}' || echo "N/A")
    else
        STATUS="OFFLINE / UNREACHABLE"
        LOSS="100%"
        RTT="N/A"
    fi
    
    echo "| \`${name}\` | \`${ip}\` | ${STATUS} | ${LOSS} | ${RTT} |" >> "${OUTPUT_FILE}"
done

echo "" >> "${OUTPUT_FILE}"
echo "---" >> "${OUTPUT_FILE}"
echo "Proof generation complete: ${OUTPUT_FILE}"
