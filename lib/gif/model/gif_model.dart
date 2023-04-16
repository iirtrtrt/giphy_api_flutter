import 'package:json_annotation/json_annotation.dart';
part 'gif_model.g.dart';

@JsonSerializable()
class GifModel {
  final String id;
  final String title;
  final String previewGifUrl;
  final String originalUrl;

  GifModel({
    required this.id,
    required this.title,
    required this.previewGifUrl,
    required this.originalUrl,
  });

  factory GifModel.fromJson(Map<String, dynamic> json) {
    final images = json['images'] as Map<String, dynamic>;
    final original = images['original'] as Map<String, dynamic>;
    final previewGifUrl = images['preview_gif'] as Map<String, dynamic>;

    return _$GifModelFromJson({
      ...json,
      'id': json['id'],
      'title': json['title'],
      'previewGifUrl': previewGifUrl['url'],
      'originalUrl': original['url'],
    });
  }

  Map<String, dynamic> toJson() => _$GifModelToJson(this);
}
