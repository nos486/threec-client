import 'package:dio/dio.dart';
import 'package:threec/models/user.dart';
import 'package:threec/services/connection.dart';
import 'package:threec/services/urls.dart';

class Authentication{
  Connection server = new Connection();

  Future<Response> login(username,password,captcha,captchaKey) async {
    return await server.post(path: loginPath,data: {
      "username" : username,
      "password": password,
      "captcha" : captcha,
      "captchaKey" : captchaKey
    });
  }

  Future<Response> refresh(token) async {
    return await server.post(path: refreshPath,data: {
      "token" : token
    });
  }




}