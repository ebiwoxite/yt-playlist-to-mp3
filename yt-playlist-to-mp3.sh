#!/usr/bin/bash

directory="/youneedtochangethis"
cd $directory
rm *
echo "removed all files in $directory"


playlist=$1
yt-dlp -f 'ba' -x --audio-format mp3 $1 -o '%(uploader)s - %(title)s.mp3'
echo "finished downloading"
for file in *; do
    #renaming files without the Topic part 
    newfile=$(echo "$file" | sed 's/ - .* - / - /')
    mv "$file" "$newfile"
    echo "Renamed $newfile"
    
    #applying tags (artist/title) to the file
    filename=$(basename -s ".mp3" "$newfile")
    echo "Applying tags..." 
    delimiter=' - '
    artist="${filename%$delimiter*}"
    artist="${artist//\'/\'\\\'\'}"
    title="${filename#*$delimiter}"
    title="${title//\'/\'\\\'\'}"

    if [ -n "$artist" ] && [ -n "$title" ]; then #to verify if they are null
      kid3-cli -c "set artist '$artist'" -c "set title '$title'" "$newfile"
    else
      echo "problem while applying tags $filename to $newfile"
    fi
    
    # [COMING NEXT] putting the thumbnail of the video
done
echo "Finished renaming and tagging files"
echo "You can find all your awesome music in $directory"
