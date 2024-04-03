import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get_connect/http/src/response/response.dart';

class Util {
  static Future<(Exception?, T?)> toCatch<T>(Future<Response<T>> fn) async {
    try {
      var res = await fn;
      log('[toCatch] code: ${res.statusCode}, body is null: ${res.body == null}, statusText: ${res.statusText}');

      if (res.statusCode != 200) {
        return (HttpException('status: ${res.statusCode}, msg: ${res.statusText}'), null);
      }

      if (res.body == null) {
        return (const HttpException('response body is null'), res.body);
      }

      return (null, res.body);
    } catch (err) {
      return (HttpException(err.toString()), null);
    }
  }

  static bool isReachBottom(ScrollController controller, {int threshold = 200}) {
    return controller.position.maxScrollExtent - controller.position.pixels <= threshold;
  }
}
