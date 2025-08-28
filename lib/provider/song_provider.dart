import 'package:flutter/widgets.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/model/song_model.dart';
import 'package:music_player/services/song_service.dart';

class SongProvider with ChangeNotifier{
  static final SongProvider _instance = SongProvider._internal();
  factory SongProvider() => _instance;
  

  final SongService _songService = SongService();
  final AudioPlayer _audioPlayer = AudioPlayer();

  List<SongModel> _searchResults = [];
  SongModel? _currentSong;
  bool _isLoading = false;
  bool _isPlaying = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  AudioPlayer get audioPlayer => _audioPlayer;
  List<SongModel> get searchResults => _searchResults;
  SongModel? get currentSong => _currentSong;
  bool get isLoading => _isLoading;
  bool get isPlaying => _isPlaying;
  Duration get position => _position;
  Duration get duration => _duration;

  SongProvider._internal() {
    _audioPlayer.positionStream.listen((position) {
      _position = position;
      notifyListeners();
    });

    _audioPlayer.durationStream.listen((duration){
      _duration = duration ?? Duration.zero;
      notifyListeners();
    });

    _audioPlayer.playerStateStream.listen((playerState){
      _isPlaying = playerState.playing;
      notifyListeners();
    });
  }

  Future<void> searchSongs(String query) async{
    if (query.trim().isEmpty) return;
    
    _isLoading = true;
    notifyListeners();

    try {
      _searchResults = await _songService.searchSongs(query);
    } catch (e) {
      debugPrint('Error searching the songs: $e');
    }
    finally{
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> playSong(SongModel song) async{
    try{
      _currentSong = song;
      notifyListeners();

      await _audioPlayer.setUrl(song.previewUrl);
      await _audioPlayer.play();
    } catch(e){
      debugPrint('Error playing the songs: $e');
    }
  }

  Future<void> togglePlayPause() async{
    if(_isPlaying){
      await _audioPlayer.pause();
    }
    else{
      await _audioPlayer.play();
    }
  }

  Future<void> seekTo(Duration position) async{
    await _audioPlayer.seek(position);
  }

  void clearSearch(){
    _searchResults = [];
    notifyListeners();
  }

  @override
  void dispose(){
    _audioPlayer.dispose();
    super.dispose();
  }
}