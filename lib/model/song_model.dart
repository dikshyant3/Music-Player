class SongModel {
  final String title;
  final String artistName;
  final String albumCover;
  final String previewUrl;
  final String albumTitle;

  SongModel({
    required this.title,
    required this.artistName,
    required this.albumCover,
    required this.previewUrl,
    required this.albumTitle
  });

  factory SongModel.fromJson(Map<String,dynamic> json){
    return SongModel(
      title: json['title'] ?? 'Unknown Title', 
      artistName: json['artist']?['name'] ?? 'Unknown Artist', 
      albumCover: json['album']?['cover_medium'] ?? json['album']?['cover_small'] ?? '', 
      previewUrl: json['preview'] ?? '',
      albumTitle: json['album']?['title'] ?? 'Unknown Album',
      );
  }
}