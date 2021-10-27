import 'package:dio/dio.dart';

class DioHelper
{
  static Dio? dio;
  static init() async
  {
    dio = Dio(
      BaseOptions(
       baseUrl: 'https://student.valuxapps.com/api/',
        receiveDataWhenStatusError: true,
      ),
    );
  }
   static Future<Response> getData({
     Map<String , dynamic>? query,
    required String url,
     String lang = 'en',
     String? token ,
}) async
  {
    dio!.options.headers=
    {
      'lang': lang,
      'Authorization': token??'',
      'Content-Type':'application/json',
    };
   return await dio!.get(
       url,
       queryParameters: query,
   );
  }

  static Future<Response> postData({
    Map<String , dynamic>? query,
    required Map<String , dynamic> date,
    required String url,
    String lang = 'en',
    String? token ,
})
  {
    dio!.options.headers=
    {
      'lang': lang,
      'Authorization': token,
      'Content-Type':'application/json',
    };
      return dio!.post(
        url,
        queryParameters: query,
        data: date,
      );
  }

  static Future<Response> putData({
    Map<String , dynamic>? query,
    required Map<String , dynamic> date,
    required String url,
    String lang = 'en',
    String? token ,
  })
  {
    dio!.options.headers=
    {
      'lang': lang,
      'Authorization': token,
      'Content-Type':'application/json',
    };
    return dio!.put(
      url,
      queryParameters: query,
      data: date,
    );
  }
}
