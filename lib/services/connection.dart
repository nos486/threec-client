import 'package:dio/dio.dart';

class Connection{
  Dio dio = new Dio();

  Future<Response> post({path,data}) async {
    try{
      return await dio.post(path,data:data);
    } on DioError catch(e){
      if (e.response != null){
        return e.response;
      }else{
        return new Response(data: {"message":"Server error"});
      }
    }
  }




}