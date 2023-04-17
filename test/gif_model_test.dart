import 'package:flutter_test/flutter_test.dart';
import 'package:giphy_gif/gif/model/gif_model.dart';

void main() {
  group('gif model test', () {
    test('fromJson', () {
      final json = {
        'id': '3ohc17vHyD0gSHxHmo',
        'title': 'Winter Olympics Flirt GIF by Team USA',
        'images': {
          'original': {
            'url':
                'https://media2.giphy.com/media/3ohc17vHyD0gSHxHmo/giphy.gif?cid=69df738fz84s0illbb3qn7jaxlipnvklpn0g9jemyaqjxc6x&rid=giphy.gif&ct=g',
          },
          'preview_gif': {
            'url':
                'https://media2.giphy.com/media/3ohc17vHyD0gSHxHmo/giphy-preview.gif?cid=69df738fz84s0illbb3qn7jaxlipnvklpn0g9jemyaqjxc6x&rid=giphy-preview.gif&ct=g',
          },
        },
      };

      final gifModel = GifModel.fromJson(json);

      expect(gifModel.id, equals('3ohc17vHyD0gSHxHmo'));
      expect(gifModel.title, equals('Winter Olympics Flirt GIF by Team USA'));
      expect(
          gifModel.previewGifUrl,
          equals(
              'https://media2.giphy.com/media/3ohc17vHyD0gSHxHmo/giphy-preview.gif?cid=69df738fz84s0illbb3qn7jaxlipnvklpn0g9jemyaqjxc6x&rid=giphy-preview.gif&ct=g'));
      expect(
          gifModel.originalUrl,
          equals(
              'https://media2.giphy.com/media/3ohc17vHyD0gSHxHmo/giphy.gif?cid=69df738fz84s0illbb3qn7jaxlipnvklpn0g9jemyaqjxc6x&rid=giphy.gif&ct=g'));
    });
  });
}
