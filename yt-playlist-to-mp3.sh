#!/usr/bin/bash

singlefile="false"
while getopts ":d:su:" opt; do
    case $opt in
        d)
            directory="$OPTARG"
            echo "Directory: $directory"
            ;;
        s)
            singlefile="true"
            echo "Single file: $singlefile"
            ;;
    
        u)
            url="$OPTARG"
            echo "Playlist url: $url"
            ;;
    
        \?)
            echo "Invalid option: -$OPTARG" >&2
            exit 1
            ;;
   
    esac
done

# Check if option 'url' is provided
if [ -z "$url" ]; then
    echo "Option '-u' is required. Please provide a valid youtube playlist url"
    exit 1
fi

# Check if directory exists
if [ ! -d "$directory" ]; then
    echo "Directory '$directory' does not exist. Please provide a valid directory path."
    exit 1
fi

# Check if option 'singlefile' is provided
if $singlefile; then
    cd $directory
    yt-dlp -f 'ba' -x --audio-format mp3 $url -o '%(title)s.mp3' --concat-playlist 'always'
    exit 1
fi

cd $directory

yt-dlp -f 'ba' -x --audio-format mp3 $url -o '%(uploader)sµ%(artist)sµ%(title)s.tmp'

for file in *.tmp*; do
    #cleaning the name and applying tags (artist/title) to the file 
    newfile=$(echo "$file" | sed 's/ - Topic//')
 
    #removes any part beween () or []
    newfile=$(echo "$newfile" | sed 's/ *(.*)//') 
    newfile=$(echo "$newfile" | sed 's/\[.*\]//')

    basename="${newfile%%.tmp*}" #remove the extension (.tmp.mp3)
    basename="${basename// - /µ}"
    IFS='µ'
    read -r uploader artist title <<< "$basename"

    if [[ $title == *"µ"* ]]; then
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
