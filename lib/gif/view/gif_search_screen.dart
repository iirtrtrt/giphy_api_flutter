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
    final state = ref.watch(gifProvider);

    _scrollController.addListener(() {
      double maxScroll = _scrollController.position.maxScrollExtent;
      double currentScroll = _scrollController.position.pixels;
      double delta = MediaQuery.of(context).size.width * 0.36;

      if (maxScroll - currentScroll <= delta &&
          !state.isLoading &&
          !state.fetchDone) {
        ref
            .read(gifProvider.notifier)
            .gifFetchMore(_textEditingController.text);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Giphy Search API'),
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
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
              hintText: 'Search',
              hintStyle: TextStyle(
                color: Colors.grey[400],
              ),
            ),
            onChanged: (value) {
              if (state.data.isNotEmpty) {
                _scrollController.animateTo(0,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOut);
              }
              if (_debounceTimer?.isActive ?? false) {
                _debounceTimer?.cancel();
              }
              _debounceTimer = Timer(
                const Duration(milliseconds: 300),
                () {
                  if (value.isNotEmpty) {
                    ref.watch(gifProvider.notifier).gifSearch(value);
                  }
                },
              );
            },
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              child: state.data.isNotEmpty
                  ? ScrollConfiguration(
                      behavior: state.isLoading
                          ? NoGlowScrollBehavior()
                          : const ScrollBehavior(),
                      child: GridView.builder(
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1,
                        ),
                        controller: _scrollController,
                        itemCount: state.data.length,
                        itemBuilder: (context, index) =>
                            GifTile(gif: state.data[index]),
                      ),
                    )
                  : const Center(
                      child: Text(
                        'Let us search GIF! :D',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
            ),
          ),
          state.isLoading
              ? const Padding(
                  padding: EdgeInsets.only(top: 4, bottom: 12),
                  child: CircularProgressIndicator(),
                )
              : const SizedBox.shrink(),
          state.hasError
              ? const Padding(
                  padding: EdgeInsets.only(top: 4, bottom: 12),
                  child: Text("Something went to wrong..."),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}

class NoGlowScrollBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
