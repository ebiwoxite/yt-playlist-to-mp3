#!/usr/bin/bash

directory="/youneedtochangethis"
cd $directory
rm *
echo "removed all files in $directory"
playlist=$1
yt-dlp -f 'ba' -x --audio-format mp3 $1 -o '%(uploader)sµ%(artist)sµ%(title)s.mp3'

for file in *; do
    #cleaning the name and applying tags (artist/title) to the file 
    newfile=$(echo "$file" | sed 's/ - Topic//')
 
    #removes any part beween () or []
    newfile=$(echo "$newfile" | sed 's/ *(.*)//') 
    newfile=$(echo "$newfile" | sed 's/\[.*\]//')

    basename="${newfile%%.mp3*}" #remove the .mp3
    basename="${basename// - /µ}"
    IFS='µ'
    read -r uploader artist title <<< "$basename"

    if [[ $title == *"µ"* ]]; then
        echo "title contains artist"
        read -r artist title <<< "$title"
    fi
    IFS=' '
    
    if [[ $artist == "NA" ]]; then
        echo 'artist is NA' 
        artist=$uploader
        artist="${artist%% Officiel*}"	
        artist="${artist%% Official*}"
        artist="${artist%%VEVO*}"
    fi
    #if there are featurings, it only take the first artist
    artist="${artist%%,*}" 
    artist="${artist%%feat*}"

    #strip spaces from the end of the strings
    artist=$(echo "$artist" | sed 's/[[:space:]]*$//')
    title=$(echo "$title" | sed 's/[[:space:]]*$//')
    if [ -n "$artist" ] && [ -n "$title" ]; then #to verify if they are null
        echo "Applying tags..." 
        kid3-cli -c "set artist \"$artist\"" -c "set title \"$title\"" "$file"
        newfile="$artist - $title.mp3"
    else
        echo "problem while applying tags $file"
    fi
    
    #removes any illegal characters for file names 
    newfile=$(echo "$newfile" | tr -d ':?|!$#%&{}<>*/')   
    mv "$file" "$newfile"
    echo "Renamed $newfile"
    # [COMING NEXT] putting the thumbnail of the video
done

echo "Finished renaming and tagging files"
echo "You can find all your awesome music in $directory"
