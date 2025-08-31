import 'package:flutter/material.dart';
import 'package:music_player/pages/music_player_page.dart';
import 'package:music_player/provider/song_provider.dart';
import 'package:music_player/widgets/song_card_widget.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState(){
    super.initState();
    _searchController.addListener((){
      if (_searchController.text.trim().isEmpty){
        context.read<SongProvider>().clearSearch();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Beatly'),
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16.0),
            color: Colors.grey[850],
            child: TextField(
              controller: _searchController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search for artists, songs, ...',
                hintStyle: TextStyle(color: Colors.grey[400]),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey[400],
                  ),
                filled: true,
                fillColor: Colors.grey[800],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
              onChanged: (value) {
                if (value.trim().isEmpty){
                  context.read<SongProvider>().clearSearch();
                }
                else{
                  context.read<SongProvider>().searchSongs(value.trim());
                }
              },
              onSubmitted: (value) {
                if(value.trim().isNotEmpty){
                  context.read<SongProvider>().searchSongs(value.trim());
                }
              },
            )
          ),
          Expanded(
            child: Consumer<SongProvider>(
              builder: (context, songProvider, child){
                if(songProvider.isLoading){
                  return Center(
                    child: CircularProgressIndicator(color: Colors.blue,),
                  );
                }

                if(songProvider.searchResults.isEmpty){
                  return Center(
                    child: Column(
                      children: [
                        Padding(padding: EdgeInsets.all(16)),
                        Icon(
                          Icons.music_note,
                          size: 64,
                          color: Colors.grey[600],
                        ),
                        SizedBox(height: 16,),
                        Text(
                          'Search for your favorite music',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: songProvider.searchResults.length,
                  itemBuilder: (context, index) {
                    final song = songProvider.searchResults[index];
                    return SongCardWidget(
                      song: song,
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MusicPlayerPage(song: song),
                            )
                          );
                      }
                    );
                  },
                );
              }
            ),
          )
        ],
      )
    );
  }

  @override
  void dispose(){
    _searchController.dispose();
    super.dispose();
  }
}