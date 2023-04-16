import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:giphy_gif/common/const/colors.dart';
import 'package:giphy_gif/gif/provider/gif_provider.dart';
import 'package:giphy_gif/gif/widget/gif_tile.dart';

class GifSearchScreen extends ConsumerStatefulWidget {
  const GifSearchScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<GifSearchScreen> createState() => _GifSearchScreenState();
}

class _GifSearchScreenState extends ConsumerState<GifSearchScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Timer? _debounceTimer;

  @override
  void dispose() {
    _textEditingController.dispose();
    _scrollController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _scrollController.addListener(() {
      double maxScroll = _scrollController.position.maxScrollExtent;
      double currentScroll = _scrollController.position.pixels;
      double delta = MediaQuery.of(context).size.width * 0.36;

      if (maxScroll - currentScroll <= delta) {
        ref
            .read(gifListProvider.notifier)
            .gifFetchMore(_textEditingController.text);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Giphy Search API made by TK'),
      ),
      backgroundColor: BACKGROUND_COLOR,
      body: Column(
        children: [
          TextField(
            controller: _textEditingController,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
            cursorColor: Colors.white,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 8),
            ),
            onChanged: (value) {
              if (_debounceTimer?.isActive ?? false) {
                _debounceTimer?.cancel();
              }
              _debounceTimer = Timer(
                const Duration(milliseconds: 300),
                () {
                  if (value.isNotEmpty) {
                    ref.watch(gifListProvider.notifier).gifSearch(value);
                  }
                },
              );
            },
          ),
          const SizedBox(height: 4),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Consumer(
                builder: (context, watch, child) {
                  final gifs = ref.watch(gifListProvider);
                  return GridView.builder(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1,
                    ),
                    controller: _scrollController,
                    itemCount: gifs.length,
                    itemBuilder: (context, index) => GifTile(gif: gifs[index]),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}