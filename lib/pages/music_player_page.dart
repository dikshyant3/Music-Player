import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:music_player/model/song_model.dart';
import 'package:music_player/provider/song_provider.dart';
import 'package:provider/provider.dart';

class MusicPlayerPage extends StatefulWidget {
  final SongModel song;
  const MusicPlayerPage({super.key, required this.song});

  @override
  State<MusicPlayerPage> createState() => _MusicPlayerPageState();
}

class _MusicPlayerPageState extends State<MusicPlayerPage> {

  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SongProvider>().playSong(widget.song);
    });
  }

  String formatDuration(Duration duration){
    String twoDigits(int n) => n.toString().padLeft(2,'0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Now Playing',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ), 
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Icon(
                Icons.star_sharp,
                size: 18,
                color: Colors.yellow,
                ),
            )
          ],
      ),
      body: Consumer<SongProvider>(
        builder: (context, songProvider, child){
          final currentSong = songProvider.currentSong ?? widget.song;

          return Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              children: [
                Spacer(),

                // Album Cover
                Container(
                  width: 280,
                  height: 280,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(30),
                        blurRadius: 20,
                        offset: Offset(0, 10)
                      )
                    ]
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: CachedNetworkImage(
                      imageUrl: currentSong.albumCover,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.grey[700],
                        child: Icon(
                          Icons.music_note,
                          size: 64,
                          color: Colors.grey[500],
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[700],
                        child: Icon(Icons.music_note, size: 64, color: Colors.grey[500]),
                      ),
                      ),
                  ),
                ),
                SizedBox(height: 40),

                // Song Info
                Text(
                  currentSong.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8),
                Text(
                  currentSong.artistName,
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 4),
                Text(
                  currentSong.albumTitle,
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 40),
                Column(
                  children: [
                    Slider(
                    value: songProvider.position.inSeconds.toDouble(), 
                    max: songProvider.duration.inSeconds.toDouble().clamp(1.0,double.infinity),
                    onChanged: (value){
                      songProvider.seekTo(Duration(seconds: value.toInt()));
                    },
                    activeColor: Colors.blue,
                    inactiveColor: Colors.grey[700],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            formatDuration(songProvider.position),
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 12
                            )
                          ),
                          Text(
                            formatDuration(songProvider.duration),
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 12,
                            )
                          )
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: (){
                        songProvider.seekTo(
                          Duration(
                            seconds: (songProvider.position.inSeconds - 10).clamp(0, songProvider.duration.inSeconds),
                          )
                        );
                      }, 
                      icon: Icon(
                        Icons.replay_10,
                        color: Colors.white,
                        size: 32,
                        )
                      ),
                    SizedBox(width: 20),
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withAlpha(30),
                            blurRadius: 15,
                            offset: Offset(0, 5),
                          )
                        ]
                      ),
                      child: IconButton(
                        onPressed: () => songProvider.togglePlayPause(), 
                        icon: Icon(
                          songProvider.isPlaying ? Icons.pause : Icons.play_arrow,
                        )
                        ),
                    ),
                    SizedBox(width: 20),
                    IconButton(
                      onPressed: (){
                        songProvider.seekTo(
                          Duration(
                            seconds: (songProvider.position.inSeconds + 10).clamp(0, songProvider.duration.inSeconds),
                          )
                        );
                      },
                      icon: Icon(
                        Icons.forward_10,
                        color: Colors.white,
                        size: 32,
                      )
                    )
                  ],
                ),
                Spacer(),
              ],
            ),
          );
        }
      ),
    );
  }
}