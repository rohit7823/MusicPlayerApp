import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:music_player_app/models/response.dart' as m;
import 'package:retrofit/http.dart';

import '../models/response.dart';

part 'sub_categories_api.g.dart';

@RestApi(parser: Parser.FlutterCompute)
abstract class SubCategoriesApi {
  factory SubCategoriesApi(Dio dio, {String? baseUrl}) = _SubCategoriesApi;

  @GET("/frontend/getsubcategory/0")
  Future<m.Response> categories0();

  @GET("/frontend/getsubcategory/1")
  Future<m.Response> categories1();

  @GET("/frontend/getsubcategory/2")
  Future<m.Response> categories2();

  @GET("/frontend/getsubcategory/3")
  Future<m.Response> categories3();
}
