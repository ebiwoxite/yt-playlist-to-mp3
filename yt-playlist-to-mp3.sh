#!/usr/bin/bash

directory="/youneedtochangethis"
cd $directory
rm *
echo "removed all files in $directory"

playlist=$1
yt-dlp -f 'ba' -x --audio-format mp3 $1 -o '%(artist)s - %(title)s.mp3'

for file in *; do
    #cleaning the name and applying tags (artist/title) to the file

    #removing the NA part (when there is no artist defined) 
    newfile=$(echo "$file" | sed 's/NA - //')
    
    #removes any part beween () or []
    newfile=$(echo "$newfile" | sed 's/ *(.*)//') 
    newfile=$(echo "$newfile" | sed 's/\[.*\]//')
  
    basename="${newfile%%.mp3*}" #remove the .mp3
    basename="${basename//\'/\'\\\'\'}"

    delimiter=' - '
    artist="${basename%$delimiter*}"
    artist="${artist%%,*}" #if there are featurings, it only take the first artist
    
    title="${basename#*$delimiter}"

    if [ -n "$artist" ] && [ -n "$title" ]; then #to verify if they are null
        echo "Applying tags..." 
        kid3-cli -c "set artist '$artist'" -c "set title '$title'" "$file"
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
