#!/usr/bin/bash
singlefile="false"
thumbnail="false"
while getopts ":d:stu:" opt; do
    case $opt in
        d)
            directory="$OPTARG"
            echo "Directory: $directory"
            ;;
        s)
            singlefile="true"
            echo "Single file: $singlefile"
            ;;
        t)
            thumbnail="true"
            echo "Embed thumbnail: $thumbnail"
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

command="yt-dlp -f 'ba' -x --audio-format mp3 --audio-quality 2 \"$url\" -o '%(uploader)sµ%(artist)sµ%(title)s.tmp' --embed-metadata --parse-metadata ':(?P<description>)' --windows-filenames --replace-in-metadata 'title' '^.*\s-\s|\s\[.*|\s\(.*|\s$' '' --replace-in-metadata 'uploader' '\s-\sTopic' ''"

# Check if option 'singlefile' is provided
if $singlefile; then
    command="yt-dlp -f 'ba' -x --audio-format mp3 --recode-video mp3 --audio-quality 2 \"$url\" -o '%(title)s.mp3' --windows-filenames --concat-playlist 'always'"
fi

# Check if option 'thumbnail' is provided
if $thumbnail; then
    command="$command --embed-thumbnail"
fi

cd $directory
eval $command

for file in *.tmp*; do
    echo "Processing $file"
    basename="${file%%.tmp*}" #remove the extension (.tmp.mp3)
    basename="${basename// - /µ}"
    IFS='µ'
    read -r uploader artist title <<< "$basename"
    
    IFS=' '
    
    # the regex we did to clean the artist and title with yt-dlp does not apply to the name of the file so we need to clean it manually
    
    if [[ $artist == "NA" ]]; then
        echo 'artist is NA' 
        artist=$uploader
        artist="${artist%% Officiel*}"	
        artist="${artist%% Official*}"
        artist="${artist%%VEVO*}"
    fi
    #if there are featurings, it only take the first artist for the file name
    artist="${artist%%,*}" 
    artist="${artist%%feat*}"

    #verify if artist+title are null
    if [ -n "$artist" ] && [ -n "$title" ]; then 
        newfile="$artist - $title.mp3"
    else
    	newfile="$file.error.mp3"
        echo "problem while identifying artist and title: $file"
    fi
      
    mv "$file" "$newfile"
    echo "Renamed $newfile"
done

echo "Finished renaming and tagging files"
echo "You can find all your awesome music in $directory"
