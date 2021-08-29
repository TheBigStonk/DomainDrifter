#!/bin/bash

echo "[][][][][][][][][][][][][][][][][]"
echo "Welcome to Domain Drifter"
echo "Note: This scan takes a while and"
echo "requires assetfinder, amass,"
echo "httprobe, and gowitness"
echo "[][][][][][][][][][][][][][][][][]"

url=$1

if [ ! -d "$url" ];then
    mkdir $url
fi

if [ ! -d "$url/recon" ];then
    mkdir $url/recon
fi

echo "[+] Harvesting subdomains with assetfinder..."
assetfinder $url >> $url/recon/assets.txt
cat $url/recon/assets.txt | grep $1 >> $url/recon/final.txt
rm $url/recon/assets.txt

echo "[+] Harvesting subdomains with Amass..."
amass enum -d $url >> $url/recon/f.txt
sort -u $url/recon/f.txt >> $url/recon/final.txt
rm $url/recon/f.txt

echo "[+] Probing for alive domains..."
cat $url/recon/final.txt | httprobe -s -p https:443 | sed 's/https\?:\/\///' | tr -d ":443" >> $url/recon/alive.txt

echo "[+] Screenshotting the alive pages..."
gowitness file -f $url/recon/alive.txt

echo "[+] COMPLETE, see screenshots and alive files for best results, gl"
exit 1