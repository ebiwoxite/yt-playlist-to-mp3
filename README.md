# yt-playlist-to-mp3
Simple bash script to download a youtube music playlist in mp3 format with the right name and metadata. 
I wanted to simplify my process of downloading music from youtube. 
This script uses yt-dlp (https://github.com/yt-dlp/yt-dlp) to download the playlist in mp3 format.
It also uses kid3-cli (https://github.com/KDE/kid3) to apply the artist and title tags.

To use it you first need to install yt-dlp and kid3-cli :

```sudo apt install yt-dlp kid3-cli``` 

Then in the script you need to set the directory in which you want to download the music. 
make the script executable:

```chmod +x yt-playlist-to-mp3.sh```

Then you just have to execute the script :

```./yt-playlist-to-mp3.sh -d /home/user/youneedtochangethis -u  https://music.youtube.com/playlist?list=RDCLAK5uy_mFeKbwD6X5axmhNcvd ```

There are 3 options: 
    -d to specify the output directory
    -u to specify the yt playlist url
    -s to specify the singlefile flag

If the -s option is used, all the videos in the playlist will be concatenated into a single file (<playlistname.mp3>)

Else the name of the files will be <artist - title.mp3>
I tried to make the final name/tags as clean as possible but if you encounter any problem I would be happy to know.


