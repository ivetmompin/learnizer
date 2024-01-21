import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:convert';
import 'package:http/http.dart' as http;

class VideoItem extends StatelessWidget {
  final Map<String, dynamic> video;

  VideoItem({required this.video});


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          /*
           Image.network(
          'https://th.bing.com/th/id/R.428f2be34beaf9519e507cc95cbbf9f6?rik=WB7Bx2a1rJqR%2bg&riu=http%3a%2f%2fimagenpng.com%2fwp-content%2fuploads%2f2017%2f01%2fF6D.jpg&ehk=lx9avLs7V2pORruxJhCUrdsMC4eoSZA0kZeDM9Y2Am8%3d&risl=&pid=ImgRaw&r=0', // Reemplaza con la URL de tu imagen
            width: 200.0, // Ajusta el ancho según tus necesidades
            height: 200.0, // Ajusta la altura según tus necesidades
            fit: BoxFit.cover, // Ajusta cómo se escala la imagen
          ),*/
          Image.network(
           video['thumbnail'], // Reemplaza con la URL de tu imagen
            width: 200.0, // Ajusta el ancho según tus necesidades
            height: 200.0, // Ajusta la altura según tus necesidades
            fit: BoxFit.cover, // Ajusta cómo se escala la imagen
          ),

          CachedNetworkImage(
            imageUrl: video['thumbnail'],
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.error),
            width: 100,
            height: 100,
            fit: BoxFit.cover,

          ),

          SizedBox(height: 8.0),
          Text(video['title']),
        ],
      ),
    );
  }
}
