import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:learnizer/services/video_item.dart';


class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> videoList = [];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: "Search videos",
          ),
          onSubmitted: (query) => _performSearch(query),
        ),
      ),


      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: videoList.length,
        itemBuilder: (context, index) {
          return VideoItem(video: videoList[index]);
        },
      ),
    );
  }
}
