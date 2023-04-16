import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:giphy_gif/gif/model/gif_model.dart';
import 'package:giphy_gif/gif/repository/gif_repository.dart';

final gifRepositoryProvider = Provider((ref) => GifRepositoryProvider());

final gifListProvider = StateNotifierProvider<GifStateNotifier, List<GifModel>>(
  (ref) => GifStateNotifier(ref.watch(gifRepositoryProvider)),
);

class GifStateNotifier extends StateNotifier<List<GifModel>> {
  final GifRepositoryProvider _gifRepositoryProvider;
  int _offset = 0;

  GifStateNotifier(this._gifRepositoryProvider) : super([]);

  Future<void> gifSearch(String query) async {
    _offset = 0;
    state = await _gifRepositoryProvider.gifSearch(query, _offset);
  }

  Future<void> gifFetchMore(String query) async {
    _offset += 20;
    final List<GifModel> newGifs =
        await _gifRepositoryProvider.gifSearch(query, _offset);
    state = [...state, ...newGifs];
  }
}
