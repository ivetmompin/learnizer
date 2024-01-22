import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:learnizer/Business/utilities_learnize.dart';
import 'package:learnizer/Views/Visualize/Individual/view_task.dart';
import 'package:learnizer/services/play_video.dart';
import 'package:learnizer/services/video_item.dart';

import '../Models/user_model.dart';


class SearchPage extends StatefulWidget {
  final UserModel user;
  final int directoryIndex;
  final int taskIndex;
  const SearchPage({required this.user,required this.directoryIndex, required this.taskIndex, Key? key}) : super(key: key);
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> videoList = [];
  UtilitiesLearnizer utilities = UtilitiesLearnizer();
  late final UserModel user = widget.user;
  late final int _directoryIndex = widget.directoryIndex;
  late final int _taskIndex = widget.taskIndex;

  Future<String> getThemeFromUtilities(String file) async {
    String imageUrl = await utilities.getTheme(file);
    return imageUrl;
  }

  Future<void> _performSearch(String query) async {
    final apiKey = "AIzaSyD8fb_6QDAN0gVtRjqsRMCzojlS9XYXBeQ";

    final url = Uri.parse(
      "https://youtube.googleapis.com/youtube/v3/search?part=snippet&maxResults=25&order=rating&q=$query&key=$apiKey",
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        //Clean list
        setState(() {
          videoList.clear();
        });

        List<dynamic> items = data['items'];
        for (var item in items) {
          var kind = item['id']['kind'];
          if (kind == 'youtube#video') {
            var videoId = item['id']['videoId'];
            var title = item['snippet']['title'];
            var thumbnail = item['snippet']['thumbnails']['high']['url'];
            print('Video ID: $videoId, Title: $title, Thumbnail: $thumbnail');

            //Add it to the list
            setState(() {
              videoList.add({
                'videoId': videoId,
                'title': title,
                'thumbnail': thumbnail,
              });
            });
          }
        }
      } else {
        // Error in the request
        print("Error: ${response.statusCode}");
        print("Mensaje: ${response.body}");
      }
    } catch (e) {
      // Manejar cualquier error durante la solicitud
      print("Error: $e");
    }
  }

  void _navigateToVideoPlayer(String videoId) {
    // Use Navigator to push a new page (you need to implement VideoPlayerPage)
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlayVideo(videoID: videoId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        // Use FutureBuilder to wait for the image URLs
        future: Future.wait([getThemeFromUtilities("learnizer.png"),]),
        builder: (context, snapshot) {
          // Render the UI once the image URLs are fetched
          return Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: utilities.getCorrectColors(user.theme),
                    )
                ),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 60
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                                weight: 9,
                                size: 30, // Set the size of the icon to make it bigger
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ViewTaskPage(user: user,
                                            directoryIndex: _directoryIndex,
                                            taskIndex: _taskIndex),
                                  ),
                                );
                              },
                            ),
                          ]
                      ),
                      buildSearchBox(),
                      Text(
                        "Tutorials",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height:20),
                      for(int i=0;i<videoList.length;i++)
                        buildTile(videoList[i],i)
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  buildTiles(){

  }

  buildSearchBox() {
    return Container(
      margin: EdgeInsets.only(top: 20, bottom: 40),
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20)
      ),
      child: TextField(
        controller: _searchController,
        obscureText: false,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          prefixIcon: Icon(
              Icons.search, color: utilities.returnColorByTheme(user.theme),
              size: 20),
          prefixIconConstraints: const BoxConstraints(
            maxHeight: 20,
            minWidth: 25,
          ),
          border: InputBorder.none,
          hintText: "Need tutorials? Enter keyword",
          hintStyle: const TextStyle(color: Colors.grey),
        ),
        onSubmitted: (query) => _performSearch(query),
      ),
    );
  }

  buildTile(Map<String,dynamic> video, int index){
    return Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.white,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        margin: EdgeInsets.only(bottom: 10),
        child: ListTile(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      PlayVideo(videoID: video['videoId'],),
                ),
              );
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            tileColor: Colors.transparent,
            leading: CachedNetworkImage(
              imageUrl: video['thumbnail'],
              width: 30,height: 30,
            ),
            title: Text(
              video['title'],
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
        )
    );
  }
}