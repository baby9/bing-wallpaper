#!/bin/bash

function updateREADME {
    base_url="https://www.bing.com"
    header="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.127 Safari/537.36"

    if [ $1 == "yesterday" ]; then
        api="HPImageArchive.aspx?format=js&idx=1&n=1"
    elif [ $1 == "today" ]; then
        api="HPImageArchive.aspx?format=js&idx=0&n=1"
    fi
    
    response=$(curl -s -A "$header" -X GET "${base_url}/${api}" -H "Accept: application/json")
    urlbase=$(echo $response | awk -F '"urlbase"' '{print $2}' | awk -F '"' '{print $2}')

    if [ ! -z $urlbase ]; then
        if (! $(head README.md | grep -q "$urlbase")); then
            new_date=$(date -d "$(echo $response | awk -F '"startdate"' '{print $2}' | awk -F '"' '{print $2}')" +%b-%d)
            full_url="${base_url}$(echo $response | awk -F '"url"' '{print $2}' | awk -F '"' '{print $2}')"
            image_url=$(echo $full_url | awk -F '&' '{print $1}')
            copyright=$(echo $response | awk -F '"copyright"' '{print $2}' | awk -F '"' '{print $2}')
            image_UHD=$(echo $image_url | sed "s#$(echo $image_url | awk -F '.' '{print $(NF-1)}' | awk -F '_' '{print $NF}')#UHD#g")

            sed -i "1a ![](${image_url}&w=1000)${new_date}:\ [${copyright}](${image_UHD})<br><br>" README.md
        fi
    else
        exit 1
    fi
}

# Check yesterday's update
updateREADME yesterday

# Today's update
updateREADME today
