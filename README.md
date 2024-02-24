# yt-playlist-to-mp3
Simple bash script to download a youtube music playlist in mp3 format with the right name and metadata. 
I wanted to simplify my process of downloading music from youtube. 
This script uses [yt-dlp](https://github.com/yt-dlp/yt-dlp) to download the playlist in mp3 format.

To use it you first need to install **yt-dlp** :

```sudo apt install yt-dlp``` 

Then in the script you need to set the directory in which you want to download the music. 
make the script executable:

```chmod +x yt-playlist-to-mp3.sh```

Then you just have to execute the script :

```./yt-playlist-to-mp3.sh -d /home/user/youneedtochangethis -u  https://music.youtube.com/playlist?list=RDCLAK5uy_mFeKbwD6X5axmhNcvd ```

There are 4 options: 
* **-d** to specify the output directory
* **-u** to specify the yt playlist url
* **-s** singlefile flag
* **-t** thumbnail flag

If the **-s** option is used, all the videos in the playlist will be concatenated into a single file (*playlistname.mp3*).
Else the name of the files will be *artist - title.mp3*

If the **-t** option is used, the thumbnail of the video will be embedded directly into the file.

By default the audio quality of each music is 201kbps but you can change it in the script by modifying the **--audio-quality** value.

# Notes 

I first created the script because I wanted to download the music with yt-dlp and then apply the tags with [kid3](https://github.com/KDE/kid3) and have clean names (without "official video" bullshit). However I recently found out that you could do almost everything with one yt-dlp command :
```
yt-dlp -f 'ba' -x --audio-format mp3 --audio-quality 2 $url -o '%(artist)s - %(title)s' --embed-metadata --parse-metadata ':(?P<description>)' --windows-filenames --replace-in-metadata 'title' '^.*\s-\s|\s\[.*|\s\(.*|\s$' ''
```
The only reason that I still have this script is because in a few cases the artist is not present in the metadata which creates a file named *NA - title*. In that case my script takes the "uploader" tag.
And I also want multiple artists in the tags but not in the file name.

It may be possible with yt-dlp alone but i didn't find how yet.

Future addition is to add the lyrics, for that I may need to reuse kid3.

