// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gif_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GifModel _$GifModelFromJson(Map<String, dynamic> json) => GifModel(
      id: json['id'] as String,
      title: json['title'] as String,
      previewGifUrl: json['previewGifUrl'] as String,
      originalUrl: json['originalUrl'] as String,
    );

Map<String, dynamic> _$GifModelToJson(GifModel instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'previewGifUrl': instance.previewGifUrl,
      'originalUrl': instance.originalUrl,
    };
