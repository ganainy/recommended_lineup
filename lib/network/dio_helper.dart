import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:recommended_lineup/constants.dart';

class DioHelper {
  static late Dio dio;

  static init() {
    dio = Dio(BaseOptions(
      baseUrl: 'https://api.spitch.live/',
      receiveDataWhenStatusError: true,
    ));

    //to fix HandshakeException
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
  }

  //get the json including players and clubs data from api
  static Future<Response> loadApiData() async {
    String path = 'contestants';
    var queryParams = {competitionId: '6by3h89i2eykc341oz7lv1ddd'};
    return await dio.get(path, queryParameters: queryParams);
  }
}
