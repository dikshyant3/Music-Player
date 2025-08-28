import 'package:dio/dio.dart';
import 'package:music_player/model/song_model.dart';

class SongService {
  // Singleton
  static final SongService _instance = SongService._internal();
  factory SongService() => _instance;
  SongService._internal();

  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://api.deezer.com/',
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: Duration(seconds: 3),
    ));

    Future<List<SongModel>> searchSongs(String query) async{
      try{
        final response = await _dio.get('search', queryParameters: {'q': query});
        final List<dynamic> data = response.data['data'];
        return data.map((json)=> SongModel.fromJson(json)).toList();
      }
      catch(e){
        throw Exception('Failed to search songs: $e');
      }
    }

    Future<List<SongModel>> getAlbumTracks(int albumId) async{
      try {
        final response = await _dio.get('album/$albumId');
        // Check the album api hai
        final List<dynamic> tracks = response.data['tracks']['data'];
        return tracks.map((json)=> SongModel.fromJson(json)).toList();

      } catch (e) {
        throw Exception('Failed to get the tracks: $e');
      }
    }
}
