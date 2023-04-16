import 'package:flutter/material.dart';
import 'package:giphy_gif/gif/model/gif_model.dart';

class GifTile extends StatelessWidget {
  final GifModel gif;

  const GifTile({Key? key, required this.gif}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.network(gif.previewGifUrl),
      title: Text(gif.title),
    );
  }
}
