import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:giphy_gif/common/const/colors.dart';
import 'package:giphy_gif/gif/model/gif_model.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:url_launcher/url_launcher.dart';

Widget gifDialog(BuildContext context, GifModel gif) {
  Size screenSize = MediaQuery.of(context).size;
  double width = screenSize.width;

  Future<void> openUrl(String url) async {
    final _url = Uri.parse(url);
    if (!await launchUrl(_url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $_url');
    }
  }

  return AlertDialog(
    backgroundColor: BACKGROUND_COLOR,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    title: Text(
      gif.title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
    ),
    content: SizedBox(
      height: 240,
      width: width,
      child: CachedNetworkImage(
        imageUrl: gif.originalUrl,
        placeholder: (context, url) => Shimmer(
          child: Container(
            color: PRIMARY_COLOR,
          ),
        ),
        fit: BoxFit.contain,
        errorWidget: (context, url, error) => const Icon(Icons.error),
      ),
    ),
    actions: [
      ElevatedButton(
        onPressed: () async {
          openUrl(gif.originalUrl);
        },
        child: const Text('Open in Browser'),
      ),
      ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(
            'Close',
            style: TextStyle(
              color: Colors.red,
              fontSize: 16,
            ),
          ))
    ],
  );
}

void showScaleDialog(BuildContext context, GifModel gif) {
  showGeneralDialog(
    context: context,
    pageBuilder: (ctx, a1, a2) {
      return const SizedBox.shrink();
    },
    transitionBuilder: (ctx, a1, a2, child) {
      var curve = Curves.easeInOut.transform(a1.value);
      return Transform.scale(
        scale: curve,
        child: gifDialog(ctx, gif),
      );
    },
    transitionDuration: const Duration(milliseconds: 320),
  );
}
