import 'dart:developer';
import 'dart:io';

import 'package:duel_links_meta/util/index.dart';
import 'package:get/get_connect/connect.dart';

extension FutureEx<T> on Future<Response<T>> {

  Future<(Exception?, T?)> get toCatch async{
      log('进入自定义 toCatch');

      try {
        var res = await this;
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
}