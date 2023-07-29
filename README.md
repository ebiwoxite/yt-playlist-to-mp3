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

```./yt-playlist-to-mp3.sh https://music.youtube.com/playlist?list=RDCLAK5uy_mFeKbwD6X5axmhNcvd ```

And it should work fine.
