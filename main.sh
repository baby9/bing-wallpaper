#!/bin/bash

function updateREADME {
    base_url="https://www.bing.com"
    header="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36 Edg/120.0.2592.113"

    if [ $1 == "yesterday" ]; then
        api="HPImageArchive.aspx?format=js&idx=1&n=1"
    elif [ $1 == "today" ]; then
        api="HPImageArchive.aspx?format=js&idx=0&n=1"
    fi
    
    response=$(curl -s -A "$header" -X GET "${base_url}/${api}" -H "Accept: application/json")
    urlbase=$(echo $response | awk -F '"urlbase"' '{print $2}' | awk -F '"' '{print $2}')

    if [ ! -z $urlbase ]; then
        if (! $(head README.md | grep -q "$urlbase")); then
            startdate=$(echo $response | awk -F '"startdate"' '{print $2}' | awk -F '"' '{print $2}')
            date_month_day=$(date -d $startdate +%b-%d)
            date_year=$(date -d $startdate +%Y)
            url="${base_url}$(echo $response | awk -F '"url"' '{print $2}' | awk -F '"' '{print $2}')"
            image_url=$(echo $url | awk -F '&' '{print $1}')
            copyright=$(echo $response | awk -F '"copyright"' '{print $2}' | awk -F '"' '{print $2}')
            image_UHD=$(echo $image_url | sed "s#$(echo $image_url | awk -F '.' '{print $(NF-1)}' | awk -F '_' '{print $NF}')#UHD#g")
            update_content="![](${image_url}&w=1000)${date_month_day}: [${copyright}](${image_UHD})<br><br>"

            sed -i "1a $update_content" README.md
            sed -i '32,$d' README.md
            if [ ! -d history/${date_year} ]; then
              mkdir -p history/${date_year}
            fi
            echo $update_content >> history/${date_year}/README.md
        fi
    else
        exit 1
    fi
}

# Check yesterday's update
updateREADME yesterday

# Today's update
updateREADME today
