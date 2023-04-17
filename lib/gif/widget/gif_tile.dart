import 'package:flutter/material.dart';
import 'package:giphy_gif/common/const/colors.dart';
import 'package:giphy_gif/gif/model/gif_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:giphy_gif/gif/widget/gif_dialog.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class GifTile extends StatefulWidget {
  final GifModel gif;

  const GifTile({Key? key, required this.gif}) : super(key: key);

  @override
  State<GifTile> createState() => _GifTileState();
}

class _GifTileState extends State<GifTile> {
  double padding = 4.0;

  void updatePadding(double paddingValue) {
    setState(() {
      padding = paddingValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: (details) {
        updatePadding(12.0);
      },
      onLongPressEnd: (details) {
        showScaleDialog(context, widget.gif);
        updatePadding(4.0);
      },
      child: AnimatedPadding(
        padding: EdgeInsets.all(padding),
        duration: const Duration(milliseconds: 200),
        child: CachedNetworkImage(
          imageUrl: widget.gif.previewGifUrl,
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
          placeholder: (context, url) => Shimmer(
            colorOpacity: 0.08,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: PRIMARY_COLOR,
              ),
            ),
          ),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
      ),
    );
  }
}
