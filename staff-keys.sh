#!/usr/bin/env bash
set -euo pipefail

AUTHORIZED_KEYS="${HOME}/.ssh/authorized_keys"

# Ensure .ssh directory exists with correct permissions
mkdir -p "${HOME}/.ssh"
chmod 700 "${HOME}/.ssh"

# Ensure authorized_keys file exists
touch "${AUTHORIZED_KEYS}"
chmod 600 "${AUTHORIZED_KEYS}"

# Keys to add
declare -A KEYS=(
  ["raulm-02oct2021"]="ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEhMwTBa9Od2H4Ea9S6xCpLjswfR3UxL/foeyw22c97W raulm-02oct2021"
  ["lachlanr@slothnetworks.net"]="ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILBiOx4/i3iluLEbciV1NMUme3e4U+veTweHSgQwtY3J lachlanr@slothnetworks.net"
  ["zachary.c@sparkedhost.com"]="ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJzuiTv0zGt8krSmi/f/2TURThbr9ssHZ9mHznNff/wx zachary.c@sparkedhost.com"
  ["cayden.d@sparkedhost.com"]="ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGIF7X1txYpc76DCVzUML1BMa72JoYytVGwb5TFmRyAn cayden.d@sparkedhost.com"
  ["SagnikS-WS"]="ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGw007yWB3af3H2ZyXj59ki5+tZIki6iaFScBqWMb7cn SagnikS-WS"
  ["matt.w@sparkedhost.com"]="ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKwQ7rN1PpoRF4u7iY0h8yE0LH8ptK3/lM8/qkasf8ek matt.w@sparkedhost.com"
  ["me@linux123123.com"]="ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKvGvC5G8+KBka/3SCB0P8yADGVm/N/iCvBJJBF99Uhc me@linux123123.com"

)

added=0
skipped=0

for comment in "${!KEYS[@]}"; do
  key="${KEYS[$comment]}"
  # Extract just the key material (second field) for comparison to avoid
  # duplicate detection issues caused by differing comments
  key_material=$(echo "$key" | awk '{print $2}')

  if grep -qF "$key_material" "${AUTHORIZED_KEYS}" 2>/dev/null; then
    echo "  [skip]  Already present: ${comment}"
    ((skipped++)) || true
  else
    echo "$key" >> "${AUTHORIZED_KEYS}"
    echo "  [added] ${comment}"
    ((added++)) || true
  fi
done

echo ""
echo "Done — ${added} key(s) added, ${skipped} already present."
echo "authorized_keys: ${AUTHORIZED_KEYS}"
