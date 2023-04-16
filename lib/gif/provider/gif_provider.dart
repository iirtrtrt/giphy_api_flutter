import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:giphy_gif/gif/model/gif_model.dart';
import 'package:giphy_gif/gif/repository/gif_repository.dart';

final gifRepositoryProvider = Provider((ref) => GifRepositoryProvider());

final gifProvider = StateNotifierProvider<GifStateNotifier, GifState>(
  (ref) => GifStateNotifier(ref.watch(gifRepositoryProvider)),
);

class GifState {
  final List<GifModel> data;
  final bool isLoading;
  final bool hasError;

  const GifState({
    this.data = const [],
    this.isLoading = false,
    this.hasError = false,
  });
}

class GifStateNotifier extends StateNotifier<GifState> {
  final GifRepositoryProvider _gifRepositoryProvider;
  int _offset = 0;

  GifStateNotifier(this._gifRepositoryProvider) : super(const GifState());

  Future<void> gifSearch(String query) async {
    try {
      state = GifState(isLoading: true, data: state.data);
      _offset = 0;

      final data = await _gifRepositoryProvider.gifSearch(query, _offset);
      state = GifState(data: data);
    } catch (e) {
      state = const GifState(hasError: true);
    } finally {
      state = GifState(data: state.data, isLoading: false);
    }
  }

  Future<void> gifFetchMore(String query) async {
    try {
      state = GifState(isLoading: true, data: state.data);
      _offset += 20;

      final List<GifModel> newGifs =
          await _gifRepositoryProvider.gifSearch(query, _offset);
      if (newGifs.isNotEmpty) {
        state = GifState(data: [...state.data, ...newGifs]);
      }
    } catch (e) {
      state = const GifState(hasError: true);
    } finally {
      state = GifState(data: state.data, isLoading: false);
    }
  }
}
