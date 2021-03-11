#!/bin/bash
[ "$UID" -eq 0 ] || exec sudo bash "$0" "$@"

mkdir -p scans
echo "[*] Scan directory created"
echo "[*] Creating live_host output directories"
cat live_hosts.txt | while read ip; do mkdir -p scans/${ip}; done
echo "[*] Creating parallel script"
cat live_hosts.txt | while read ip; do echo "sudo nmap -A -sV -Pn -p- --script=default,vuln --open -oA scans/${ip}/${ip} $ip"; done > scan_all_ips.out
echo "[*] Executing parallel script"
parallel --jobs 32 < scan_all_ips.out
echo "[*] Changing ownership of output files"
sudo chown slinky:slinky -R scans
