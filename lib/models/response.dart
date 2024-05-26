import 'dart:async';

import 'package:json_annotation/json_annotation.dart';

part 'response.g.dart';

FutureOr<Response> deserializeResponse(Map<String, dynamic> json) =>
    Response.fromJson(json);

FutureOr<Map<String, dynamic>> serializeResponse(Response object) =>
    object.toJson();

@JsonSerializable()
class Response {
  @JsonKey(name: "data")
  final Data? data;

  Response({
    this.data,
  });

  Response copyWith({
    Data? data,
  }) =>
      Response(
        data: data ?? this.data,
      );

  factory Response.fromJson(Map<String, dynamic> json) =>
      _$ResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ResponseToJson(this);
}

@JsonSerializable()
class Data {
  @JsonKey(name: "success")
  final int? success;
  @JsonKey(name: "music")
  final List<Music>? music;

  Data({
    this.success,
    this.music,
  });

  Data copyWith({
    int? success,
    List<Music>? music,
  }) =>
      Data(
        success: success ?? this.success,
        music: music ?? this.music,
      );

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

  Map<String, dynamic> toJson() => _$DataToJson(this);
}

@JsonSerializable()
class Music {
  @JsonKey(name: "id")
  final int? id;
  @JsonKey(name: "name")
  final String? name;
  @JsonKey(name: "genre")
  final String? genre;
  @JsonKey(name: "occasion")
  final String? occasion;
  @JsonKey(name: "mood")
  final String? mood;
  @JsonKey(name: "amount")
  final String? amount;
  @JsonKey(name: "duration")
  final String? duration;
  @JsonKey(name: "music_file")
  final String? musicFile;
  @JsonKey(name: "image")
  final String? image;
  @JsonKey(name: "description")
  final String? description;
  @JsonKey(name: "template")
  final List<List<Template>>? template;

  Music({
    this.id,
    this.name,
    this.genre,
    this.occasion,
    this.mood,
    this.amount,
    this.duration,
    this.musicFile,
    this.image,
    this.description,
    this.template,
  });

  Music copyWith({
    int? id,
    String? name,
    String? genre,
    String? occasion,
    String? mood,
    String? amount,
    String? duration,
    String? musicFile,
    String? image,
    String? description,
    List<List<Template>>? template,
  }) =>
      Music(
        id: id ?? this.id,
        name: name ?? this.name,
        genre: genre ?? this.genre,
        occasion: occasion ?? this.occasion,
        mood: mood ?? this.mood,
        amount: amount ?? this.amount,
        duration: duration ?? this.duration,
        musicFile: musicFile ?? this.musicFile,
        image: image ?? this.image,
        description: description ?? this.description,
        template: template ?? this.template,
      );

  factory Music.fromJson(Map<String, dynamic> json) => _$MusicFromJson(json);

  Map<String, dynamic> toJson() => _$MusicToJson(this);
}

@JsonSerializable()
class Template {
  @JsonKey(name: "id")
  final int? id;
  @JsonKey(name: "song__name")
  final String? songName;
  @JsonKey(name: "templateFile")
  final String? templateFile;
  @JsonKey(name: "mstart")
  final int? mstart;
  @JsonKey(name: "messlength")
  final int? messlength;
  @JsonKey(name: "songlength")
  final int? songlength;

  Template({
    this.id,
    this.songName,
    this.templateFile,
    this.mstart,
    this.messlength,
    this.songlength,
  });

  Template copyWith({
    int? id,
    String? songName,
    String? templateFile,
    int? mstart,
    int? messlength,
    int? songlength,
  }) =>
      Template(
        id: id ?? this.id,
        songName: songName ?? this.songName,
        templateFile: templateFile ?? this.templateFile,
        mstart: mstart ?? this.mstart,
        messlength: messlength ?? this.messlength,
        songlength: songlength ?? this.songlength,
      );

  factory Template.fromJson(Map<String, dynamic> json) =>
      _$TemplateFromJson(json);

  Map<String, dynamic> toJson() => _$TemplateToJson(this);
}
