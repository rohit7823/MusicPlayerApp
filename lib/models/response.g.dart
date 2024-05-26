// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Response _$ResponseFromJson(Map<String, dynamic> json) => Response(
      data: json['data'] == null
          ? null
          : Data.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ResponseToJson(Response instance) => <String, dynamic>{
      'data': instance.data,
    };

Data _$DataFromJson(Map<String, dynamic> json) => Data(
      success: (json['success'] as num?)?.toInt(),
      music: (json['music'] as List<dynamic>?)
          ?.map((e) => Music.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'success': instance.success,
      'music': instance.music,
    };

Music _$MusicFromJson(Map<String, dynamic> json) => Music(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      genre: json['genre'] as String?,
      occasion: json['occasion'] as String?,
      mood: json['mood'] as String?,
      amount: json['amount'] as String?,
      duration: json['duration'] as String?,
      musicFile: json['music_file'] as String?,
      image: json['image'] as String?,
      description: json['description'] as String?,
      template: (json['template'] as List<dynamic>?)
          ?.map((e) => (e as List<dynamic>)
              .map((e) => Template.fromJson(e as Map<String, dynamic>))
              .toList())
          .toList(),
    );

Map<String, dynamic> _$MusicToJson(Music instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'genre': instance.genre,
      'occasion': instance.occasion,
      'mood': instance.mood,
      'amount': instance.amount,
      'duration': instance.duration,
      'music_file': instance.musicFile,
      'image': instance.image,
      'description': instance.description,
      'template': instance.template,
    };

Template _$TemplateFromJson(Map<String, dynamic> json) => Template(
      id: (json['id'] as num?)?.toInt(),
      songName: json['song__name'] as String?,
      templateFile: json['templateFile'] as String?,
      mstart: (json['mstart'] as num?)?.toInt(),
      messlength: (json['messlength'] as num?)?.toInt(),
      songlength: (json['songlength'] as num?)?.toInt(),
    );

Map<String, dynamic> _$TemplateToJson(Template instance) => <String, dynamic>{
      'id': instance.id,
      'song__name': instance.songName,
      'templateFile': instance.templateFile,
      'mstart': instance.mstart,
      'messlength': instance.messlength,
      'songlength': instance.songlength,
    };
