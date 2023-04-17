import 'package:flutter_test/flutter_test.dart';
import 'package:giphy_gif/gif/provider/gif_provider.dart';
import 'package:riverpod/riverpod.dart';
import 'package:giphy_gif/gif/model/gif_model.dart';
import 'package:giphy_gif/gif/repository/gif_repository.dart';

class MockGifRepositoryProvider1 extends GifRepositoryProvider {
  @override
  Future<List<GifModel>> gifSearch(String query, int offset) async {
    return List.generate(
        20,
        (index) => GifModel(
              id: '3ohc17vHyD0gSHxHmo',
              title: 'Winter Olympics Flirt GIF by Team USA',
              previewGifUrl:
                  'https://media2.giphy.com/media/3ohc17vHyD0gSHxHmo/giphy-preview.gif?cid=69df738fz84s0illbb3qn7jaxlipnvklpn0g9jemyaqjxc6x&rid=giphy-preview.gif&ct=g',
              originalUrl:
                  'https://media2.giphy.com/media/3ohc17vHyD0gSHxHmo/giphy.gif?cid=69df738fz84s0illbb3qn7jaxlipnvklpn0g9jemyaqjxc6x&rid=giphy.gif&ct=g',
            ));
  }
}

class MockGifRepositoryProvider2 extends GifRepositoryProvider {
  @override
  Future<List<GifModel>> gifSearch(String query, int offset) async {
    return [];
  }
}

void main() {
  group('gif provider test', () {
    test('gifSearch', () async {
      final container = ProviderContainer(
        overrides: [
          gifRepositoryProvider.overrideWithValue(MockGifRepositoryProvider1()),
        ],
      );

      final notifier = container.read(gifProvider.notifier);
      await notifier.gifSearch('search');

      final state = container.read(gifProvider);

      expect(state.data, isNotEmpty);
      expect(state.isLoading, false);
      expect(state.fetchDone, false);
    });

    test('gifSearch and then gifFetchMore', () async {
      final container = ProviderContainer(
        overrides: [
          gifRepositoryProvider.overrideWithValue(MockGifRepositoryProvider1()),
        ],
      );

      final notifier = container.read(gifProvider.notifier);
      await notifier.gifSearch('search');
      await notifier.gifFetchMore('search');

      final state = container.read(gifProvider);

      expect(state.data.length, 40);
      expect(state.isLoading, false);
      expect(state.fetchDone, false);
    });

    test('if gifFetchMore returns an empty list, fetchDone becomes true',
        () async {
      final container = ProviderContainer(
        overrides: [
          gifRepositoryProvider.overrideWithValue(MockGifRepositoryProvider2()),
        ],
      );

      final notifier = container.read(gifProvider.notifier);
      await notifier.gifFetchMore('search');

      final state = container.read(gifProvider);

      expect(state.data, isEmpty);
      expect(state.isLoading, false);
      expect(state.fetchDone, true);
    });
  });
}
