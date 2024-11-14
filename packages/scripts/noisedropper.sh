#!/usr/bin/env bash
set -euo pipefail

alias curl="curl -L"
alias rm="rm -rf"

# Create a temporary working folder if not in systemd service
WORKDIR=${STATE_DIRECTORY:-"/tmp/bad-lists"}

BAD_LIST_DIR="$WORKDIR/bad-lists"
EXCLUDE_LIST_DIR="$WORKDIR/exclude-lists"
OUT_DIR="$WORKDIR/merged"
IPSET_NAME_CUR="noisedropper-iplist" # Name of the ipset set we're using
IPSET_NAME_NEW="noisedropper-iplist-new"

mkdir -p "$BAD_LIST_DIR"
mkdir -p "$EXCLUDE_LIST_DIR"
mkdir -p "$OUT_DIR"

required_commands=(
  "curl"
  "grepcidr"
  "ipset"
  "iptables"
  "ip6tables"
  "jq"
)

for cmd in "${required_commands[@]}"; do

  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "$cmd could not be found"
    exit 1
  fi
done

echo "Workdir is $WORKDIR"

update_ipset_sets() {
  # Ensure sets exist.
  ipset create -exist "$IPSET_NAME_CUR-v4" hash:net
  ipset create -exist "$IPSET_NAME_CUR-v6" hash:net family inet6
  ipset create -exist "$IPSET_NAME_NEW-v4" hash:net
  ipset create -exist "$IPSET_NAME_NEW-v6" hash:net family inet6

  # Add all bad IPs to new set
  while read -r ip; do
    if [[ $ip =~ .*:.* ]]; then
      ipset add -exist "$IPSET_NAME_NEW-v6" "$ip"
    else
      ipset add -exist "$IPSET_NAME_NEW-v4" "$ip"
    fi

  done <"$OUT_DIR/bad_ips.txt"

  # Replace old ipset with new
  ipset swap "$IPSET_NAME_CUR-v4" "$IPSET_NAME_NEW-v4"
  ipset swap "$IPSET_NAME_CUR-v6" "$IPSET_NAME_NEW-v6"

  # Destroy the 'old' set, which was renamed to 'new' during swap.
  ipset destroy "$IPSET_NAME_NEW-v4"
  ipset destroy "$IPSET_NAME_NEW-v6"

}

#  ----------------
#  Fetch lists.
#  ----------------

handle_manual_lists() {
  # Spamhaus DROP
  curl https://www.spamhaus.org/drop/drop_v4.json | jq -r '. | select(.cidr != null) | .cidr' >"$BAD_LIST_DIR/spamhaus_drop_v4.json"
  curl https://www.spamhaus.org/drop/drop_v6.json | jq -r '. | select(.cidr != null) | .cidr' >"$BAD_LIST_DIR/spamhaus_drop_v6.json"

  # DShield's recommended blocklist
  touch "$BAD_LIST_DIR/dshield_block.txt"
  curl -s --fail https://dshield.org/block.txt | grep -v "^#" >"$WORKDIR/dshield_tmp.txt"

  # Read each line from the file
  while IFS=$'\t' read -r start_ip _end_ip prefix _; do
    # Output the CIDR notation
    echo "${start_ip}/${prefix}" >>"$BAD_LIST_DIR/dshield_block.txt"
  done <"$WORKDIR/dshield_tmp.txt"

}

