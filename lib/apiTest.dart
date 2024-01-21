import 'package:flutter/material.dart';
import 'package:learnizer/services/search_youtube.dart';
import 'dart:io';


void main() {
  runApp(const MyApp());

  /*
  final apiKey = "AIzaSyD8fb_6QDAN0gVtRjqsRMCzojlS9XYXBeQ";
  final searchQuery = "maths";

  final url = Uri.parse(
      "https://youtube.googleapis.com/youtube/v3/search?part=snippet&maxResults=25&order=rating&q=$searchQuery&key=$apiKey");

  final response = await http.get(url);

  if (response.statusCode == 200) {
    // La solicitud fue exitosa
    final Map<String, dynamic> data = json.decode(response.body);
    // Extraer información de los videos (filtrar solo videos)
    List<dynamic> items = data['items'];
    for (var item in items) {
      var kind = item['id']['kind'];
      if (kind == 'youtube#video') {
        var videoId = item['id']['videoId'];
        var title = item['snippet']['title'];
        var thumbnail = item['snippet']['thumbnails']['high']['url'];
        print('Video ID: $videoId, Title: $title, Thumbnail: $thumbnail');
      }
    }
  } else {
    // La solicitud falló con un código de estado diferente de 200
    print("Error: ${response.statusCode}");
    print("Mensaje: ${response.body}");
  }*/
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SearchPage(),
    );
  }
}