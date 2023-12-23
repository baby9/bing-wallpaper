#!/bin/bash

base_url="https://www.bing.com"
api="HPImageArchive.aspx?format=js&idx=0&n=1"
header="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.127 Safari/537.36"
response=$(curl -s -A "$header" -X GET "${base_url}/${api}" -H "Accept: application/json")
full_url="${base_url}$(echo $response | awk -F '"url"' '{print $2}' | awk -F '"' '{print $2}')"

image_url=$(echo $full_url | awk -F '&' '{print $1}')
copyright=$(echo $response | awk -F '"copyright"' '{print $2}' | awk -F '"' '{print $2}')
image_UHD=$(echo $image_url | sed "s#$(echo $image_url | awk -F '.' '{print $(NF-1)}' | awk -F '_' '{print $NF}')#UHD#g")
 
curl -s $image_UHD -o wallpaper.jpg
sed -i "s/Today/$(date -d last-day +%b-%d)/" README.md
sed -i "1a ![]($image_url&w=1000)Today:\ [$copyright]($image_UHD)<br><br>" README.md

exit