# Mostly from https://github.com/CriticalPathSecurity/Public-Intelligence-Feeds/tree/master
# Lists of bad IPs.
ip_lists=(
  # "https://raw.githubusercontent.com/CriticalPathSecurity/Public-Intelligence-Feeds/master/abuse-ch-ipblocklist.txt"
  # "https://raw.githubusercontent.com/CriticalPathSecurity/Public-Intelligence-Feeds/master/alienvault.txt"
  # "https://raw.githubusercontent.com/CriticalPathSecurity/Public-Intelligence-Feeds/master/binarydefense.txt"
  # "https://raw.githubusercontent.com/CriticalPathSecurity/Public-Intelligence-Feeds/master/cobaltstrike_ips.txt"
  # "https://raw.githubusercontent.com/CriticalPathSecurity/Public-Intelligence-Feeds/master/cobaltstrike_ips.txt"
  # "https://raw.githubusercontent.com/CriticalPathSecurity/Public-Intelligence-Feeds/master/compromised-ips.txt"
  # "https://raw.githubusercontent.com/CriticalPathSecurity/Public-Intelligence-Feeds/master/illuminate.txt"
  # # "https://raw.githubusercontent.com/CriticalPathSecurity/Public-Intelligence-Feeds/master/predict.txt" - returning (sub)domains instead of IPs. Has it always done this...?
  # # "https://raw.githubusercontent.com/CriticalPathSecurity/Public-Intelligence-Feeds/master/log4j.txt" # Contains Cloudflare IPs...
  # # "https://raw.githubusercontent.com/CriticalPathSecurity/Public-Intelligence-Feeds/master/sans.txt"
  # "https://raw.githubusercontent.com/CriticalPathSecurity/Public-Intelligence-Feeds/master/threatfox.txt"
  # "https://raw.githubusercontent.com/CriticalPathSecurity/Public-Intelligence-Feeds/master/tor-exit.txt"
  "https://report.cs.rutgers.edu/DROP/attackers"
)

exclude_lists=(
  # Lists will be used as filters by grepcidr: can be composed of CIDRs, IP-ranges or single IPs
  # (See man grepcidr for more info)
  "https://www.cloudflare.com/ips-v4"
  "https://www.cloudflare.com/ips-v6"
  #TODO: add more exclude lists
)

echo "Refreshing lists..."
for url in "${ip_lists[@]}"; do
  filename=$(basename "$url")
  curl "$url" --output "$BAD_LIST_DIR/$filename"
done

handle_manual_lists

for url in "${exclude_lists[@]}"; do
  filename=$(basename "$url")
  curl "$url" --output "$EXCLUDE_LIST_DIR/$filename"
done
echo "Done refreshing lists."

# A local file with our own excludes.
if test -f "$WORKDIR/exclude_ips.txt"; then
  echo "File exists."
  cp "$WORKDIR/exclude_ips.txt" "$EXCLUDE_LIST_DIR/"
fi

#  ----------------
#  Process lists and output results.
#  ----------------

#Merge lists.
#cat * (and similar) garbles output together when some files don't have a newline at end-of-file and such.
# grep -h '' fixes this problem: https://unix.stackexchange.com/a/583381
grep -h "" "$BAD_LIST_DIR/"* | sort -u >"$OUT_DIR/bad_ips_unfiltered.txt"
grep -h "" "$EXCLUDE_LIST_DIR/"* | sort -u >"$OUT_DIR/excluded_ips.txt"

# Exclude IPs known to be benign - Cloudflare only atm
# Maybe add Google (1e100.net only! i.e, not user-controlled), etc in the future, if more lists are used
grepcidr -vf "$OUT_DIR/excluded_ips.txt" <"$OUT_DIR/bad_ips_unfiltered.txt" >"$OUT_DIR/bad_ips.txt" # || exit 0

echo "Updating ipset sets..."
update_ipset_sets

echo "Ensuring ip(6)tables rules are in place..."
iptables -C INPUT -m set --match-set "$IPSET_NAME_CUR-v4" src -j DROP 2>/dev/null || iptables -I INPUT -m set --match-set "$IPSET_NAME_CUR-v4" src -j DROP
# Same but IPv6
ip6tables -C INPUT -m set --match-set "$IPSET_NAME_CUR-v6" src -j DROP 2>/dev/null || ip6tables -I INPUT -m set --match-set "$IPSET_NAME_CUR-v6" src -j DROP

echo "Done!"
