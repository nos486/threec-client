import 'package:dio/dio.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:threec/services/connection.dart';
import 'package:threec/services/urls.dart';

class Captcha{
  Dio dio = new Dio();


  Future<Response> getCaptcha() async {

    try{
      var res =  await dio.post(captchaPath);
      return new Response(data: {"svg": res.data,"key":res.headers['key'][0]});
    } on DioError catch(e){
      if (e.response != null){
        return e.response;
      }else{
        return new Response(data: {"message":"Server error"});
      }
    }

  }


}